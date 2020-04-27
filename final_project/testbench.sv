module testbench ();
	timeunit 10ns;
	timeprecision 1ns;

	logic CLK;
	logic [7:0] colorIndex;
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
		#4 colorIndex = 1'h00;
		#4 colorIndex = 1'h02;
		#4 colorIndex = 1'h04;
		#4 colorIndex = 1'h06;
		#4 colorIndex = 1'h08;
	end
endmodule
