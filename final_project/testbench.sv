module testbench (); // issues with locating .sof file
	timeunit 10ns;
	timeprecision 1ns;

	logic CLK;
	logic drawBlock;
	logic [7:0] colorIndex;
	logic [9:0] DrawX, DrawY;
	logic [7:0] VGA_R, VGA_G, VGA_B;

	color_mapper cmLogic(.*);

	always
	begin: CLOCK_GENERATION
		#1 CLK = ~CLK;
	end

	initial begin: CLOCK_INITIALIZATION
		CLK = 0;
	end

	initial begin: TEST_VECTORS
		drawBlock = 1;
		DrawX = 10'b0;
		DrawY = 10'b0;

/*
		#4 colorIndex = 8'h00;

		#4 colorIndex = 8'h05;

		#4 colorIndex = 8'h0e;

		#4 colorIndex = 8'h14;

		#4 colorIndex = 8'h15;
*/
	end
endmodule
