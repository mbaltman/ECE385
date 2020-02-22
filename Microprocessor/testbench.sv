module testbench();

input logic [15:0] S;
input logic Clk, Reset, Run, Continue;
output logic [11:0] LED;
output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
output logic CE, UB, LB, OE, WE;
output logic [19:0] ADDR;
inout wire [15:0] Data;

lab6_toplevel processor(.*)
						

endmodule
