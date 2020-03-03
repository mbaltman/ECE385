module IR_module(
	input  logic [15:0] data,
	input  logic ld, clk, reset,
	output logic [15:0] iroutput);

	always_ff @ (posedge clk)
	begin
		if (reset)//if reset set to 0
			iroutput <= 16'h0;
		else if (ld)
			iroutput <= data;//put data path into IR
	end
endmodule
