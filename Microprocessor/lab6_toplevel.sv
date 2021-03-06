module lab6_toplevel(
	input  logic [15:0] S,
	input  logic Clk, Reset, Run, Continue,
	output logic [11:0] LED,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
	output logic CE, UB, LB, OE, WE,
	output logic [19:0] ADDR,
	output logic [15:0] IR, MAR, PC, MDR, SR1OUT,
	output logic GatePC, LD_MAR, LD_PC, MIO_EN, GateMDR, LD_IR,
	output logic [1:0] PCMUX,
	inout  wire  [15:0] Data, DataPath,
	output integer stateNumber,
	output logic [2:0] SR1_SRC,
	output logic [15:0] registers [7:0]);

slc3 my_slc(.*);

// Even though test memory is instantiated here, it will be synthesized into
// a blank module, and will not interfere with the actual SRAM.
// Test memory is to play the role of physical SRAM in simulation.
test_memory my_test_memory(.Reset(~Reset), .I_O(Data), .A(ADDR), .*);
endmodule
