module Select_cell(
    input clk,
    output reg wda0, wda1, wda2,
    output reg wde1, wde2, wdrw,
    output reg bda0, bda1, bda2,
    output reg bde1, bde2, bdrw,
    output reg wmuxa0, wmuxa1, wmuxae,
    output reg bmuxa0, bmuxa1, bmuxe
);

    // Internal control registers
    reg [2:0] wordline, bitline, wlenable, btenable;
    reg [1:0] mux_wordline, mux_bitline;
    reg mux_wlenable, mux_btenable;

    // Counters and finish flags
    reg [9:0] control_counter;
    reg finished;

    // Initialization
    initial begin
        wordline = 3'b001;
        bitline = 3'b001;
         wlenable = 3'b100;
//        // ///110 for readstate is there
         btenable = 3'b100;

//        wlenable = 3'b011;
//        btenable = 3'b011;
        mux_wordline = 2'b11;
        mux_bitline = 2'b11;
        mux_wlenable = 1;
        mux_btenable = 1;

        control_counter = 0;
        finished = 0;
        
    end

    /////////////////////////////
    // 1. POSITIVE EDGE: UPDATE COUNTERS
//    /////////////////////////////
//    always @(posedge clk) begin
//        if (!finished)
//            control_counter <= control_counter + 10'd1;
//    end
/////////////////////////////
// 2. POSITIVE EDGE: TEST1 LOGIC
/////////////////////////////


//always @(posedge clk) begin
//    
//        if (control_counter == 10'd10) begin
//            mux_wlenable <= 1;
//            mux_btenable <= 1;
//        end
//
//        if (control_counter == 10'd15) begin
//            mux_wordline <= 2'b01;
//            mux_bitline <= 2'b10;
//        end
//
//        if (control_counter == 10'd20) begin
//            wordline <= 3'b001;
//            bitline  <= 3'b001;
//        end
//
//        if (control_counter == 10'd25) begin
//            wlenable <= 3'b100;
//            btenable <= 3'b100;
//        end
//
//        if (control_counter == 10'd30) begin
//            wlenable <= ~3'b100;
//            btenable <= ~3'b100;
//        end
//
//        if (control_counter == 10'd40) begin
//            finished <= 1;
//        end
//    
//                // Drive mux controls
//        wmuxa0 <= mux_wordline[0];
//        wmuxa1 <= mux_wordline[1];
//        bmuxa0 <= mux_bitline[0];
//        bmuxa1 <= mux_bitline[1];
//
//        wmuxae <= mux_wlenable;
//        bmuxe  <= mux_btenable;
//
//        // Drive addresses
//        {wda2, wda1, wda0} <= wordline;
//        {bda2, bda1, bda0} <= bitline;
//
//        // Drive enables
//        {wdrw, wde2, wde1} <= wlenable;
//        {bdrw, bde2, bde1} <= btenable;
//end

 /////////////////////////////
    // 3. NEGATIVE EDGE: TEST2 LOGIC
    /////////////////////////////
//     always @(negedge clk) begin
//        
//        
//
//            if (control_counter == 20) begin
//                mux_wordline <= 2'b00;
//                mux_bitline <= 2'b00;
//             end
//
//            
//             if (control_counter == 26) begin
//                mux_wordline <= 2'b11;
//                 mux_bitline <= 2'b11;
//             end
//
//
//
//             if (control_counter == 40)begin
//                
//                 finished <= 1;
//             end
//     end

    /////////////////////////////
    // 4. POSITIVE EDGE: DRIVE OUTPUTS
    /////////////////////////////
//     always @(posedge clk) begin
//         // Drive mux controls
//         wmuxa0 <= mux_wordline[0];
//         wmuxa1 <= mux_wordline[1];
//         bmuxa0 <= mux_bitline[0];
//         bmuxa1 <= mux_bitline[1];
//
//         wmuxae <= mux_wlenable;
//         bmuxe  <= mux_btenable;
//
//         // Drive addresses
//         {wda2, wda1, wda0} <= wordline;
//         {bda2, bda1, bda0} <= bitline;
//
//         // Drive enables
//         {wdrw, wde2, wde1} <= wlenable;
//         {bdrw, bde2, bde1} <= btenable;
//     end


//////////////////////////////////////////////////////////////////////////////////////////////
//test with single clk/////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

    always @(posedge clk) begin
     if (!finished)
         control_counter <= control_counter + 10'd1;

     // Control logic
     if (control_counter == 10'd40) begin
         mux_wordline <= 2'b00;
         mux_bitline  <= 2'b00;
     end
	  
	  // Control logic
     if (control_counter == 10'd60) begin
         mux_wordline <= 2'b11;
         mux_bitline  <= 2'b11;
     end

//     if (control_counter == 10'd102) begin
//         wlenable = 3'b011;
//         btenable = 3'b011;
//     end
	  
//	  if (control_counter == 10'd105) begin
//         mux_wlenable = 0;
//			mux_btenable = 0;
//     end

     if (control_counter == 10'd150)
         finished <= 1;

     // Output logic
     wmuxa0 <= mux_wordline[0];
     wmuxa1 <= mux_wordline[1];
     bmuxa0 <= mux_bitline[0];
     bmuxa1 <= mux_bitline[1];

     {wda2, wda1, wda0} <= wordline;
     {bda2, bda1, bda0} <= bitline;
     {wdrw, wde2, wde1} <= wlenable;
     {bdrw, bde2, bde1} <= btenable;
     wmuxae <= mux_wlenable;
     bmuxe  <= mux_btenable;
 end
/////////////////////////////////////////////////////////////////////////////////
endmodule
