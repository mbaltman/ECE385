module savedblocks (
	input  logic          clk, reset,
	input  logic [9:0]    Block_X_Pos, Block_Y_Pos,
	input  logic [15:0]   inputstream,
	input  logic [5:0]    spriteindex,
	input  logic          saveenable,
	output logic [1439:0] state_output
	);

	integer topleft_x, topleft_y, i;

	always_comb
	begin
		topleft_x = Block_X_Pos / 10'd20; // ranging from 0 to 9
		topleft_y = Block_Y_Pos / 10'd20; // ranging from 0 to 23
	end

	always_ff @ (posedge clk)
	begin
		if (reset)
		begin
			for (i = 0; i < 240; i = i + 1)
			begin
				state_output[i*6 +: 6] <= 6'd37;
			end
		end
		else if (saveenable)
		begin
			state_output[(((topleft_y + 0)*10 + topleft_x + 0)*6) +: 6] <= inputstream[0]  ? spriteindex : 6'd37;
			state_output[(((topleft_y + 0)*10 + topleft_x + 1)*6) +: 6] <= inputstream[1]  ? spriteindex : 6'd37;
			state_output[(((topleft_y + 0)*10 + topleft_x + 2)*6) +: 6] <= inputstream[2]  ? spriteindex : 6'd37;
			state_output[(((topleft_y + 0)*10 + topleft_x + 3)*6) +: 6] <= inputstream[3]  ? spriteindex : 6'd37;
			state_output[(((topleft_y + 1)*10 + topleft_x + 0)*6) +: 6] <= inputstream[4]  ? spriteindex : 6'd37;
			state_output[(((topleft_y + 1)*10 + topleft_x + 1)*6) +: 6] <= inputstream[5]  ? spriteindex : 6'd37;
			state_output[(((topleft_y + 1)*10 + topleft_x + 2)*6) +: 6] <= inputstream[6]  ? spriteindex : 6'd37;
			state_output[(((topleft_y + 1)*10 + topleft_x + 3)*6) +: 6] <= inputstream[7]  ? spriteindex : 6'd37;
			state_output[(((topleft_y + 2)*10 + topleft_x + 0)*6) +: 6] <= inputstream[8]  ? spriteindex : 6'd37;
			state_output[(((topleft_y + 2)*10 + topleft_x + 1)*6) +: 6] <= inputstream[9]  ? spriteindex : 6'd37;
			state_output[(((topleft_y + 2)*10 + topleft_x + 2)*6) +: 6] <= inputstream[10] ? spriteindex : 6'd37;
			state_output[(((topleft_y + 2)*10 + topleft_x + 3)*6) +: 6] <= inputstream[11] ? spriteindex : 6'd37;
			state_output[(((topleft_y + 3)*10 + topleft_x + 0)*6) +: 6] <= inputstream[12] ? spriteindex : 6'd37;
			state_output[(((topleft_y + 3)*10 + topleft_x + 1)*6) +: 6] <= inputstream[13] ? spriteindex : 6'd37;
			state_output[(((topleft_y + 3)*10 + topleft_x + 2)*6) +: 6] <= inputstream[14] ? spriteindex : 6'd37;
			state_output[(((topleft_y + 3)*10 + topleft_x + 3)*6) +: 6] <= inputstream[15] ? spriteindex : 6'd37;
		end
	end
endmodule
