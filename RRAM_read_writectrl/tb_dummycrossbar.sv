`timescale 1ns/1ps

module tb_dummy_crossbar;

    // Inputs
    logic [31:0] word_line0, word_line1, word_line2, word_line3;
    logic [31:0] word_line4, word_line5, word_line6, word_line7;
    logic [31:0] bit_line0, bit_line1, bit_line2, bit_line3;
    logic [31:0] bit_line4, bit_line5, bit_line6, bit_line7;

    // Output
    wire [31:0] V_sense;

    // DUT instantiation
    dummy_crossbar dut (
        .word_line0(word_line0), .word_line1(word_line1), .word_line2(word_line2), .word_line3(word_line3),
        .word_line4(word_line4), .word_line5(word_line5), .word_line6(word_line6), .word_line7(word_line7),

        .bit_line0(bit_line0), .bit_line1(bit_line1), .bit_line2(bit_line2), .bit_line3(bit_line3),
        .bit_line4(bit_line4), .bit_line5(bit_line5), .bit_line6(bit_line6), .bit_line7(bit_line7),

        .V_sense(V_sense)
    );

    // Convert float to IEEE 754 bits
    function [31:0] f(input real r);
        return $shortrealtobits(r);
    endfunction

    // Convert IEEE bits back to real
    function real r(input [31:0] b);
        return $bitstoshortreal(b);
    endfunction

  initial begin
    $display("\n=== Test Case 1: WRITE '1' using 3.3V Bias ===");

    // Apply full 3.3V to WL[3], 0V to BL[2], rest = 1.65V
    word_line0 = f(1.65); word_line1 = f(1.65); word_line2 = f(1.65); word_line3 = f(3.3);
    word_line4 = f(1.65); word_line5 = f(1.65); word_line6 = f(1.65); word_line7 = f(1.65);

    bit_line0 = f(1.65); bit_line1 = f(1.65); bit_line2 = f(0.0); bit_line3 = f(1.65);
    bit_line4 = f(1.65); bit_line5 = f(1.65); bit_line6 = f(1.65); bit_line7 = f(1.65);

    #10;
    $display("V_sense (IEEE754): %h", V_sense);

    $display("\n=== Test Case 2: READ after writing '1' using 1.0V Bias ===");

    // Apply full 1.0V to WL[3], 0V to BL[2], rest = 0.5V
    word_line0 = f(0.5); word_line1 = f(0.5); word_line2 = f(0.5); word_line3 = f(1.0);
    word_line4 = f(0.5); word_line5 = f(0.5); word_line6 = f(0.5); word_line7 = f(0.5);

    bit_line0 = f(0.5); bit_line1 = f(0.5); bit_line2 = f(0.0); bit_line3 = f(0.5);
    bit_line4 = f(0.5); bit_line5 = f(0.5); bit_line6 = f(0.5); bit_line7 = f(0.5);

    #10;
    $display("V_sense (IEEE754): %h", V_sense);
    $display("V_sense (real)   : %f", r(V_sense));

    $display("\n=== Test Case 3: WRITE '0' using -3.3V Bias ===");

    // Apply full -3.3V to WL[3], 0V to BL[2], rest = -1.65V
    word_line0 = f(-1.65); word_line1 = f(-1.65); word_line2 = f(-1.65); word_line3 = f(-3.3);
    word_line4 = f(-1.65); word_line5 = f(-1.65); word_line6 = f(-1.65); word_line7 = f(-1.65);

    bit_line0 = f(-1.65); bit_line1 = f(-1.65); bit_line2 = f(0.0); bit_line3 = f(-1.65);
    bit_line4 = f(-1.65); bit_line5 = f(-1.65); bit_line6 = f(-1.65); bit_line7 = f(-1.65);

    #10;
    $display("V_sense (IEEE754): %h", V_sense);

    $display("\n=== Test Case 4: READ after writing '0' using 1.0V Bias ===");

    // Apply full 1.0V to WL[3], 0V to BL[2], rest = 0.5V
    word_line0 = f(0.5); word_line1 = f(0.5); word_line2 = f(0.5); word_line3 = f(1.0);
    word_line4 = f(0.5); word_line5 = f(0.5); word_line6 = f(0.5); word_line7 = f(0.5);

    bit_line0 = f(0.5); bit_line1 = f(0.5); bit_line2 = f(0.0); bit_line3 = f(0.5);
    bit_line4 = f(0.5); bit_line5 = f(0.5); bit_line6 = f(0.5); bit_line7 = f(0.5);

    #10;
    $display("V_sense (IEEE754): %h", V_sense);
    $display("V_sense (real)   : %f", r(V_sense));

    $stop;
end


endmodule
