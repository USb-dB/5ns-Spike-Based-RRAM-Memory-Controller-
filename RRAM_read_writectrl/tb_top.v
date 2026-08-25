
module mock_analog_mux1 (
    input en,
    input [1:0] datain,
    output reg [31:0] Vout1,
    output reg [31:0] Vout2
);
    // Voltage levels
    parameter [31:0] one_point_five        = 32'h3FC00000; // +1.5 
    parameter [31:0] minus_one_point_five  = 32'hBFC00000; // -1.5 
    parameter [31:0] minus_three           = 32'hC0400000; // -3.0 
    parameter [31:0] three                 = 32'h40400000; // +3.0 
    parameter [31:0] minus_zero_point_five = 32'hBF000000; // -0.5 
    parameter [31:0] minus_one             = 32'hBF800000; // -1.0 
    parameter [31:0] gnd                   = 32'h00000000; // 0.0
    parameter [31:0] plus_one              = 32'h3F800000; // +1.0 
    parameter [31:0] zero_point_five       = 32'h3F000000; // +0.5


    always @(*) begin
        if (!en) begin
            Vout1 = gnd;
            Vout2 = gnd;
        end else begin
            case (datain)
                2'b00: begin Vout1 = gnd; Vout2 = gnd; end
                2'b01: begin Vout1 = minus_one_point_five; Vout2 = minus_three; end
                2'b10: begin Vout1 = zero_point_five; Vout2 = plus_one; end
                2'b11: begin Vout1 = one_point_five; Vout2 = three; end
            endcase
        end
    end
endmodule

module mock_analog_mux2 (
    input en,
    input [1:0] datain,
    output reg [31:0] Vout1,
    output reg [31:0] Vout2
);
    // Voltage levels
    parameter [31:0] one_point_five        = 32'h3FC00000; // +1.5 
    parameter [31:0] minus_one_point_five  = 32'hBFC00000; // -1.5 
    parameter [31:0] minus_three           = 32'hC0400000; // -3.0 
    parameter [31:0] three                 = 32'h40400000; // +3.0 
    parameter [31:0] minus_zero_point_five = 32'hBF000000; // -0.5 
    parameter [31:0] minus_one             = 32'hBF800000; // -1.0 
    parameter [31:0] gnd                   = 32'h00000000; // 0.0 
    parameter [31:0] plus_one              = 32'h3F800000; // +1.0
    parameter [31:0] zero_point_five       = 32'h3F000000; // +0.5

    always @(*) begin
        if (!en) begin
            Vout1 = gnd;
            Vout2 = gnd;
        end else begin
            case (datain)
                2'b00: begin Vout1 = gnd; Vout2 = gnd; end
                2'b01: begin Vout1 = minus_one_point_five; Vout2 = gnd; end
                2'b10: begin Vout1 = zero_point_five; Vout2 = gnd; end
                2'b11: begin Vout1 = one_point_five; Vout2 = gnd; end
            endcase
        end
    end
endmodule






module mock_analog_switch (
    input en,
    input [31:0] Vin1,
    input [31:0] Vin2,
    input control_signal,
    output reg [31:0] Vout
);
    always @(*) begin
        if (!en)
            Vout = 32'bz; // High impedance
        else
            Vout = control_signal ? Vin2 : Vin1;
    end
endmodule



module decoder_74hc238 (
    input       G0_n,      // Active-low enable
    input       G1_n,      // Active-low enable
    input       G2,        // Active-high enable
    input [2:0] A,         // Address inputs A2, A1, A0
    output reg [7:0] Y     // Active-high outputs Y0-Y7
);

always @(*) begin
    if (!G0_n && !G1_n && G2) begin
        Y = 8'b0000_0000;   // All low by default
        Y[A] = 1'b1;        // One selected output is high
    end else begin
        Y = 8'b0000_0000;   // Disabled state: all outputs low
    end
end

endmodule



////////////////////////////////////////////////////////////////////////////////////////////////
/*                                      ///////////////////////////////////////////////////////
 * Testbench for tb_Top_Crossbar_ADC    ////////////////////////////////////////////////////////
 */                                     /////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module tb_Top_select_cells ();

    // Clock
    reg clk;

    // Outputs from Top
    wire done;
    wire wme, bme;
    wire we1_n, we2_n;
    wire be1_n, be2_n;
    wire wl_rdwr, bl_rdwr;
    wire [7:0] wse, bse;
    wire [1:0] datain_1, datain_2;
    wire [2:0] row_add, column_add;

    // Instantiate Top module
    Top DUT (
        .clk(clk),
        .done(done),
        .wme(wme),
        .bme(bme),
        .we1_n(we1_n),
        .we2_n(we2_n),
        .be1_n(be1_n),
        .be2_n(be2_n),
        .wl_rdwr(wl_rdwr),
        .bl_rdwr(bl_rdwr),
        .wse(wse),
        .bse(bse),
        .datain_1(datain_1),
        .datain_2(datain_2),
        .row_add(row_add),
        .column_add(column_add)
    );


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////siganls////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

