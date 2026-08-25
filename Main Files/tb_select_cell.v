`timescale 1ns / 1ps

module tb_Select_cell ();

// Inputs
reg clk;
reg clk_en;
reg rst_n;
reg [2:0] W, B;
reg [1:0] Data_input;

// Outputs
wire wme, bme;
wire we1_n, we2_n;
wire be1_n, be2_n;
wire wl_rdwr, bl_rdwr;
wire [7:0] wse, bse;
wire [1:0] datain_1, datain_2;
wire [2:0] row_add, column_add;

// Instantiate the DUT
Select_cell DUT (
    .clk(clk),
    .clk_en(clk_en),
    .rst_n(rst_n),
    .W(W),
    .B(B),
    .Data_input(Data_input),
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

// Generate 50 MHz clock
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

// Apply multiple test cases
initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_Select_cell);

    // Reset and initialization
    clk_en = 0;
    rst_n = 0;
    W = 3'b000;
    B = 3'b000;
    Data_input = 2'b00;

    #20 rst_n = 1;
    clk_en = 1;

    // Test case 1
    #20 W = 3'b001; B = 3'b010; Data_input = 2'b01;

    // Test case 2
    #150 W = 3'b011; B = 3'b100; Data_input = 2'b10;

    // Test case 3
    #150 W = 3'b101; B = 3'b110; Data_input = 2'b11;

    // Test case 4
    #150 W = 3'b111; B = 3'b000; Data_input = 2'b00;

    // Done
    #200 $stop;
end

endmodule






