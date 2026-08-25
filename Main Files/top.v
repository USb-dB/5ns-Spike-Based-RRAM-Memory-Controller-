module top (
    input clk,
    output wda0, wda1, wda2,
    output wde1, wde2,
    output wdrw,
    output bda0, bda1, bda2,
    output bde1, bde2,
    output bdrw,
    output wmuxa0, wmuxa1, wmuxae,
    output bmuxa0, bmuxa1, bmuxe
);

    // Clock PLL instantiation
    wire c0_sig;
    clk_ppl clk_ppl_inst (
        .inclk0(clk),
        .c0(c0_sig)
    );

    // Internal wires from DUT
    wire i_wda0, i_wda1, i_wda2;
    wire i_wde1, i_wde2;
    wire i_wdrw;
    wire i_bda0, i_bda1, i_bda2;
    wire i_bde1, i_bde2;
    wire i_bdrw;
    wire i_wmuxa0, i_wmuxa1, i_wmuxae;
    wire i_bmuxa0, i_bmuxa1, i_bmuxe;

    // DUT instantiation
    Select_cell dut (
        .clk(c0_sig),
        .wda0(i_wda0),
        .wda1(i_wda1),
        .wda2(i_wda2),
        .wde1(i_wde1),
        .wde2(i_wde2),
        .wdrw(i_wdrw),
        .bda0(i_bda0),
        .bda1(i_bda1),
        .bda2(i_bda2),
        .bde1(i_bde1),
        .bde2(i_bde2),
        .bdrw(i_bdrw),
        .wmuxa0(i_wmuxa0),
        .wmuxa1(i_wmuxa1),
        .wmuxae(i_wmuxae),
        .bmuxa0(i_bmuxa0),
        .bmuxa1(i_bmuxa1),
        .bmuxe(i_bmuxe)
    );

    // Flip-flops to detoggle outputs
    reg r_wda0, r_wda1, r_wda2;
    reg r_wde1, r_wde2;
    reg r_wdrw;
    reg r_bda0, r_bda1, r_bda2;
    reg r_bde1, r_bde2;
    reg r_bdrw;
    reg r_wmuxa0, r_wmuxa1, r_wmuxae;
    reg r_bmuxa0, r_bmuxa1, r_bmuxe;

    always @(posedge clk) begin
        r_wda0 <= i_wda0;
        r_wda1 <= i_wda1;
        r_wda2 <= i_wda2;
        r_wde1 <= i_wde1;
        r_wde2 <= i_wde2;
        r_wdrw <= i_wdrw;
        r_bda0 <= i_bda0;
        r_bda1 <= i_bda1;
        r_bda2 <= i_bda2;
        r_bde1 <= i_bde1;
        r_bde2 <= i_bde2;
        r_bdrw <= i_bdrw;
        r_wmuxa0 <= i_wmuxa0;
        r_wmuxa1 <= i_wmuxa1;
        r_wmuxae <= i_wmuxae;
        r_bmuxa0 <= i_bmuxa0;
        r_bmuxa1 <= i_bmuxa1;
        r_bmuxe  <= i_bmuxe;
    end

    // Assign to output pins
    assign wda0 = r_wda0;
    assign wda1 = r_wda1;
    assign wda2 = r_wda2;
    assign wde1 = r_wde1;
    assign wde2 = r_wde2;
    assign wdrw = r_wdrw;
    assign bda0 = r_bda0;
    assign bda1 = r_bda1;
    assign bda2 = r_bda2;
    assign bde1 = r_bde1;
    assign bde2 = r_bde2;
    assign bdrw = r_bdrw;
    assign wmuxa0 = r_wmuxa0;
    assign wmuxa1 = r_wmuxa1;
    assign wmuxae = r_wmuxae;
    assign bmuxa0 = r_bmuxa0;
    assign bmuxa1 = r_bmuxa1;
    assign bmuxe  = r_bmuxe;

endmodule
