module spriteRAM
(
	input  [9:0] read_address,
	input  Clk,
	output logic [7:0] data_Out
);

	// mem has width of 4 bits and a total of 17600 addresses
	logic [3:0] mem [0:17599];

	initial
	begin
		$readmemh("sprite_bytes/MemoryContentsTetris.txt", mem);
	end

	always_ff @ (posedge Clk)
	begin
		data_Out <= mem[read_address];
	end
endmodule
