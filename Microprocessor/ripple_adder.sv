/* full adder module from lecture slides */

module full_adder(
	input x, y, z,
	output s, c);

	assign s = x^y^z;
	assign c = (x&y)|(y&z)|(x&z);
endmodule



/* ripple adder module */

module ripple_adder
(
	input   logic [15:0] A, // the first 16-bit number to be added
	input   logic [15:0] B, // the second 16-bit number to be added
	output  logic [15:0] Sum, // the 16-bit sum to be generated
	output  logic CO // the carryout bit
	);

	logic [14:0] c_inter; // intermediate bits for carryin and carryout between adders

	full_adder FA0(.x(A[0]), .y(B[0]), .z(1'b0), .s(Sum[0]), .c(c_inter[0])); // feed the first bits to the inputs, 0 to carryin, summation to output, and carryout to intermediate variable
	full_adder FA1(.x(A[1]), .y(B[1]), .z(c_inter[0]), .s(Sum[1]), .c(c_inter[1])); // feed the second bits to the inputs, previous intermediate to carryin, summation to output, and carryout to next intermediate
	full_adder FA2(.x(A[2]), .y(B[2]), .z(c_inter[1]), .s(Sum[2]), .c(c_inter[2]));
	full_adder FA3(.x(A[3]), .y(B[3]), .z(c_inter[2]), .s(Sum[3]), .c(c_inter[3]));
	full_adder FA4(.x(A[4]), .y(B[4]), .z(c_inter[3]), .s(Sum[4]), .c(c_inter[4]));
	full_adder FA5(.x(A[5]), .y(B[5]), .z(c_inter[4]), .s(Sum[5]), .c(c_inter[5]));
	full_adder FA6(.x(A[6]), .y(B[6]), .z(c_inter[5]), .s(Sum[6]), .c(c_inter[6]));
	full_adder FA7(.x(A[7]), .y(B[7]), .z(c_inter[6]), .s(Sum[7]), .c(c_inter[7]));
	full_adder FA8(.x(A[8]), .y(B[8]), .z(c_inter[7]), .s(Sum[8]), .c(c_inter[8]));
	full_adder FA9(.x(A[9]), .y(B[9]), .z(c_inter[8]), .s(Sum[9]), .c(c_inter[9]));
	full_adder FA10(.x(A[10]), .y(B[10]), .z(c_inter[9]), .s(Sum[10]), .c(c_inter[10]));
	full_adder FA11(.x(A[11]), .y(B[11]), .z(c_inter[10]), .s(Sum[11]), .c(c_inter[11]));
	full_adder FA12(.x(A[12]), .y(B[12]), .z(c_inter[11]), .s(Sum[12]), .c(c_inter[12]));
	full_adder FA13(.x(A[13]), .y(B[13]), .z(c_inter[12]), .s(Sum[13]), .c(c_inter[13]));
	full_adder FA14(.x(A[14]), .y(B[14]), .z(c_inter[13]), .s(Sum[14]), .c(c_inter[14]));
	full_adder FA15(.x(A[15]), .y(B[15]), .z(c_inter[14]), .s(Sum[15]), .c(CO));  // feed the last bits to the inputs, previous intermediate to carryin, summation to output, and carryout to CO
endmodule
