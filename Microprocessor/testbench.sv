module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;


// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
input logic [15:0] S;
input logic Clk, Reset, Run, Continue;
output logic [11:0] LED;
output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
output logic CE, UB, LB, OE, WE;
output logic [19:0] ADDR;
inout wire [15:0] Data;

lab6_toplevel processor(.*)
						
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS

Reset = 1;
Run =1;
Continue =1;

S = 16'h0;

#2 Reset =0;

Reset =1;
	
#2 Run =0;



						
endmodule
