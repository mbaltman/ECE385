module blocks
(
	input  logic        Clk, Reset, frame_clk,
	input  logic [9:0]  DrawX, DrawY,
	output logic [9:0]  Block_X_Pos, Block_Y_Pos,
	output logic        drawBlock,
	input  logic [7:0]  keycode,
	output logic [15:0] blockstate,
	output logic [5:0]  spriteindex
);

/********************************************************************************************************************/

	parameter [9:0]  x_initial = 10'd0;
	parameter [9:0]  y_initial = 10'd0;
	logic     [9:0]  Block_Y_Motion;
	logic     [9:0]  Block_X_Pos_in, Block_Y_Pos_in, Block_Y_Motion_in;
	logic            frame_clk_delayed, frame_clk_rising_edge;
	logic            flag, flag_in;
	logic     [15:0] blockstate_in;
	logic     [9:0]  bottom, left, right;

	always_ff @ (posedge Clk)
	begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end

	always_ff @ (posedge Clk)
	begin
		if (Reset)
		begin
			Block_X_Pos <= x_initial;
			Block_Y_Pos <= y_initial;
			Block_Y_Motion <= 10'd1;
			flag <= 1'b0;
			blockstate <= 16'b0000000000100111;
		end
		else
		begin
			Block_X_Pos <= Block_X_Pos_in;
			Block_Y_Pos <= Block_Y_Pos_in;
			Block_Y_Motion <= Block_Y_Motion_in;
			flag <= flag_in;
			blockstate <= blockstate_in;
		end
	end

/********************************************************************************************************************/

	always_comb
	begin
		if (blockstate[12] | blockstate[13] | blockstate[14] | blockstate[15])
			bottom = Block_Y_Pos + 10'd60;
		else if (blockstate[8] | blockstate[9] | blockstate[10] | blockstate[11])
			bottom = Block_Y_Pos + 10'd40;
		else if (blockstate[4] | blockstate[5] | blockstate[6] | blockstate[7])
			bottom = Block_Y_Pos + 10'd20;
		else
			bottom = Block_Y_Pos;

		if (blockstate[0] | blockstate[4] | blockstate[8] | blockstate[12])
			left = Block_X_Pos;
		else if (blockstate[1] | blockstate[5] | blockstate[9] | blockstate[13])
			left = Block_X_Pos + 10'd20;
		else if (blockstate[2] | blockstate[6] | blockstate[10] | blockstate[14])
			left = Block_X_Pos + 10'd40;
		else
			left = Block_X_Pos + 10'd60;

		if (blockstate[3] | blockstate[7] | blockstate[11] | blockstate[15])
			right = Block_X_Pos + 10'd60;
		else if (blockstate[2] | blockstate[6] | blockstate[10] | blockstate[14])
			right = Block_X_Pos + 10'd40;
		else if (blockstate[1] | blockstate[5] | blockstate[9] | blockstate[13])
			right = Block_X_Pos + 10'd20;
		else
			right = Block_X_Pos;

		Block_X_Pos_in = Block_X_Pos;
		Block_Y_Pos_in = Block_Y_Pos;
		Block_Y_Motion_in = Block_Y_Motion;
		flag_in = flag;
		blockstate_in = blockstate;

		if (frame_clk_rising_edge)
		begin
			if ( bottom >= 10'd460 ) // check if still moving down
			begin
				Block_Y_Motion_in = 1'b0;
				flag_in = 1'b1;
			end
			else if (keycode == 8'h04 & left > 10'd0 & flag == 1'b0) // A key: move block left by 20 pixels
			begin
				Block_X_Pos_in = Block_X_Pos - 10'd20;
				flag_in = 1'b1;
			end
			else if (keycode == 8'h07 & right < 10'd620 & flag == 1'b0) // D key: move block right by 20 pixels
			begin
				Block_X_Pos_in = Block_X_Pos + 10'd20;
				flag_in = 1'b1;
			end
			else if (keycode != 8'h04 & keycode != 8'h07) // key released
			begin
				flag_in = 1'b0;
			end

			Block_Y_Pos_in = Block_Y_Pos + Block_Y_Motion;
		end

/********************************************************************************************************************/

		if ((DrawX >= Block_X_Pos) & (DrawX < (Block_X_Pos + 10'd80)) & (DrawY >= Block_Y_Pos) & (DrawY < Block_Y_Pos + 10'd80))
		begin
			drawBlock = 1'b1;
		end
		else
		begin
			drawBlock = 1'b0;
		end
	end
endmodule
