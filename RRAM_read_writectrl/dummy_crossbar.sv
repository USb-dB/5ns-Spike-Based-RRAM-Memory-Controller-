`timescale 1ns / 1ps

module dummy_crossbar (
    input  [31:0] word_line0,
    input  [31:0] word_line1,
    input  [31:0] word_line2,
    input  [31:0] word_line3,
    input  [31:0] word_line4,
    input  [31:0] word_line5,
    input  [31:0] word_line6,
    input  [31:0] word_line7,

    input  [31:0] bit_line0,
    input  [31:0] bit_line1,
    input  [31:0] bit_line2,
    input  [31:0] bit_line3,
    input  [31:0] bit_line4,
    input  [31:0] bit_line5,
    input  [31:0] bit_line6,
    input  [31:0] bit_line7,

    output logic [31:0] V_sense
);

// Parameters
parameter real R_on    = 1e3;
parameter real R_off   = 1e9;
parameter real V_set   = 3.0;
parameter real V_reset = -3.0;
parameter real Rf      = 1e3;
parameter real V_thresh_margin = 0.1;

// Internal real signals
real w_real[7:0];
real b_real[7:0];

// 8x8 Resistance states: 1 = R_on, 0 = R_off
reg [7:0] crossbar_array[0:7] = '{
    default: 8'b00000000
};
always_comb begin
    // Declare locals inside always_comb to avoid shared static errors
    automatic int i, j;
    automatic int sel_i; 
    automatic int sel_j; 
    automatic real vcell;
    automatic real max_vcell; 

    automatic real R_selected, I_bitline, V_transimpedence;
    sel_i = -1;
    sel_j = -1;
    max_vcell = 0.0;
    // Step 1: Convert inputs to real
    w_real[0] = $bitstoshortreal(word_line0);
    w_real[1] = $bitstoshortreal(word_line1);
    w_real[2] = $bitstoshortreal(word_line2);
    w_real[3] = $bitstoshortreal(word_line3);
    w_real[4] = $bitstoshortreal(word_line4);
    w_real[5] = $bitstoshortreal(word_line5);
    w_real[6] = $bitstoshortreal(word_line6);
    w_real[7] = $bitstoshortreal(word_line7);

    b_real[0] = $bitstoshortreal(bit_line0);
    b_real[1] = $bitstoshortreal(bit_line1);
    b_real[2] = $bitstoshortreal(bit_line2);
    b_real[3] = $bitstoshortreal(bit_line3);
    b_real[4] = $bitstoshortreal(bit_line4);
    b_real[5] = $bitstoshortreal(bit_line5);
    b_real[6] = $bitstoshortreal(bit_line6);
    b_real[7] = $bitstoshortreal(bit_line7);

    // Step 2: Find the cell with max |V_cell|
    for (i = 0; i < 8; i = i + 1) begin
        for (j = 0; j < 8; j = j + 1) begin
            vcell = w_real[i] - b_real[j];
            if ((vcell > 0 ? vcell : -vcell) > (max_vcell > 0 ? max_vcell : -max_vcell)) begin

                max_vcell = vcell;
                sel_i = i;
                sel_j = j;
            end
        end
    end

    // Step 3: Handle the selected cell
    if (sel_i >= 0 && sel_j >= 0) begin
        if (max_vcell > V_set + V_thresh_margin) begin
            crossbar_array[sel_i][sel_j] = 1;
            V_sense = 32'hZZZZZZZZ;
        end
        else if (max_vcell < V_reset - V_thresh_margin) begin
            crossbar_array[sel_i][sel_j] = 0;
            V_sense = 32'hZZZZZZZZ;
        end
        else begin
            R_selected = (crossbar_array[sel_i][sel_j] == 1) ? R_on : R_off;
            I_bitline = max_vcell / R_selected;
            V_transimpedence = I_bitline * Rf;
            V_sense = $shortrealtobits(V_transimpedence);
        end
    end else begin
        V_sense = 32'hZZZZZZZZ; // High impedance if nothing valid
    end
end

endmodule