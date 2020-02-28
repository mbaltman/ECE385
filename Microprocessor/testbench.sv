module testbench();

timeunit 10ns;
timeprecision 1ns;
logic GatePC, LD_MAR, LD_PC, MIO_EN, Gate_MDR, LD_IR;
logic [1:0] PCMUX;
logic [15:0] S;
logic Clk, Reset, Run, Continue;
logic [11:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
logic CE, UB, LB, OE, WE;
logic [19:0] ADDR;
logic [15:0] IR,PC,MAR;
wire [15:0] Data;

lab6_toplevel processor(.*);

always
begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end

initial begin: TEST_VECTORS
Reset = 1;
Run = 1;
Continue = 1;

S = 16'h0003;

#2 Reset = 0;
#2 Reset =1;

Reset = 1;

#4 Run = 0;
#8 Run =1;
#2 Continue = 0;
#2 Continue = 1;

#80 S= 16'h000F;
#80 S =16'h00F0;
#80 S =16'h0F00;
#80 S =16'hF000;



end

endmodule
