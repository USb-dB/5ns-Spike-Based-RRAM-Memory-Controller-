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
