module spriteRAM
(
	input  [2:0] data_In,
	input  [9:0] write_address, read_address,
	input  we, Clk,
	output logic [2:0] data_Out
);

	// mem has width of 3 bits and a total of 400 addresses
	logic [2:0] mem [0:399];

	initial
	begin
		$readmemh("sprite_bytes/tetris_I.txt", mem);
	end

	always_ff @ (posedge Clk)
	begin
		data_Out <= mem[read_address];
		if (we)
			mem[write_address] <= data_In;
	end
endmodule
