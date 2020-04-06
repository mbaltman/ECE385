/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input  logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
	);
	
	logic [1:0] mux_select;
	logic mux_en;
	logic [127:0] mux_output;
	
	logic[7:0] sb1,sb2,sb3,sb4,sb5,sb6,sb7,sb8.sb9.sb10,sb11,sb12,sb13,sb14,sb15,sb16;

	SubBytes byte1(.clk(CLK),.in(state_output[7:0]),.out(sb1));
	SubBytes byte2(.clk(CLK),.in(state_output[15:8]),.out(sb2));
	SubBytes byte3(.clk(CLK),.in(state_output[23:16]),.out(sb3));
	SubBytes byte4(.clk(CLK),.in(state_output[31:24]),.out(sb4));
	SubBytes byte5(.clk(CLK),.in(state_output[39:32]),.out(sb5));
	SubBytes byte6(.clk(CLK),.in(state_output[47:40]),.out(sb6));
	SubBytes byte7(.clk(CLK),.in(state_output[55:48]),.out(sb7));
	SubBytes byte8(.clk(CLK),.in(state_output[63:56]),.out(sb8));
	SubBytes byte9(.clk(CLK),.in(state_output[71:64]),.out(sb9));
	SubBytes byte10(.clk(CLK),.in(state_output[79:72]),.out(sb10));
	SubBytes byte11(.clk(CLK),.in(state_output[87:80]),.out(sb11));
	SubBytes byte12(.clk(CLK),.in(state_output[95:88]),.out(sb12));
	SubBytes byte13(.clk(CLK),.in(state_output[103:96]),.out(sb13));
	SubBytes byte14(.clk(CLK),.in(state_output[111:104]),.out(sb14));
	SubBytes byte15(.clk(CLK),.in(state_output[119:112]),.out(sb15));
	SubBytes byte16(.clk(CLK),.in(state_output[127:120]),.out(sb16));
	
	
	
	
	ISDU statemachine(.Clk(CLK), .Reset(RESET), .AES_START, .AES_DONE, .mux_en, .mux_select, .stateNumber(state_number), .Round());
	
	mux4 mux4Instance (.iark(), .isb({sb1,sb2,sb3,sb4,sb5,sb6,sb7,sb8.sb9.sb10,sb11,sb12,sb13,sb14,sb15,sb16}),
										 .imc(), .isr(), .s(mux_select), .o(mux_output));
	
	stateResgister(.encoded_msg(AES_MSG_ENC, .mux_output, .state_number, ,mux_enable(mux_en), state_output(), . )
	
	
endmodule
