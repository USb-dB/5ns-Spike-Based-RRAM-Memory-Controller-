

/*
 * Select_cell module: drives RRAM crossbar read signals and interfaces with ADC
 */
module Select_cell (
    input        clk,
    input        clk_en,
    input        rst_n,
    input  [2:0] W, B,
    input  [1:0] Data_input,

    

    output reg   wme, bme,
    output reg   we1_n, we2_n,
    output reg   be1_n, be2_n,
    output reg   wl_rdwr, bl_rdwr,
    output reg [7:0] wse, bse,
    output reg [1:0] datain_1, datain_2,
    output reg [2:0] row_add, column_add
);

// State encoding
reg [2:0] state;
parameter S0 = 3'd0,
          S1 = 3'd1,
          S2 = 3'd2,
          S3 = 3'd3,
          S4 = 3'd4,
          S5 = 3'd5;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state      <= S0;
        wme        <= 0;
        bme        <= 0;
        we1_n      <= 1;
        we2_n      <= 1;
        be1_n      <= 1;
        be2_n      <= 1;
        wl_rdwr    <= 0;
        bl_rdwr    <= 0;
        wse        <= 8'b0;
        bse        <= 8'b0;
        datain_1   <= 2'b00;
        datain_2   <= 2'b00;
        row_add    <= 3'b000;
        column_add <= 3'b000;
        
    end else if (clk_en) begin
        case (state)
            S0: begin
                // Pre-charge/write enable signals
                wme    <= 1;
                bme    <= 1;
                state  <= S1;
            end
            S1: begin
                // Drive data inputs onto WL and BL drivers
                datain_1 <= Data_input;
                datain_2 <= Data_input;
                state    <= S2;
            end
            S2: begin
                // Enable write drivers
                we1_n   <= 0;
                we2_n   <= 0;
                be1_n   <= 0;
                be2_n   <= 0;
                wl_rdwr <= 1;
                bl_rdwr <= 1;
                state   <= S3;
            end
            S3: begin
                // Select row and column addresses for read
                row_add    <= W;
                column_add <= B;
                state      <= S4;
            end
            S4: begin
                // Enable sense amplifiers and start ADC conversion
                wse <= 8'b11111111;
                bse <= 8'b11111111;
                state <= S0;
            end
            
        endcase
    end
end

endmodule
