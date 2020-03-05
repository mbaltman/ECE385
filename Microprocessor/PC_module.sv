module PC_module(
	input  logic [15:0] data, address,
	input  logic clk, reset, ld,
	input  logic [1:0] s,
	output logic [15:0] pcout);

	logic [15:0] pc_interm;
	mux3 pcmux (.d0(pcout + 1'b1), .d1(data), .d2(address), .s(s), .y(pc_interm)); // calculates what should go into PC

	always_ff @ (posedge clk) // resets PC
	begin
		if (reset)
			pcout <= 16'h0;
		else if (ld)
			pcout <= pc_interm;
	end
endmodule

module mux3 #(parameter width = 16) (input logic [width-1:0] d0, d1, d2, input logic [1:0] s, output logic [width-1:0] y); // selects PC input
	always_comb
	begin
		if (s[1])
			y = d2;
		else if (s[0])
			y = d1;
		else
			y = d0;
	end
endmodule
