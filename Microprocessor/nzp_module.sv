module nzp_module(
	input  logic [15:0] data,
	input  logic LD_CC, LD_BEN, clk, reset,
	input  logic [2:0] currNZP,
	output logic BEN);

	logic [2:0] NZP;

	always_ff @ (posedge clk)
		begin
		if (reset) // reset and set to 0
			begin
				NZP <= 3'b000;
				BEN <= 1'b0;
			end
		else if (LD_CC) // set NZP register, based on datapath content
			begin
				if (data[15])
					NZP <= 3'b100;
				else if (data == 16'h0000)
					NZP <= 3'b010;
				else
					NZP <= 3'b001;
			end

		if (LD_BEN) // check if NZP == nzp values in IR
			begin
				if ((currNZP[2] == 1) && (NZP[2] == 1))
					BEN <= 1'b1;
				else if ((currNZP[1] == 1) && (NZP[1] == 1))
					BEN <= 1'b1;
				else if ((currNZP[0] == 1) && (NZP[0] == 1))
					BEN <= 1'b1;
				else
					BEN <= 1'b0;
			end
		end
endmodule
