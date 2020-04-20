module blocks
(
	input        Clk, Reset, frame_clk,
	input  [9:0] DrawX, DrawY,
	output logic [3:0] colorIndex,
	output logic drawBlock,
	input  [7:0] keycode
);

	parameter [9:0] Block_x = 10'd0; // Center position on the X axis
	parameter [9:0] Block_y = 10'd0; // Center position on the Y axis
	logic [9:0] address = 10'd0;
	logic [9:0] Block_X_Pos, Block_Y_Pos, Block_X_Motion, Block_Y_Motion;
	logic [9:0] Block_X_Pos_in, Block_Y_Pos_in, Block_X_Motion_in, Block_Y_Motion_in;
	logic frame_clk_delayed, frame_clk_rising_edge;

	always_ff @ (posedge Clk)
	begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	always_ff @ (posedge Clk)
	begin
		if (Reset)
		begin
			Block_X_Pos <= Block_x;
			Block_Y_Pos <= Block_y;
			Block_X_Motion <= 10'd0;
			Block_Y_Motion <= 10'd0;
		end
		else
		begin
			Block_X_Pos <= Block_X_Pos_in;
			Block_Y_Pos <= Block_Y_Pos_in;
			Block_X_Motion <= Block_X_Motion_in;
			Block_Y_Motion <= Block_Y_Motion_in;
		end
	end

	spriteRAM blockMemory1 (.read_address(address), .Clk(Clk), .data_Out(colorIndex));

	always_comb
	begin
		Block_X_Pos_in = Block_X_Pos;
		Block_Y_Pos_in = Block_Y_Pos;
		Block_X_Motion_in = Block_X_Motion;
		Block_Y_Motion_in = Block_Y_Motion;

		if (frame_clk_rising_edge)
		begin
			if ( Block_Y_Pos >= 10'd459 )
				Block_Y_Motion_in = 0'b0;
			else if ( Block_Y_Pos <= 10'd0 )
				Block_Y_Motion_in = 1'b0;
			else if (keycode == 8'h1A) // W key: up
			begin
				Block_Y_Motion_in = ~10'd1 + 10'd1; // 2's complement of 1
				Block_X_Motion_in = 10'd0; // 0, no speed in X
			end
			else if (keycode == 8'h16)// S key: down
			begin
				Block_Y_Motion_in = 10'd1; // 1
				Block_X_Motion_in = 10'd0; // 0, no speed in X
			end
			else if ( Block_X_Pos >= 10'd619 )
				Block_X_Motion_in = 1'b0;
			else if ( Block_X_Pos <= 10'd0 ) // Ball is at the left edge, BOUNCE!
				Block_X_Motion_in = 1'b0;
			else if (keycode == 8'h04) // A key: left
			begin
				Block_Y_Motion_in = 10'd0; // 0, no speed in Y
				Block_X_Motion_in =  ~10'd1 + 10'd1; // 2's complement of 1
			end
			else if (keycode == 8'h07) // D key: right
			begin
				Block_Y_Motion_in = 10'd0; // 0, no speed in Y
				Block_X_Motion_in = 10'd1; // 1
			end
			Block_X_Pos_in = Block_X_Pos + Block_X_Motion;
			Block_Y_Pos_in = Block_Y_Pos + Ball_Y_Motion;
		end

		if ((DrawX >= Block_X_Pos) & (DrawX < (Block_X_Pos + 10'd20)) & (DrawY >= Block_Y_Pos) & (DrawY < Block_Y_Pos + 10'd20))
		begin
			address = 20*(DrawY - Block_Y_Pos) + (DrawX - Block_X_Pos);
			drawBlock = 1'b1;
		end
		else
		begin
			drawBlock = 1'b0;
			address = 10'd0;
		end
	end
endmodule
