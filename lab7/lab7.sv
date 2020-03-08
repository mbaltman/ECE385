module lab7(
	input         CLOCK_50,   // clk signal
	input  [3:0]  KEY,        // 2 push buttons
	input  [7:0]  SWITCHES,   // 8 switches
	output [7:0]  LEDG,       // 1st green LED
	output [12:0] DRAM_ADDR,  // sdram_wire.addr
	output [1:0]  DRAM_BA,    // .ba
	output        DRAM_CAS_N, // .cas_n
	output        DRAM_CKE,   // .cke
	output        DRAM_CS_N,  // .cs_n
	inout  [31:0] DRAM_DQ,    // .dq
	output [3:0]  DRAM_DQM,   // .dqm
	output        DRAM_RAS_N, // .ras_n
	output        DRAM_WE_N,  // .we_n
	output        DRAM_CLK    // clk out to SDRAM from other PLL port
	);

	lab7_soc m_lab7_soc(
		.clk_clk(CLOCK_50),              // clk signal
		.reset_reset_n(KEY[0]),          // system reset
		.led_wire_export(LEDG),          // 1st green LED
		.switches_wire_export(SWITCHES), // 8 switches
		.buttons_wire_export(KEY[3:2]),  // 2 push buttons
		.sdram_wire_addr(DRAM_ADDR),     // sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),         // .ba
		.sdram_wire_cas_n(DRAM_CAS_N),   // .cas_n
		.sdram_wire_cke(DRAM_CKE),       // .cke
		.sdram_wire_cs_n(DRAM_CS_N),     // .cs_n
		.sdram_wire_dq(DRAM_DQ),         // .dq
		.sdram_wire_dqm(DRAM_DQM),       // .dqm
		.sdram_wire_ras_n(DRAM_RAS_N),   // .ras_n
		.sdram_wire_we_n(DRAM_WE_N),     // .we_n
		.sdram_clk_clk(DRAM_CLK)         // clk out to SDRAM from other PLL port
		);
endmodule
