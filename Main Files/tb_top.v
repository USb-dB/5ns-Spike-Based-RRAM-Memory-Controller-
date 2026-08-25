
`timescale 1ns / 1ps

// module mock_analog_mux1 (
//     input en,
//     input [1:0] datain,
//     output reg [31:0] Vout1,
//     output reg [31:0] Vout2
// );
//     // Voltage levels
//     parameter [31:0] one_point_five        = 32'h3FC00000; // +1.5 
//     parameter [31:0] minus_one_point_five  = 32'hBFC00000; // -1.5 
//     parameter [31:0] minus_three           = 32'hC0400000; // -3.0 
//     parameter [31:0] three                 = 32'h40400000; // +3.0 
//     parameter [31:0] minus_zero_point_five = 32'hBF000000; // -0.5 
//     parameter [31:0] minus_one             = 32'hBF800000; // -1.0 
//     parameter [31:0] gnd                   = 32'h00000000; // 0.0
//     parameter [31:0] plus_one              = 32'h3F800000; // +1.0 
//     parameter [31:0] zero_point_five       = 32'h3F000000; // +0.5


//     always @(*) begin
//         if (!en) begin
//             Vout1 = gnd;
//             Vout2 = gnd;
//         end else begin
//             case (datain)
//                 2'b00: begin Vout1 = gnd; Vout2 = gnd; end
//                 2'b01: begin Vout1 = minus_one_point_five; Vout2 = minus_three; end
//                 2'b10: begin Vout1 = zero_point_five; Vout2 = plus_one; end
//                 2'b11: begin Vout1 = one_point_five; Vout2 = three; end
//             endcase
//         end
//     end
// endmodule
///////////////////////////////////////////////////////////
//with delay modled mock analog mux1///////////////////////
//////////////////////////////////////////////////////////
module mock_analog_mux1 (
    input en,
    input [1:0] datain,
    output reg [31:0] Vout1,
    output reg [31:0] Vout2
);

    parameter [31:0] one_point_five        = 32'h3FC00000;
    parameter [31:0] minus_one_point_five  = 32'hBFC00000;
    parameter [31:0] minus_three           = 32'hC0400000;
    parameter [31:0] three                 = 32'h40400000;
    parameter [31:0] gnd                   = 32'h00000000;
    parameter [31:0] plus_one              = 32'h3F800000;
    parameter [31:0] zero_point_five       = 32'h3F000000;

    parameter TTRANS = (150 + 182) / 2;
    parameter TOFF   = (113 + 142) / 2;

    always @(*) begin
        if (!en) begin
            Vout1 <= #TOFF gnd;
            Vout2 <= #TOFF gnd;
        end else begin
            case (datain)
                2'b00: begin Vout1 <= #TTRANS zero_point_five; Vout2 <= #TTRANS plus_one; end
                2'b01: begin Vout1 <= #TTRANS minus_one_point_five; Vout2 <= #TTRANS minus_three; end
                2'b10: begin Vout1 <= #TTRANS one_point_five; Vout2 <= #TTRANS three; end
                2'b11: begin Vout1 <= #TTRANS gnd; Vout2 <= #TTRANS gnd; end
            endcase
        end
    end

endmodule



// module mock_analog_mux2 (
//     input en,
//     input [1:0] datain,
//     output reg [31:0] Vout1,
//     output reg [31:0] Vout2
// );
//     // Voltage levels
//     parameter [31:0] one_point_five        = 32'h3FC00000; // +1.5 
//     parameter [31:0] minus_one_point_five  = 32'hBFC00000; // -1.5 
//     parameter [31:0] minus_three           = 32'hC0400000; // -3.0 
//     parameter [31:0] three                 = 32'h40400000; // +3.0 
//     parameter [31:0] minus_zero_point_five = 32'hBF000000; // -0.5 
//     parameter [31:0] minus_one             = 32'hBF800000; // -1.0 
//     parameter [31:0] gnd                   = 32'h00000000; // 0.0 
//     parameter [31:0] plus_one              = 32'h3F800000; // +1.0
//     parameter [31:0] zero_point_five       = 32'h3F000000; // +0.5

//     always @(*) begin
//         if (!en) begin
//             Vout1 = gnd;
//             Vout2 = gnd;
//         end else begin
//             case (datain)
//                 2'b00: begin Vout1 = gnd; Vout2 = gnd; end
//                 2'b01: begin Vout1 = minus_one_point_five; Vout2 = gnd; end
//                 2'b10: begin Vout1 = zero_point_five; Vout2 = gnd; end
//                 2'b11: begin Vout1 = one_point_five; Vout2 = gnd; end
//             endcase
//         end
//     end
// endmodule


////////////////////////////////////////////////////////////////////////////////////////////////
//with delay modled mock analog mux1////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
module mock_analog_mux2 (
    input en,
    input [1:0] datain,
    output reg [31:0] Vout1,
    output reg [31:0] Vout2
);

    parameter [31:0] one_point_five        = 32'h3FC00000;
    parameter [31:0] minus_one_point_five  = 32'hBFC00000;
    parameter [31:0] gnd                   = 32'h00000000;
    parameter [31:0] zero_point_five       = 32'h3F000000;

    parameter TTRANS = (150 + 182) / 2;
    parameter TOFF   = (113 + 142) / 2;

    always @(*) begin
        if (!en) begin
            Vout1 <= #TOFF gnd;
            Vout2 <= #TOFF gnd;
        end else begin
            case (datain)
                2'b11: begin Vout1 <= #TTRANS gnd; Vout2 <= #TTRANS gnd; end
                2'b01: begin Vout1 <= #TTRANS minus_one_point_five; Vout2 <= #TTRANS gnd; end
                2'b00: begin Vout1 <= #TTRANS zero_point_five; Vout2 <= #TTRANS gnd; end
                2'b10: begin Vout1 <= #TTRANS one_point_five; Vout2 <= #TTRANS gnd; end
            endcase
        end
    end

endmodule










// module mock_analog_switch (
//     input en,
//     input [31:0] Vin1,
//     input [31:0] Vinu2,
//     input control_signal,
//     output reg [31:0] Vout
// );
//     always @(*) begin
//         if (!en)
//             Vout = 32'bz; // High impedance
//         else
//             Vout = control_signal ? Vin2 : Vin1;
//     end
// endmodule


module mock_analog_switch (
    input en,
    input [31:0] Vin1,
    input [31:0] Vin2,
    input control_signal,
    output reg [31:0] Vout
);

    parameter TTRANS = (310 + 410) / 2;

    always @(*) begin
        if (!en) begin
            Vout <= #TTRANS 32'bz;
        end else begin
            Vout <= #TTRANS (control_signal ? Vin2 : Vin1);
        end
    end

endmodule





// module decoder_74hc238 (
//     input       G0_n,      // Active-low enable
//     input       G1_n,      // Active-low enable
//     input       G2,        // Active-high enable
//     input [2:0] A,         // Address inputs A2, A1, A0
//     output reg [7:0] Y     // Active-high outputs Y0-Y7
// );

// always @(*) begin
//     if (!G0_n && !G1_n && G2) begin
//         Y = 8'b0000_0000;   // All low by default
//         Y[A] = 1'b1;        // One selected output is high
//     end else begin
//         Y = 8'b0000_0000;   // Disabled state: all outputs low
//     end
// end

// endmodule


module decoder_74hc238 (
    input       G0_n,      // Active-low enable
    input       G1_n,      // Active-low enable
    input       G2,        // Active-high enable
    input [2:0] A,         // Address inputs A2, A1, A0
    output reg [7:0] Y     // Active-high outputs Y0-Y7
);

    // Propagation delay (in nanoseconds)
    parameter TPD = 15;

    always @(*) begin
        #TPD; // Simulated propagation delay

        if (!G0_n && !G1_n && G2) begin
            Y = 8'b0000_0000;
            Y[A] = 1'b1;
        end else begin
            Y = 8'b0000_0000;
        end
    end

endmodule


////////////////////////////////////////////////////////////////////////////////////////////////
/*                                      ///////////////////////////////////////////////////////
 * Testbench for tb_Top_Crossbar_ADC    ////////////////////////////////////////////////////////
 */                                     /////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////////////////////////

module tb_Top_select_cells ();

    reg clk;
        // Enable masks for switches
    reg [7:0] wse = 8'hFF;
    reg [7:0] bse = 8'hFF;
    // Raw signals coming from DUT
    wire wda0, wda1, wda2;
    wire wde1, wde2, wdrw;
    wire bda0, bda1, bda2;
    wire bde1, bde2, bdrw;
    wire wmuxa0, wmuxa1, wmuxae;
    wire bmuxa0, bmuxa1, bmuxe;

       // Aliased signals for readability (grouped)
    wire [2:0] row_add     = {wda2, wda1, wda0};
    wire [2:0] column_add  = {bda2, bda1, bda0};

    wire [1:0] datain_1    = {wmuxa1, wmuxa0};
    wire [1:0] datain_2    = {bmuxa1, bmuxa0};

    wire wme               = wmuxae;
    wire bme               = bmuxe;

    // Write decoder enable signals
    wire we1_n             = wde1;      // active-low
    wire we2_n             = wde2;      // active-low
    wire wl_rdwr           = wdrw;      // active-high direction control

    // Bit decoder enable signals
    wire be1_n             = bde1;      // active-low
    wire be2_n             = bde2;      // active-low
    wire bl_rdwr           = bdrw;      // active-high direction control


    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Instantiate DUT
    Select_cell DUT (
        .clk(clk),
        .wda0(wda0),
        .wda1(wda1),
        .wda2(wda2),
        .wde1(wde1),
        .wde2(wde2),
        .wdrw(wdrw),
        .bda0(bda0),
        .bda1(bda1),
        .bda2(bda2),
        .bde1(bde1),
        .bde2(bde2),
        .bdrw(bdrw),
        .wmuxa0(wmuxa0),
        .wmuxa1(wmuxa1),
        .wmuxae(wmuxae),
        .bmuxa0(bmuxa0),
        .bmuxa1(bmuxa1),
        .bmuxe(bmuxe)
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
        forever #500 clk = ~clk; // 1 MHz clock
        ////i want it to be 1mhz
    end



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// Simulation Time Limit/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    initial begin
        #100000 $stop;  // Let the Top FSM run and do all operations
    end
endmodule
