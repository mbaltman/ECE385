module GPU_controller
(
	input  Clk, Reset,
	input  logic [9:0] DrawX, DrawY, // inputs from VGA
	input  logic VGA_BLANK_N, // used to determine if the pages should be flipped
	output logic [9:0] SaveX, SaveY, // outputs to Frame buffer, controlling what pixel is currently being calculated and saved
	ReadX, ReadY, // outputs to frame buffer, controlling what pixel is currently being read from memory into fifo
	output logic SRAM_CE_N, SRAM_UB_N, SRAM_LB_N, SRAM_OE_N, SRAM_WE_N, // everthing except OE should always be high
	output logic PauseVGA, // pauses the VGA controller while the next line is being read from memory into fifo
	output logic flip_page
);

endmodule
