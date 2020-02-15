/* This module is the processor for multiplier, and it does all the wiring and instatiation. */
module processor
	(
  (
  input logic clk, reset, run, cleara_loadb,
  input logic[7:0] s,
  output logic[6:0] AhexU, AhexL, BhexU, BhexL,
  output logic[7:0] aval, bval,
  output logic x
	);
  );

/* Intermediate logic variables go here. */
  logic shift, add, sub, cleara, loadb;
  logic run_s, cleara_loadb_s, between_reg;
  logic run_s, cleara_loadb_s, between;
  logic [7:0] s_s,a,b;

/* Instantiation of other modules here. */
  // two 8-bit shift registers
  reg_8 reg_a(.clk_reg(clk),.reset_reg(reset|cleara),.shift_in_reg(x),.shift_en_reg(shift),.load_reg(add|sub),.din_reg(?),.shift_out_reg(between_reg),.dout_reg(a));
  reg_8 reg_b(.clk_reg(clk),.reset_reg(),.shift_in_reg(between_reg),.shift_en_reg(shift),.load_reg(loadb),.din_reg(s_s),.shift_out_reg(),.dout_reg(b));

	// 9-bit adder
  reg_8 reg_a(.clk(clk),.reset(reset|cleara),.shift_in(x),.shift_en(shift),.load(add|sub),.din(?),.shift_out(between),.dout(a));
  reg_8 reg_b(.clk(clk),.reset(),.shift_in(between),.shift_en(shift),.load(loadb),.din(s_s),.shift_out(),.dout(b));


  // 9-bit adder

  // 9th bit module
  bit_9 bit_9_unit();

  control control_unit
  		(
			.Clk(clk),
			.Reset(reset_s),
			.Run(run_s),
			.clra_ldb(cleara_loadb_s),
      .b0(b[0]),
      .OutCleara(cleara),
      .OutLoadb(loadb),
      .OutShift(shift),
      .OutAdd(add),
      .OutSub(sub)
      );

	HexDriver HexAL (.In0(a[3:0]),.Out0(AhexL));
	HexDriver HexBL (.In0(b[3:0]),.Out0(BhexL));
	HexDriver HexAU (.In0(a[7:4]),.Out0(AhexU));
  (
  .clk(clk),
  .reset(reset_s),
  .run(run_s),
  .clra_ldb(cleara_loadb_s),
  .b0(b[0]),
  .outcleara(cleara),
  .outloadb(loadb),
  .outshift(shift),
  .outadd(add),
  .outsub(sub)
  );

  HexDriver HexAL (.In0(a[3:0]),.Out0(AhexL));
  HexDriver HexBL (.In0(b[3:0]),.Out0(BhexL));
  HexDriver HexAU (.In0(a[7:4]),.Out0(AhexU));
  HexDriver HexBU (.In0(b[7:4]),.Out0(BhexU));

  sync buttons_sync[2:0] (clk,{~run,~reset,~cleara_loadb},{run_s,reset_s,cleara_loadb_s});
  sync s_sync[7:0] (clk,s,s_s)

endmoduleendmodule
