module MAR_module(
	input  logic [15:0] data,
	input  logic ld, clk, reset,
	output logic [15:0] marout);

	always_ff @ (posedge clk)
	begin
		if (reset)
			marout <= 16'h0;//if reset set to 0
		else if (ld)
			marout <= data;//load with data from data path
	end
endmodule
