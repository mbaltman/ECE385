/* This module is the processor for multiplier, and it does all the wiring and instatiation. */
module Processor
	(
	input  logic clk, reset, run, cleara_loadb, // push buttons
	input  logic [7:0] s, // data switches
	output logic [6:0] AhexU, AhexL, BhexU, BhexL,
	output logic x_reg, // X register value for debugging purposes
	output logic [7:0] a, b, // A, B registers
	output logic add, sub, shift); // operation control signals for debugging purposes



/* Intermediate logic variables go here. */
	logic cleara, loadb; // more detailed control signals
	logic run_s, cleara_loadb_s, between_reg, x_interm, reset_s; // synchronized signals and intermediate signals
	logic [7:0] s_s, sum_as; // synchronized switches and sum of A and switches



/* Instantiation of other modules here. */

	// one 1-bit shift register
	reg_1 reg_x(.clk(clk), .reset(reset_s|cleara), .load(add|sub), .din(x_interm), .dout(x_reg));

	// two 8-bit shift registers
	reg_8 reg_a(.clk(clk), .reset(reset_s|cleara), .shift_in(x_reg), .shift_en(shift), .load(add|sub), .din(sum_as), .shift_out(between_reg), .dout(a));
	reg_8 reg_b(.clk(clk), .reset(reset_s), .shift_in(between_reg), .shift_en(shift), .load(loadb), .din(s_s), .shift_out(), .dout(b));

	// 9-bit adder
	bit_9 my_favorite_adder(.sub(sub), .add(add), .dinA(a), .dinS(s_s), .sum(sum_as), .CO(x_interm));

	// control unit
	control control_unit
	(
	.Clk(clk),
	.Reset(reset_s),
	.Run(run_s),
	.clra_ldb(cleara_loadb_s),
	.bctrl(b[1:0]),
	.OutCleara(cleara),
	.OutLoadb(loadb),
	.OutShift(shift),
	.OutAdd(add),
	.OutSub(sub));

	// hex drivers for LEDs
	HexDriver HexAL (.In0(a[3:0]), .Out0(AhexL));
	HexDriver HexBL (.In0(b[3:0]), .Out0(BhexL));
	HexDriver HexAU (.In0(a[7:4]), .Out0(AhexU));
	HexDriver HexBU (.In0(b[7:4]), .Out0(BhexU));

	// synchronizers
	sync buttons_sync[2:0] (clk, {~run,~reset,~cleara_loadb}, {run_s,reset_s,cleara_loadb_s});
	sync s_sync[7:0] (clk, s, s_s);

endmodule
