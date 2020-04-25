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
	parameter [9:0] spriteOffset = 10'd400;
	logic [14:0] address;
	logic [9:0] Block_X_Pos, Block_Y_Pos, Block_Y_Motion;
	logic [9:0] Block_X_Pos_in, Block_Y_Pos_in, Block_Y_Motion_in;
	logic frame_clk_delayed, frame_clk_rising_edge;
	logic flag, flag_in;

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
			Block_Y_Motion <= 10'd1;
			flag <= 1'b0;
		end
		else
		begin
			Block_X_Pos <= Block_X_Pos_in;
			Block_Y_Pos <= Block_Y_Pos_in;
			Block_Y_Motion <= Block_Y_Motion_in;
			flag <= flag_in;
		end
	end

	spriteRAM blockMemory1 (.read_address(address), .Clk(Clk), .data_Out(colorIndex));

	always_comb
	begin
		Block_X_Pos_in = Block_X_Pos;
		Block_Y_Pos_in = Block_Y_Pos;
		Block_Y_Motion_in = Block_Y_Motion;
		flag_in = flag;
		address = 15'd0;
		drawBlock = 1'b0;

		if (frame_clk_rising_edge)
		begin
			if ( Block_Y_Pos >= 10'd459 ) // check if still moving down
			begin
				Block_Y_Motion_in = 1'b0;
				flag_in = 1'b1;
			end
			else if (keycode == 8'h04 & Block_X_Pos > 10'd0 & flag == 0) // A key: move block left by 20 pixels
			begin
				Block_X_Pos_in = Block_X_Pos - 10'd20;
				flag_in = 1'b1;
			end
			else if (keycode == 8'h07 & Block_X_Pos < 10'd619 & flag == 0) // D key: move block right by 20 pixels
			begin
				Block_X_Pos_in = Block_X_Pos + 10'd20;
				flag_in = 1'b1;
			end
			else if (keycode != 8'h04 & keycode != 8'h07) // key released
			begin
				flag_in = 0;
			end

			Block_Y_Pos_in = Block_Y_Pos + Block_Y_Motion;
		end

		if ((DrawX >= Block_X_Pos) & (DrawX < (Block_X_Pos + 10'd20)) & (DrawY >= Block_Y_Pos) & (DrawY < Block_Y_Pos + 10'd20))
			begin
				address = 20*(DrawY - Block_Y_Pos) + (DrawX - Block_X_Pos) + 38*spriteOffset;
				drawBlock = 1'b1;
				
			end
		else
		begin
			drawBlock = 1'b0;
		end
	end
	
endmodule
