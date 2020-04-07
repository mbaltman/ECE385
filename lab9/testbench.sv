module testbench ();
	timeunit 10ns;
	timeprecision 1ns;

	logic CLK;
	logic RESET;
	logic AES_START;
	logic AES_DONE;
	logic [127:0] AES_KEY;
	logic [127:0] AES_MSG_ENC;
	logic [127:0] AES_MSG_DEC;

	AES decryptionLogic(.*);

	always
	begin: CLOCK_GENERATION
		#1 CLK = ~CLK;
	end

	initial begin: CLOCK_INITIALIZATION
		CLK = 0;
	end

	initial begin: TEST_VECTORS
		AES_KEY = 128'h3b280014beaac269d613a16bfdc2be03;
	   AES_MSG_ENC = 128'h439d619920ce415661019634f59fcf63;

		#2 RESET = 1;
		#2 RESET = 0;
		#2 AES_START = 0;
		#2 AES_START = 1;
		
		
		
		#130 AES_KEY = 128'h000102030405060708090a0b0c0d0e0f;
		#2 AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;
		
		#2 AES_START = 0;
		#2 AES_START = 1;
		
		
		#130 AES_KEY =128'h3b280014beaac269d613a16bfdc2be03;
		#2 AES_MSG_ENC = 128'h439d619920ce415661019634f59fcf63;
		
		
	end
endmodule
