module testbench();

	timeunit 10ns; // half clock cycle at 50 MHz, i.e. this is the amount of time represented by #1
	timeprecision 1ns;

	// these signals are internal because the processor will be instantiated as a submodule in testbench.
	logic clk = 0;
	logic reset = 0;
	logic run = 0;
	logic cleara_loadb = 0;

	logic [7:0] s = 8'b00000000; // set switches to 0s initially
	logic [7:0] a, b;
	logic [6:0] AhexL, AhexU, BhexL, BhexU;
	logic x_reg = 0;
	logic add, sub, shift;

	// instantiating the Processor
	Processor letsmultiply(.*);

	// Toggle the clock
	always begin: CLOCK_GENERATION
		#1 clk = ~clk;
	end

	initial begin: CLOCK_INITIALIZATION
		clk = 0;
	end


	// testing begins here
	initial begin: TEST_VECTORS
		reset = 0;
		run = 1;
		cleara_loadb = 1;
		//
		#2 reset = 0;
		#2 reset = 1;

		// load b with proper values
		s = 8'b11111001  ;//   00000111
		#4 cleara_loadb = 0;
		#4 cleara_loadb = 1;

		// load s with proper values and run the multiplier
		s = 8'b11000101;//   00111011
		#2 run = 0;
		#2 run = 1;


	end

endmodule
