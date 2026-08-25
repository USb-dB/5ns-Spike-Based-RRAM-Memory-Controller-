/*
 * Top-level module: connects Select_cell and ADC_CTRL
 */
module Top_Crossbar_ADC (
    input        clk,
    input        rst_n,
    input        clk_en,
    input  [2:0] W,
    input  [2:0] B,
    input  [1:0] Data_input,
    output oDIN,
    output oCS_n,


    output [11:0] ADC_RESULT,
    output        EOC_signal,
    output        SOC_signal,
    // Crossbar control outputs
    output        wme, bme,
    output        we1_n, we2_n,
    output        be1_n, be2_n,
    output        wl_rdwr, bl_rdwr,
    output [7:0]  wse, bse,
    output [1:0]  datain_1, datain_2,
    output [2:0]  row_add, column_add,
    output oSCLK,
    input iDOUT,
    input iCH

);
    wire EOC;
    wire SOC;

    // Instantiate Select_cell
    Select_cell iu_sel (
        .clk        (clk),
        .clk_en     (clk_en),
        .rst_n      (rst_n),
        .W          (W),
        .B          (B),
        .Data_input (Data_input),
        .SOC        (SOC),
        .EOC        (EOC),
        .wme        (wme),
        .bme        (bme),
        .we1_n      (we1_n),
        .we2_n      (we2_n),
        .be1_n      (be1_n),
        .be2_n      (be2_n),
        .wl_rdwr    (wl_rdwr),
        .bl_rdwr    (bl_rdwr),
        .wse        (wse),
        .bse        (bse),
        .datain_1   (datain_1),
        .datain_2   (datain_2),
        .row_add    (row_add),
        .column_add (column_add)
    );

    // Instantiate ADC_CTRL
    ADC_CTRL u_adc (
        .iRST       (~rst_n),      // Active-low reset
        .iCLK       (clk),
        .iCLK_n     (~clk),
        .iGO        (SOC),
        .iCH        (iCH),     // Use row_add as ADC channel
        .oADC_DATA  (ADC_RESULT),
        .oEOC       (EOC_signal),
        .oDIN       (oDIN),            // Tie off or connect to FPGA ADC pins
        .oCS_n      (oCS_n),
        .oSCLK      (oSCLK),
        .iDOUT      (iDOUT)             // Connect to FPGA ADC data pin
    );

    // Connect Select_cell EOC to ADC EOC_signal
    assign EOC_signal = EOC;
    assign SOC_signal = SOC;
endmodule
