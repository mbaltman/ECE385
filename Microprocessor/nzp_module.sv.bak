module nzp_module(
	input  logic [15:0] data,
	input  logic LD_CC, LD_BEN, clk, reset,
	input  logic [2:0] currNZP,
	output logic BEN);

	logic [2:0] NZP;

	always_ff @ (posedge clk)
		begin
		if (reset)
			begin
				NZP <= 3'b000;
			end
		else if (LD_CC)
			begin
				if(data[15] == 1)
					NZP <= 3'b100;
				else if(data == 16'h0000)
					NZP <= 3'b010;
				else
					NZP <= 3'b001;
			end

		if(LD_BEN)
			begin
				if(currNZP[2] == NZP[2])
					BEN <= 1;
				if(currNZP[1] == NZP[1])
					BEN <= 1;
				if(currNZP[0] == NZP[0])
					BEN <= 1;
				else
					BEN <= 0;
			end
		end
endmodule
