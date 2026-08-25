module RRAM_System_Top (
    // System inputs
    input clk,
    input clk_en,
    input rst_n,
    
    // Control inputs
    input [2:0] W,         // Word line address
    input [2:0] B,         // Bit line address
    input [1:0] Data_input // Data input for write operations
    
    // Note: Add any additional I/O ports needed for your specific application
);

// Controller outputs
wire wme, bme;
wire we1_n, we2_n;
wire be1_n, be2_n;
wire wl_rdwr, bl_rdwr;
wire [7:0] wse, bse;
wire [1:0] datain_1, datain_2;
wire [2:0] row_add, column_add;

// Analog voltage buses
wire [31:0] word_line [0:7]; // 8 word lines (rows)
wire [31:0] bit_line [0:7];  // 8 bit lines (columns)
wire [31:0] Vuslw, Vslw, Vuslb, Vslb;

// Decoder outputs
wire [7:0] w_decoder, b_decoder;

// Instantiate the RRAM Controller
Select_cell RRAM_Controller (
    .clk(clk),
    .clk_en(clk_en),
    .rst_n(rst_n),
    .W(W),
    .B(B),
    .Data_input(Data_input),
    
    // Outputs to crossbar
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

// Instantiate row and column decoders
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

// Instantiate analog muxes for voltage selection
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

// Generate word line switches
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin: word_switches
        mock_analog_switch switch_word (
            .en(wse[i]),
            .Vin1(Vuslw),
            .Vin2(Vslw),
            .control_signal(w_decoder[i]),
            .Vout(word_line[i])
        );
    end
endgenerate

// Generate bit line switches
generate
    for (i = 0; i < 8; i = i + 1) begin: bit_switches
        mock_analog_switch switch_bit (
            .en(bse[i]),
            .Vin1(Vuslb),
            .Vin2(Vslb),
            .control_signal(b_decoder[i]),
            .Vout(bit_line[i])
        );
    end
endgenerate

// Instantiate the 8x8 RRAM Crossbar
RRAM_Crossbar_8x8 Memory_Array (
    .word_line(word_line),
    .bit_line(bit_line)
);



endmodule