module spriteRAM
(
	input  [14:0] read_address,
	input  Clk,
	output logic [3:0] data_Out
);

	// mem has width of 4 bits and a total of 18000 addresses
	logic [3:0] mem [0:17999];

	initial
	begin
		$readmemh("sprite_bytes/MemoryContentsTetris.txt", mem);
	end

	always_ff @ (posedge Clk)
	begin
		data_Out <= mem[read_address];
	end
endmodule
