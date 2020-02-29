module IR_module(
	input  logic [15:0] data,
	input  logic ld, clk, reset,
	output logic [15:0] iroutput);

	always_ff @ (posedge clk)
	begin
		if (reset)
			iroutput <= 16'h0;
		else if (ld)
			iroutput <= data;
	end
endmodule
