// synchronizer with no reset (for switches/buttons)
module sync
	(
	input  logic clk, d,
	output logic q);

	always_ff @ (posedge clk)
	begin
		q <= d;
	end

endmodule
