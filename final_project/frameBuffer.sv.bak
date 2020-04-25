module frameBuffer
(
	input  Clk,
	input  SRAM_OE_N, // signals if reading or writing
	input  [3:0] colorIndex_save , // data being written in
	input  [9:0] SaveX, SaveY, // determines address being written into

	input  [9:0] ReadX, ReadY, // determines the address that the VGA wants to read out
	output [3:0] data_out , // data being read out

	output [19:0] SRAM_ADDR,
	inout  [15:0] SRAM_DQ,

	input  flip_page
);

	parameter offset = 20'd307200; // number of addresses for first fram buffer, can be used for page flipping

	logic [15:0] Data_write_buffer, Data_read_buffer;

	always_ff @ (posedge Clk)
	begin
	Data_read_buffer <= SRAM_DQ;
	Data_write_buffer <= {12'b0, colorIndex_save[3:0]};
	end

	always_comb
	begin
		if (SRAM_OE_N) // if it's a 1 write memory frame buffer
		begin
			if (flip_page)
			begin
				SRAM_ADDR = ({10'b0, SaveY} * 640) + {10'b0, SaveX} + offset;
			end
			else
			begin
				SRAM_ADDR = ({10'b0, SaveY} * 640) + {10'b0, SaveX}; // address that should be written into, extended to 20 bits, to gauruntee it wouldn't be truncated.
			end
		end
		else // if it's a 0 read memory from frame buffer and write into fifos
		begin
			if (!flip_page)
			begin
				SRAM_ADDR = ({10'b0, ReadY} * 640) + {10'b0, ReadX} + offset;
			end
			else
			begin
				SRAM_ADDR = ({10'b0, ReadY} * 640) + {10'b0, ReadX}; // address that should be written into, extended to 20 bits, to gauruntee it wouldn't be truncated.
			end
		end
	end

	assign Data = SRAM_OE_N ? Data_write_buffer : {16{1'bZ}};
	assign data_out = Data_read_buffer[3:0];
endmodule
