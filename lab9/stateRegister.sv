module stateRegister (
	input  logic clk, reset,
	input  logic [127:0] encoded_msg, mux_output,
	input  integer state_number,
	input  logic mux_enable,
	output logic [127:0] state_output
	);

	always_ff @ (posedge clk)
	begin
		if (reset | (state_number == 0))
			state_output <= 128'b0; // reset state to all 0's
		else if (mux_enable)
			state_output <= mux_output; // write state with new state from MUX output
		else if (state_number == 1)
			state_output <= encoded_msg; // write state with encoded message during key expansion
		else
			state_output <= state_output; // keep state, i.e. do nothing
	end
endmodule
