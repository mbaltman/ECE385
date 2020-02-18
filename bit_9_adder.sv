module bit_9
	(
	input  logic sub, add,
	input  logic [7:0] dinA, dinS,
	output logic[7:0] sum, // 8-bit sum
	output logic CO); // CO does not stand for carry-out here but rather just the 9th bit

	// intermediate variables
	logic [8:0] resultAdd, resultSub;
	logic [7:0] dinS_inv;
	logic [8:0] dinS_neg;

	assign dinS_inv= ~dinS; // invert
	ripple_adder negativeadder(.A({dinS_inv[7],dinS_inv}), .B({9'b000000001}), .Sum(dinS_neg)); // add 1 to get 2's complement
	ripple_adder adder(.A({dinA[7],dinA}), .B({dinS[7],dinS}), .Sum(resultAdd)); // add sign-extended B with sign-extended A
	ripple_adder subtractor(.A({dinA[7],dinA}), .B(dinS_neg), .Sum(resultSub)); // add sign-extended B with sign-extended A's 2's complement

	always_comb
	begin
		case(add)
			1'b1: // add
			begin
				sum = resultAdd[7:0];
				CO = resultAdd[8];
			end

			1'b0: // subtract
			begin
				sum = resultSub[7:0];
				CO = resultSub[8];
			end
		endcase
	end

endmodule

module full_adder // FA from lecture notes
	(
	input  x, y, z,
	output s, c);

	assign s = x^y^z;
	assign c = (x&y)|(y&z)|(x&z);
endmodule

module ripple_adder // ripple adder from Lab 4
	(
	input  logic[8:0] A,
	input  logic[8:0] B,
	output logic[8:0] Sum);

	logic c1, c2, c3, c4, c5, c6, c7, c8;

	full_adder FA0(.x(A[0]), .y(B[0]), .z(1'b0), .s(Sum[0]), .c(c1));
	full_adder FA1(.x(A[1]), .y(B[1]), .z(c1), .s(Sum[1]), .c(c2));
	full_adder FA2(.x(A[2]), .y(B[2]), .z(c2), .s(Sum[2]), .c(c3));
	full_adder FA3(.x(A[3]), .y(B[3]), .z(c3), .s(Sum[3]), .c(c4));
	full_adder FA4(.x(A[4]), .y(B[4]), .z(c4), .s(Sum[4]), .c(c5));
	full_adder FA5(.x(A[5]), .y(B[5]), .z(c5), .s(Sum[5]), .c(c6));
	full_adder FA6(.x(A[6]), .y(B[6]), .z(c6), .s(Sum[6]), .c(c7));
	full_adder FA7(.x(A[7]), .y(B[7]), .z(c7), .s(Sum[7]), .c(c8));
	full_adder FA8(.x(A[8]), .y(B[8]), .z(c8), .s(Sum[8]), .c());

endmodule
