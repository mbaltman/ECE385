module frameBuffer (
input  SRAM_OE_N, // signals if reading or writing
input  colorIndex_save [3:0], // data being written in
input  [9:0] SaveX, SaveY, // determines address being written into

input  [9:0] DrawX, DrawY, // determines the address that the VGA wants to read out
output data_Out [3:0], // data being read out
output fifo_address, // address in the fifo being written into
output fifo_we, // enable writing into the fifo

output [19:0] SRAM_ADDR,
inout  [15:0] SRAM_DQ
);

parameter offset = 20'd307200; // number of addresses for first frame buffer, can be used for page flipping
always_comb
	begin
		if (SRAM_OE_N) // if it's a 1 write memory frame buffer
			begin
				SRAM_ADDR = ({10'b0, SaveY} * 640) + {10'b0, SaveX}; // address that should be written into, extended to 20 bits, to gauruntee it wouldn't be truncated.
				SRAM_DQ = {12'b0, colorIndex_save};
				fifo_we = 1'b0; // fifo can be read from
			end
		else // if it's a 0 read memory from frame buffer and write into fifos
			begin
				SRAM_ADDR = ({10'b0, DrawY} * 640) + {10'b0, DrawX}; // address that should be written into, extended to 20 bits, to gauruntee it wouldn't be truncated.
				data_out = SRAM_DQ[3:0];
				fifoAddress = DrawX;
				fifo_we = 1'b1; // fifo is being written to
			end
	 end
endmodule
