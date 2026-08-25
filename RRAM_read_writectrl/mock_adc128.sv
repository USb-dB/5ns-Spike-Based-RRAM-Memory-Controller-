module mock_adc128 (
    input logic sclk,            // Serial clock
    input logic cs_,             // Active low chip select
    input logic DIN,             // Serial data in
    input real IN[7:0],          // 8 analog input channels (real values: 0.0 to 1.0)
    output logic DOUT            // Serial data out
);

    // Internal registers
    logic [4:0] bit_count = 0;          // Count SCLK edges
    logic [2:0] addr_shift = 0;         // Shifted address from DIN
    logic [15:0] shift_out = 16'd0;     // Shift register for DOUT
    logic [11:0] adc_result = 0;        // 12-bit ADC output
    logic [2:0] current_channel = 0;    // Channel to convert

    // Capture DIN bits (ADDR)
    always_ff @(posedge sclk or posedge cs_) begin
        if (cs_) begin
            bit_count <= 0;
        end else begin
            bit_count <= bit_count + 1;

            // Capture address bits on bits 1–3
            if (bit_count >= 1 && bit_count <= 3) begin
                addr_shift <= {addr_shift[1:0], DIN};
            end

            // After 16 clocks, initiate next conversion and prepare shift register
            if (bit_count == 16) begin
                current_channel <= addr_shift;
                adc_result <= convert_to_adc(IN[addr_shift]);
                shift_out <= {4'b0000, adc_result};  // 4 leading zeros + 12-bit result
            end
        end
    end

    // Shift out data on falling edge
    always_ff @(negedge sclk) begin
        if (!cs_) begin
            DOUT <= shift_out[15];
            shift_out <= {shift_out[14:0], 1'b0};
        end
    end

    // Function to convert real to 12-bit value
    function automatic [11:0] convert_to_adc(input real voltage);
        real clamped;
        begin
            clamped = voltage;
            if (clamped > 1.0) clamped = 1.0;
            if (clamped < 0.0) clamped = 0.0;
            convert_to_adc = int'(clamped * 4095.0);  // Convert to 0–4095 range
        end
    endfunction

endmodule


`timescale 1ns / 1ps

module top_tb;

    // System signals
    logic clk = 0;
    logic rst = 0;
    logic go;
    logic [2:0] ch_sel;
    logic [11:0] adc_data;
    logic eoc;

    // SPI wires
    logic din, cs_n, sclk, dout;

    // Analog inputs (real range 0.0 to 1.0)
    real analog_channels[7:0];

    // Clock generation: 50MHz => 20ns period
    always #10 clk = ~clk;

    // Inverted clock for ADC_CTRL
    wire clk_n = ~clk;

    // Instantiate ADC_CTRL
    ADC_CTRL adc_ctrl_inst (
        .iRST     (rst),
        .iCLK     (clk),
        .iCLK_n   (clk_n),
        .iGO      (go),
        .iCH      (ch_sel),
        .oADC_DATA(adc_data),
        .oEOC     (eoc),
        .oDIN     (din),
        .oCS_n    (cs_n),
        .oSCLK    (sclk),
        .iDOUT    (dout)
    );

    // Instantiate mock_adc128 (SystemVerilog version)
    mock_adc128 adc_model (
        .sclk     (sclk),
        .cs_      (cs_n),
        .DIN      (din),
        .IN       (analog_channels),
        .DOUT     (dout)
    );

    // Stimulus process
    initial begin
        // Initialize analog values (scaled from 0.0 to 1.0)
        analog_channels[0] = 0.25;
        analog_channels[1] = 0.50;
        analog_channels[2] = 0.75;
        analog_channels[3] = 1.00;
        analog_channels[4] = 0.33;
        analog_channels[5] = 0.66;
        analog_channels[6] = 0.10;
        analog_channels[7] = 0.90;

        // Reset sequence
        rst = 0;
        go  = 0;
        ch_sel = 3'd0;
        #100;
        rst = 1;

        // Begin testing all channels
        repeat (8) begin
            @(negedge clk);
            ch_sel = $random % 8;
            go = 1;
            @(negedge clk);
            go = 0;

            // Wait for end of conversion
            wait (eoc == 1);
            $display("Time=%0t, CH=%0d, ADC_RESULT=%0d", $time, ch_sel, adc_data);
            #100;
        end

        $stop;
    end

endmodule


`timescale 1ns / 1ps

module tb_ADC_CTRL;

    // Inputs
    reg iRST;
    reg iCLK;
    reg iCLK_n;
    reg iGO;
    reg [2:0] iCH;
    reg iDOUT;

    // Outputs
    wire [11:0] oADC_data;
    wire oEOC;
    wire oDIN;
    wire oCS_n;
    wire oSCLK;

    // Instantiate the Unit Under Test (UUT)
    ADC_CTRL uut (
        .iRST(iRST),
        .iCLK(iCLK),
        .iCLK_n(iCLK_n),
        .iGO(iGO),
        .iCH(iCH),
        .oADC_data(oADC_data),
        .oEOC(oEOC),
        .oDIN(oDIN),
        .oCS_n(oCS_n),
        .oSCLK(oSCLK),
        .iDOUT(iDOUT)
    );

    // Clock generation: 50MHz -> 20ns period (10ns high, 10ns low)
    initial begin
        iCLK = 1;
        forever #10 iCLK = ~iCLK;
    end

    // Complementary clock for iCLK_n
    always @(iCLK)
        iCLK_n = ~iCLK;

    // Stimulus
    initial begin
        // Initialize
        iRST = 0; iGO = 0; iCH = 3'b010; iDOUT = 0;
        #25;
        iRST = 1;
        #25;

        // Start conversion
        iGO = 1;
        #20;
        iGO = 0;  // pulse

        // Simulate DOUT values for bits 11 to 0
        // These values should appear in adc_data[11:0]
        repeat (16) begin
            @(negedge iCLK_n);  // Set iDOUT at falling edge
            iDOUT = $random % 2;
        end

        #100;

        // Display results
        $display("Final ADC Data: %b", oADC_data);
        $finish;
    end

endmodule
