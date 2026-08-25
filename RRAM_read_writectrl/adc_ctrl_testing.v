module ADC_CTRL (   
    input         iRST,
    input         iCLK,
    input         iCLK_n,
    input         iGO,
    input  [2:0]  iCH,
    output  [11:0] oADC_data,
    output reg    oEOC,
    output        oDIN,
    output        oCS_n,
    output        oSCLK,
    input         iDOUT
);

reg         data;
reg         go_en;
reg [3:0]   cont;
reg [3:0]   m_cont;
reg [11:0]  adc_data;

assign oCS_n  = ~go_en;
assign oSCLK  = (go_en) ? iCLK : 1;  // SPI clock active only during go
assign oDIN   = data;
assign oADC_data = adc_data;

/// Activate go_en when iGO is asserted
always @(posedge iGO or negedge iRST) begin
    if (!iRST) begin
        go_en     <= 0;
        adc_data  <= 12'd0;
    end
    else if (iGO) begin
        go_en <= 1;
    end
end


/// Counter increments until 15, then stops
always @(posedge iCLK or negedge go_en) begin
    if (!go_en)
        cont <= 0;
    else if (cont < 15)
        cont <= cont + 1;
    else
        cont <= cont;  // Hold
end

/// Copy cont value to m_cont for safe use on iCLK domain
always @(posedge iCLK_n) begin
    m_cont <= cont;
end

/// Serial DIN bitstream: transmit channel select bits
always @(posedge iCLK_n or negedge go_en) begin
    if (!go_en)
        data <= 0;
    else begin
        case (cont)
            4'd2: data <= iCH[2];
            4'd3: data <= iCH[1];
            4'd4: data <= iCH[0];
            default: data <= 0;
        endcase
    end
end

/// Data reception and conversion complete detection
always @(posedge iCLK or negedge go_en) begin
    if (!go_en) begin
        oEOC       <= 0;
    end else begin
        case (m_cont)
            4'd4 : adc_data[11] <= iDOUT;
            4'd5 : adc_data[10] <= iDOUT;
            4'd6 : adc_data[9]  <= iDOUT;
            4'd7 : adc_data[8]  <= iDOUT;
            4'd8 : adc_data[7]  <= iDOUT;
            4'd9 : adc_data[6]  <= iDOUT;
            4'd10: adc_data[5]  <= iDOUT;
            4'd11: adc_data[4]  <= iDOUT;
            4'd12: adc_data[3]  <= iDOUT;
            4'd13: adc_data[2]  <= iDOUT;
            4'd14: adc_data[1]  <= iDOUT;
            4'd15: begin
                adc_data[0]   <= iDOUT;
                
                oEOC          <= 1;
                go_en         <= 0;   // Stop conversion
            end
        endcase
    end
end

endmodule
