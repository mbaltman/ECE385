/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

0-3 : 4x 32bit AES Key
4-7 : 4x 32bit AES Encrypted Message
8-11: 4x 32bit AES Decrypted Message
12: Not Used
13: Not Used
14: 32bit Start Register
15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,

	// Avalon Reset Input
	input logic RESET,

	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data

	// Exported Conduit
	output logic [31:0] EXPORT_DATA			// Exported Conduit Signal to LEDs
	);

	logic [31:0] registers [15:0];
	logic [127:0] intDecode;
	logic intDone;

	AES decryptionLogic(	.CLK, .RESET, .AES_START(registers[14][0]), .AES_DONE(intDone),
							.AES_KEY({registers[0], registers[1], registers[2], registers[3]}),
							.AES_MSG_DEC(intDecode),
							.AES_MSG_ENC({registers[4], registers[5], registers[6], registers[7]}));

	always_ff @ (posedge CLK) // write has 1 cycle of delay
	begin
		if (RESET)
		begin
			for (int i = 0; i < 16; i++)
			begin
				registers[i] <= 32'b0; // clear everything to 0
			end
		end
		else if (AVL_WRITE && AVL_CS)
		begin
			registers[AVL_ADDR][31:0] <= AVL_WRITEDATA[31:0]; // write data into corresponding address
		end
		else if(intDone)
		begin
			registers[8] <= intDecode[127:96];
			registers[9] <= intDecode[95:64];
			registers[10] <= intDecode[63:32];
			registers[11] <= intDecode[31:0];
			registers[15][0] <= intDone;
		end
		else
		begin
			for (int i = 0; i < 16; i++)
			begin
				registers[i] <= registers[i]; // do nothing
			end
		end
	end

	always_comb // read has no delay
	begin
		if (AVL_READ && AVL_CS)
		begin
			AVL_READDATA[31:0] = registers[AVL_ADDR][31:0]; // reading data out
		end
		else
		begin
			AVL_READDATA[31:0] = 32'b0; // not reading, high impedence
		end
	end

	assign EXPORT_DATA = {registers[0][31:16], registers[3][15:0]};

endmodule
