
/*
 * ADC_CTRL module: interfaces with SPI ADC and outputs digital data + EOC
 */
module ADC_CTRL (
    input         iRST,       // Active-low reset
    input         iCLK,       // System clock
    input         iCLK_n,     // Inverted clock
    input         iGO,        // Start conversion pulse
    input   [2:0] iCH,        // ADC channel select
    output [11:0] oADC_DATA,  // 12-bit converted data
    output        oEOC,       // End of conversion

    output        oDIN,
    output        oCS_n,
    output        oSCLK,
    input         iDOUT
);
    /* Internal signals */
    reg        data;
    reg        go_en;
    reg [3:0]  cont;
    reg [3:0]  m_cont;
    reg [11:0] adc_data;
    reg        eoc_reg;

    
    assign oCS_n      = ~go_en;
    assign oSCLK      = go_en ? iCLK : 1'b1;
    assign oDIN       = data;
    assign oADC_DATA  = adc_data;
    assign oEOC       = eoc_reg;




    // Latch GO signal
    always @(posedge iCLK or negedge iRST) begin
    if (!iRST)
        go_en <= 1'b0;
    else begin
        if (iGO)
            go_en <= 1'b1;
        else if (cont == 4'd15)
            go_en <= 1'b0;
    	end
	end
   

    // Main counter for transaction
    always @(posedge iCLK or negedge go_en) begin
        if (!go_en)
            cont <= 4'd0;
        else
            cont <= cont + 1;
    end

    // Mirror counter on inverted clock
    always @(posedge iCLK_n) begin
        m_cont <= cont;
    end

    // Send channel bits
    always @(posedge iCLK_n or negedge go_en) begin
        if (!go_en)
            data <= 1'b0;
        else begin
            case (cont)
                4'd2: data <= iCH[2];
                4'd3: data <= iCH[1];
                4'd4: data <= iCH[0];
                default: data <= 1'b0;
            endcase
        end
    end

    // Receive data and generate EOC
    always @(posedge iCLK or negedge go_en) begin
        if (!go_en) begin
            adc_data <= 12'd0;
            eoc_reg  <= 1'b0;
        end else begin
            // Capture ADC bits
            case (m_cont)
                4'd4:  adc_data[11] <= iDOUT;
                4'd5:  adc_data[10] <= iDOUT;
                4'd6:  adc_data[9]  <= iDOUT;
                4'd7:  adc_data[8]  <= iDOUT;
                4'd8:  adc_data[7]  <= iDOUT;
                4'd9:  adc_data[6]  <= iDOUT;
                4'd10: adc_data[5]  <= iDOUT;
                4'd11: adc_data[4]  <= iDOUT;
                4'd12: adc_data[3]  <= iDOUT;
                4'd13: adc_data[2]  <= iDOUT;
                4'd14: adc_data[1]  <= iDOUT;
                4'd15: adc_data[0]  <= iDOUT;
                default: ;
            endcase

            // End-of-conversion pulse
            if (cont == 4'd15)
                eoc_reg <= 1'b1;
            else
                eoc_reg <= 1'b0;
        end
    end
endmodule