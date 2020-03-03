module testbench();

	timeunit 10ns;
	timeprecision 1ns;
	logic GatePC, LD_MAR, LD_PC, MIO_EN, GateMDR, LD_IR;
	logic [1:0] PCMUX;
	logic [15:0] S;
	logic Clk, Reset, Run, Continue;
	logic [11:0] LED;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	logic CE, UB, LB, OE, WE;
	logic [19:0] ADDR;
	logic [15:0] IR, PC, MAR, MDR, SR1OUT;
	wire  [15:0] Data, DataPath;

	logic [2:0] SR1_SRC;
	logic [15:0] registers [7:0];

	integer stateNumber;

	lab6_toplevel processor(.*);

	always
	begin: CLOCK_GENERATION
		#1 Clk = ~Clk;
	end

	initial begin: CLOCK_INITIALIZATION
		Clk = 0;
	end

	initial begin: TEST_VECTORS
		Reset = 1;
		Run = 1;
		Continue = 1;

      #2 Reset = 0;
		#2 Reset = 1;
		
		#2 Run =0;
		#2 Run =1;
		S = 16'h0003;

	  
		#20 Continue = 0;
		#4 Continue = 1;
	
		
   	#4 Continue = 0;
		#4 Continue = 1;
		#4 Continue = 0;
		#4 Continue = 1;
		#4 Continue = 0;
		#4 Continue = 1;
		
		

	end
endmodule
