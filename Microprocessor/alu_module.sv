//ALU
module alu_module(
	input  logic [15:0] A, B,
	input  logic [1:0]  s,
	output logic [15:0] out);

	always_comb
	begin
		unique case(s)
			2'b00:
				out = A + B; // ADD
			2'b01:
				out = A & B; // AND
			2'b10:
				out = ~A; // NOT
			2'b11:
				out = A; // pass through
		endcase
	end
endmodule
