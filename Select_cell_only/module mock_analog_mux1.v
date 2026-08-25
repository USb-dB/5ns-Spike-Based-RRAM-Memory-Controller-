module mock_analog_mux1 (
    input en,
    input [1:0] datain,
    output reg [31:0] Vout1,
    output reg [31:0] Vout2
);
    // Voltage levels
    parameter [31:0] one_point_five        = 32'h3FC00000; // +1.5 (correct)
    parameter [31:0] minus_one_point_five  = 32'hBFC00000; // -1.5 (correct)
    parameter [31:0] minus_three           = 32'hC0400000; // -3.0 (correct)
    parameter [31:0] three                 = 32'h40400000; // +3.0 (correct)
    parameter [31:0] minus_zero_point_five = 32'hBF000000; // -0.5 (fixed)
    parameter [31:0] minus_one             = 32'hBF800000; // -1.0 (correct)
    parameter [31:0] gnd                   = 32'h00000000; // 0.0 (correct)

    always @(*) begin
        if (!en) begin
            Vout1 = gnd;
            Vout2 = gnd;
        end else begin
            case (datain)
                2'b00: begin Vout1 = gnd; Vout2 = gnd; end
                2'b01: begin Vout1 = minus_one_point_five; Vout2 = minus_three; end
                2'b10: begin Vout1 = minus_zero_point_five; Vout2 = minus_one; end
                2'b11: begin Vout1 = one_point_five; Vout2 = three; end
            endcase
        end
    end
endmodule