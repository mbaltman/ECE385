module reg_1 (
	input  logic clk, reset, load,
	input  logic din,
	output logic dout);

	// reset or load since single variable register has shift the same as parallel output
	always_ff @ (posedge clk)
	begin
		if (reset)
			dout <= 1'h0;
		else if (load)
			dout <= din;
	end

endmodule
