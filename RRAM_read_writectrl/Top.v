module Top (
    input clk,

    output done,
    output wme, bme,
    output we1_n, we2_n,
    output be1_n, be2_n,
    output wl_rdwr, bl_rdwr,
    output [7:0] wse, bse,
    output [1:0] datain_1, datain_2,
    output [2:0] row_add, column_add
);

    // Internal driver signals
    reg clk_en = 0;
    reg rst_n = 0;
    reg [2:0] W = 3'b0, B = 3'b0;
    reg [1:0] Data_input = 2'b0;
    reg restart = 0;
    reg [2:0] counts = 2'b0;

    wire done_w;

    Select_cell uut (
        .clk(clk),
        .clk_en(clk_en),
        .rst_n(rst_n),
        .W(W),
        .B(B),
        .Data_input(Data_input),
        .restart(restart),
        .done(done_w),
        .wme(wme),
        .bme(bme),
        .we1_n(we1_n),
        .we2_n(we2_n),
        .be1_n(be1_n),
        .be2_n(be2_n),
        .wl_rdwr(wl_rdwr),
        .bl_rdwr(bl_rdwr),
        .wse(wse),
        .bse(bse),
        .datain_1(datain_1),
        .datain_2(datain_2),
        .row_add(row_add),
        .column_add(column_add),
        .counts(counts)
    );

    assign done = done_w;

    // FSM to hardcode operations
//    reg [7:0] counter = 0;
    reg [3:0] fsm_state = 0;

    always @(posedge clk) begin
        case (fsm_state)
            0: begin rst_n <= 0; fsm_state <= 1; end
            1: begin
                // if (counter == 1) begin
                    rst_n <= 1;
                    fsm_state <= 2;
                // end else counter <= counter + 1;
            end
            2: begin
                // Test case 1: Write (1,2) = 2'b10
                W <= 3'b001;
                B <= 3'b010;
                Data_input <= 2'b10;
                counts <= 3'd5;
                clk_en <= 1;
                restart <= 1;
                fsm_state <= 3;
            end
            3: begin
                restart <= 0;
                fsm_state <= 4;
            end
            4: if (done_w) fsm_state <= 5;
            5: begin
                clk_en <= 0;
                // Additional sequences can be added here
                fsm_state <= 5; // stay in last state
            end
        endcase
    end

endmodule
