module testbench ();
	timeunit 10ns;
	timeprecision 1ns;

	logic CLK;
	logic [3:0] colorIndex;
	logic [7:0] VGA_R, VGA_G, VGA_B;

	color_mapper cmTestLogic(.*);

	always
	begin: CLOCK_GENERATION
		#1 CLK = ~CLK;
	end

	initial begin: CLOCK_INITIALIZATION
		CLK = 0;
	end

	initial begin: TEST_VECTORS
		#4 colorIndex = 4'h0;
		#4 colorIndex = 4'h2;
		#4 colorIndex = 4'h4;
		#4 colorIndex = 4'h6;
		#4 colorIndex = 4'h8;
	end
endmodule
