module MDR_module(
	input  logic [15:0] data, mdrin,
	input  logic mioen, ld, clk, reset,
	output logic [15:0] mdrout);

	logic [15:0] mdr_interm;
	mux2 miomux (.d0(data), .d1(mdrin), .s(mioen), .y(mdr_interm));

	always_ff @ (posedge clk)
	begin
		if (reset)
			mdrout <= 16'h0;
		else if (ld)
			mdrout <= mdr_interm;
	end
endmodule
