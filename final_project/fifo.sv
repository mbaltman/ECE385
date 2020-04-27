module fifoRAM
(
	input  logic [3:0] data_In,
	input  logic [9:0] write_address, read_address,
	input  logic       we, Clk,
	output logic [3:0] data_Out
);

	// mem has width of 4 bits and a total of 2560 addresses, i.e. a single line of pixels
	logic [3:0] mem [0:639];

	initial
	begin
		$readmemh("sprite_bytes/fifoplaceholder.txt", mem);
	end

	always_ff @ (posedge Clk)
	begin
		data_Out <= mem[read_address];
		if (we)
			mem[write_address] <= data_In;
	end
endmodule
