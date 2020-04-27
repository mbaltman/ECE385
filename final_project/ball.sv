module ball
(
    input  logic         Clk, Reset, frame_clk, // The clock indicating a new frame (~60Hz)
    input  logic  [9:0]  DrawX, DrawY,
    output logic         is_ball,
    input  logic  [7:0]  keycode
);

    parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd4;        // Ball size

    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;

    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk)
    begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////

    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;

        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            if ( Ball_Y_Pos + Ball_Size >= Ball_Y_Max ) // Ball is at the bottom edge, BOUNCE!
                Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1); // 2's complement of 1
            else if ( Ball_Y_Pos <= Ball_Y_Min + Ball_Size ) // Ball is at the top edge, BOUNCE!
                Ball_Y_Motion_in = Ball_Y_Step; // 1
            else if (keycode == 8'h1A) // W key: up
                begin
                    Ball_Y_Motion_in = ~10'd1 + 10'd1; // 2's complement of 1
                    Ball_X_Motion_in = 10'd0; // 0, no speed in X
                end
            else if (keycode == 8'h16)// S key: down
                begin
                    Ball_Y_Motion_in = 10'd1; // 1
                    Ball_X_Motion_in = 10'd0; // 0, no speed in X
                end

            // ONLY if did not have to bounce, then you check the key codes
            else if ( Ball_X_Pos + Ball_Size >= Ball_X_Max ) // Ball is at the right edge, BOUNCE!
                Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1); // 2's complement.
            else if ( Ball_X_Pos <= Ball_X_Min + Ball_Size ) // Ball is at the left edge, BOUNCE!
                Ball_X_Motion_in = Ball_X_Step;
            else if (keycode == 8'h04) // A key: left
                begin
                    Ball_Y_Motion_in = 10'd0; // 0, no speed in Y
                    Ball_X_Motion_in =  ~10'd1 + 10'd1; // 2's complement of 1
                end
            else if (keycode == 8'h07) // D key: right
                begin
                    Ball_Y_Motion_in = 10'd0; // 0, no speed in Y
                    Ball_X_Motion_in = 10'd1; // 1
                end

            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
        end
    end

    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
    always_comb begin
        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) )
            is_ball = 1'b1;
        else
            is_ball = 1'b0;
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end
endmodule
