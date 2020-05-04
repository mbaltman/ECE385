module savedblocks (
	input  logic		  clk, reset,
	input  logic [9:0]	Block_X_Pos,
						  Block_Y_Pos,
	input  logic [15:0]   inputstream,
	input  logic		  saveenable,
	output logic [239:0]  state_output
	);

	logic [239:0] state_update;

	logic [7:0] topright_x, topleft_y, i, j;
	logic [7:0] baseindex;

	always_comb
	begin
		topright_x = (Block_X_Pos - 10'd20) / 10'd20;
		topleft_y = Block_Y_Pos / 10'd20; // ranging from 0 to 23
	end


	always_ff @ (posedge clk)
	begin
		if (reset)
		begin
			for (i = 8'd0; i < 8'd240; i = i + 8'd1)
			begin
				state_output[i] <= 1'b0;
			end
		end
		else if (saveenable)
		begin
			baseindex = topleft_y * 8'd10;

			if (inputstream[0])
				state_output[baseindex + topright_x - 8'd3] <= inputstream[0];

			if (inputstream[1])
				state_output[baseindex + topright_x - 8'd2] <= inputstream[1];

			if (inputstream[2])
				state_output[baseindex + topright_x - 8'd1] <= inputstream[2];

			if (inputstream[3])
				state_output[baseindex + topright_x - 8'd0] <= inputstream[3];

			if (inputstream[4])
				state_output[baseindex + 8'd10 + topright_x - 8'd3] <= inputstream[4];

			if (inputstream[5])
				state_output[baseindex + 8'd10 + topright_x - 8'd2] <= inputstream[5];

			if (inputstream[6])
				state_output[baseindex + 8'd10 + topright_x - 8'd1] <= inputstream[6];

			if (inputstream[7])
				state_output[baseindex + 8'd10 + topright_x - 8'd0] <= inputstream[7];

			if (inputstream[8])
				state_output[baseindex + 8'd20 + topright_x - 8'd3] <= inputstream[8];

			if (inputstream[9])
				state_output[baseindex + 8'd20 + topright_x - 8'd2] <= inputstream[9];

			if (inputstream[10])
				state_output[baseindex + 8'd20 + topright_x - 8'd1] <= inputstream[10];

			if (inputstream[11])
				state_output[baseindex + 8'd20 + topright_x - 8'd0] <= inputstream[11];

			if (inputstream[12])
				state_output[baseindex + 8'd30 + topright_x - 8'd3] <= inputstream[12];

			if (inputstream[13])
				state_output[baseindex + 8'd30 + topright_x - 8'd2] <= inputstream[13];

			if (inputstream[14])
				state_output[baseindex + 8'd30 + topright_x - 8'd1] <= inputstream[14];

			if (inputstream[15])
				state_output[baseindex + 8'd30 + topright_x - 8'd0] <= inputstream[15];
		end
		else
		begin
			for (i = 8'd0; i < 8'd240; i = i + 8'd10)
			begin
				if (state_output[i +: 8'd10] == 10'b1111111111)
				begin
					state_output[i +: 8'd10] = 10'd0;
				end

				if (state_output[i +: 8'd10] == 10'b0 && i > 8'd0)
				begin
					if (state_output[i - 8'd10 +: 8'd10] != 10'b0)
					begin
						state_output[i +: 8'd10] = state_output[(i - 8'd10) +: 8'd10];
						state_output[i - 8'd10 +: 8'd10] = 10'b0;
					end
				end
			end
		end
	end
endmodule
