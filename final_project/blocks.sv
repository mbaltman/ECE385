module blocks
(
	input  logic        Clk, Reset, frame_clk,
	input  logic [9:0]  DrawX, DrawY,
	output logic [9:0]  Block_X_Pos, Block_Y_Pos,
	output logic        drawBlock,
	input  logic [7:0]  keycode,
	input logic [15:0] blockstate_new,
	output logic [15:0] blockstate,
	output logic hitbottom
);

/********************************************************************************************************************/

	parameter [9:0]  x_initial = 10'd280;
	parameter [9:0]  y_initial = 10'd0;
	logic     [9:0]  Block_Y_Motion;
	logic     [9:0]  Block_X_Pos_in, Block_Y_Pos_in, Block_Y_Motion_in;
	logic            frame_clk_delayed, frame_clk_rising_edge;
	logic            flag, flag_in, rot_flag, rot_flag_in;
	logic     [15:0] blockstate_in, cwstate, ccwstate;
	logic     [9:0]  bottom, left, right, ccwbottom, ccwleft, ccwright, cwbottom, cwleft, cwright;

	rotation myrotationinstance (.oldstate(blockstate), .ccwstate, .cwstate);

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
			rot_flag <= 1'b0;
			blockstate <= blockstate_new;
		
		end
		else
		begin
			Block_X_Pos <= Block_X_Pos_in;
			Block_Y_Pos <= Block_Y_Pos_in;
			Block_Y_Motion <= Block_Y_Motion_in;
			flag <= flag_in;
			rot_flag <= rot_flag_in;
			blockstate <= blockstate_in;
		end
	end

/********************************************************************************************************************/

	always_comb
	begin
		hitbottom = 1'b0;
		
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

		if (ccwstate[12] | ccwstate[13] | ccwstate[14] | ccwstate[15])
			ccwbottom = Block_Y_Pos + 10'd60;
		else if (ccwstate[8] | ccwstate[9] | ccwstate[10] | ccwstate[11])
			ccwbottom = Block_Y_Pos + 10'd40;
		else if (ccwstate[4] | ccwstate[5] | ccwstate[6] | ccwstate[7])
			ccwbottom = Block_Y_Pos + 10'd20;
		else
			ccwbottom = Block_Y_Pos;
		if (ccwstate[0] | ccwstate[4] | ccwstate[8] | ccwstate[12])
			ccwleft = Block_X_Pos;
		else if (ccwstate[1] | ccwstate[5] | ccwstate[9] | ccwstate[13])
			ccwleft = Block_X_Pos + 10'd20;
		else if (ccwstate[2] | ccwstate[6] | ccwstate[10] | ccwstate[14])
			ccwleft = Block_X_Pos + 10'd40;
		else
			ccwleft = Block_X_Pos + 10'd60;
		if (ccwstate[3] | ccwstate[7] | ccwstate[11] | ccwstate[15])
			ccwright = Block_X_Pos + 10'd60;
		else if (ccwstate[2] | ccwstate[6] | ccwstate[10] | ccwstate[14])
			ccwright = Block_X_Pos + 10'd40;
		else if (ccwstate[1] | ccwstate[5] | ccwstate[9] | ccwstate[13])
			ccwright = Block_X_Pos + 10'd20;
		else
			ccwright = Block_X_Pos;

		if (cwstate[12] | cwstate[13] | cwstate[14] | cwstate[15])
			cwbottom = Block_Y_Pos + 10'd60;
		else if (cwstate[8] | cwstate[9] | cwstate[10] | cwstate[11])
			cwbottom = Block_Y_Pos + 10'd40;
		else if (cwstate[4] | cwstate[5] | cwstate[6] | cwstate[7])
			cwbottom = Block_Y_Pos + 10'd20;
		else
			cwbottom = Block_Y_Pos;
		if (cwstate[0] | cwstate[4] | cwstate[8] | cwstate[12])
			cwleft = Block_X_Pos;
		else if (cwstate[1] | cwstate[5] | cwstate[9] | cwstate[13])
			cwleft = Block_X_Pos + 10'd20;
		else if (cwstate[2] | cwstate[6] | cwstate[10] | cwstate[14])
			cwleft = Block_X_Pos + 10'd40;
		else
			cwleft = Block_X_Pos + 10'd60;
		if (cwstate[3] | cwstate[7] | cwstate[11] | cwstate[15])
			cwright = Block_X_Pos + 10'd60;
		else if (cwstate[2] | cwstate[6] | cwstate[10] | cwstate[14])
			cwright = Block_X_Pos + 10'd40;
		else if (cwstate[1] | cwstate[5] | cwstate[9] | cwstate[13])
			cwright = Block_X_Pos + 10'd20;
		else
			cwright = Block_X_Pos;

		Block_X_Pos_in = Block_X_Pos;
		Block_Y_Pos_in = Block_Y_Pos;
		Block_Y_Motion_in = Block_Y_Motion;
		flag_in = flag;
		rot_flag_in = rot_flag;
		blockstate_in = blockstate;
		hitbottom = 1'b0;

		if (frame_clk_rising_edge)
		begin
			if ( bottom >= 10'd459 ) // check if still moving down
			begin
				hitbottom = 1'b1;
				Block_Y_Motion_in = 1'b0;
				flag_in = 1'b1;
				rot_flag_in = 1'b1;
			end
			// A key: move block left by 20 pixels
			else if (keycode == 8'h04 & left > 10'd0 & flag == 1'b0)
			begin
				Block_X_Pos_in = Block_X_Pos - 10'd20;
				flag_in = 1'b1;
				rot_flag_in = 1'b1;
			end
			// D key: move block right by 20 pixels
			else if (keycode == 8'h07 & right < 10'd180 & flag == 1'b0)
			begin
				Block_X_Pos_in = Block_X_Pos + 10'd20;
				flag_in = 1'b1;
				rot_flag_in = 1'b1;
			end
			// Q key: rotate ccw
			else if (keycode == 8'd20 & ccwbottom < 10'd459 & ccwleft >= 10'd0 & ccwright <= 10'd180 & rot_flag == 1'b0)
			begin
				blockstate_in = ccwstate;
				flag_in = 1'b1;
				rot_flag_in = 1'b1;
			end
			// E key: rotate cw
			else if (keycode == 8'd08 & cwbottom < 10'd459 & cwleft >= 10'd0 & cwright <= 10'd180 & rot_flag == 1'b0)
			begin
				blockstate_in = cwstate;
				flag_in = 1'b1;
				rot_flag_in = 1'b1;
			end
			else if (keycode != 8'h04 & keycode != 8'h07 & keycode != 8'd20 & keycode != 8'd8) // key released
			begin
				flag_in = 1'b0;
				rot_flag_in = 1'b0;
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