wire [31:0] word_line[7:0]; // wordline is an 8-element array, each element is 32 bits
wire [31:0] bit_line[7:0]; // bitline is an 8-element array, each element is 32 bits
wire [31:0] Vuslw, Vslw, Vuslb, Vslb;
wire [7:0] w_decoder, b_decoder;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////// Instantiate decoder ////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    decoder_74hc238 row_decoder(
         .G0_n(we1_n),     
         .G1_n(we2_n),     
         .G2(wl_rdwr),      
         .A(row_add),         
         .Y(w_decoder)  
          );

    decoder_74hc238 column_decoder(
         .G0_n(be1_n),    
         .G1_n(be2_n),   
         .G2(bl_rdwr),      
         .A(column_add),       
         .Y(b_decoder)  
          );


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////// Instantiate analog mux//////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    mock_analog_mux1 mux_row (
        .en(wme),
        .datain(datain_1),
        .Vout1(Vuslw),
        .Vout2(Vslw)
    );

    mock_analog_mux2 mux_column (
        .en(bme),
        .datain(datain_2),
        .Vout1(Vuslb),
        .Vout2(Vslb)
    );


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////// Simulate switch controlling /////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   mock_analog_switch switch_word_0 (
    .en(wse[0]),
    .Vin1(Vuslw),
    .Vin2(Vslw),
    .control_signal(w_decoder[0]),
    .Vout(word_line[0])
);

mock_analog_switch switch_word_1 (
    .en(wse[1]),
    .Vin1(Vuslw),
    .Vin2(Vslw),
    .control_signal(w_decoder[1]),
    .Vout(word_line[1])
);

mock_analog_switch switch_word_2 (
    .en(wse[2]),
    .Vin1(Vuslw),
    .Vin2(Vslw),
    .control_signal(w_decoder[2]),
    .Vout(word_line[2])
);

mock_analog_switch switch_word_3 (
    .en(wse[3]),
    .Vin1(Vuslw),
    .Vin2(Vslw),
    .control_signal(w_decoder[3]),
    .Vout(word_line[3])
);

mock_analog_switch switch_word_4 (
    .en(wse[4]),
    .Vin1(Vuslw),
    .Vin2(Vslw),
    .control_signal(w_decoder[4]),
    .Vout(word_line[4])
);

mock_analog_switch switch_word_5 (
    .en(wse[5]),
    .Vin1(Vuslw),
    .Vin2(Vslw),
    .control_signal(w_decoder[5]),
    .Vout(word_line[5])
);

mock_analog_switch switch_word_6 (
    .en(wse[6]),
    .Vin1(Vuslw),
    .Vin2(Vslw),
    .control_signal(w_decoder[6]),
    .Vout(word_line[6])
);

mock_analog_switch switch_word_7 (
    .en(wse[7]),
    .Vin1(Vuslw),
    .Vin2(Vslw),
    .control_signal(w_decoder[7]),
    .Vout(word_line[7])
);

mock_analog_switch switch_bit_0 (
    .en(bse[0]),
    .Vin1(Vuslb),
    .Vin2(Vslb),
    .control_signal(b_decoder[0]),
    .Vout(bit_line[0])
);

mock_analog_switch switch_bit_1 (
    .en(bse[1]),
    .Vin1(Vuslb),
    .Vin2(Vslb),
    .control_signal(b_decoder[1]),
    .Vout(bit_line[1])
);

mock_analog_switch switch_bit_2 (
    .en(bse[2]),
    .Vin1(Vuslb),
    .Vin2(Vslb),
    .control_signal(b_decoder[2]),
    .Vout(bit_line[2])
);

mock_analog_switch switch_bit_3 (
    .en(bse[3]),
    .Vin1(Vuslb),
    .Vin2(Vslb),
    .control_signal(b_decoder[3]),
    .Vout(bit_line[3])
);

mock_analog_switch switch_bit_4 (
    .en(bse[4]),
    .Vin1(Vuslb),
    .Vin2(Vslb),
    .control_signal(b_decoder[4]),
    .Vout(bit_line[4])
);

mock_analog_switch switch_bit_5 (
    .en(bse[5]),
    .Vin1(Vuslb),
    .Vin2(Vslb),
    .control_signal(b_decoder[5]),
    .Vout(bit_line[5])
);

mock_analog_switch switch_bit_6 (
    .en(bse[6]),
    .Vin1(Vuslb),
    .Vin2(Vslb),
    .control_signal(b_decoder[6]),
    .Vout(bit_line[6])
);

mock_analog_switch switch_bit_7 (
    .en(bse[7]),
    .Vin1(Vuslb),
    .Vin2(Vslb),
    .control_signal(b_decoder[7]),
    .Vout(bit_line[7])
);




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// Clock generation //////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50 MHz clock
    end



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// Simulation Time Limit/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    initial begin
        #3000 $stop;  // Let the Top FSM run and do all operations
    end
endmodule
