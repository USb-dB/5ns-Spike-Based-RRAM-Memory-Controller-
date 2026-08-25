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
