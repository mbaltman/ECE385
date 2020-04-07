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
	
	//logic RESET;
	//assign RESET = resetAES | (state_number ==0);
	
	logic [1:0] mux_select;
	logic mux_en;
	logic [127:0] mux_output, state_output, iark, isr;
	
	logic [7:0] sb1,sb2,sb3,sb4,sb5,sb6,sb7,sb8, sb9, sb10,sb11,sb12,sb13,sb14,sb15,sb16;
	integer state_number, round;
	
	logic [1407:0] key_schedule;
	logic[31:0] MC1,MC2,MC3,MC4;
	
	always_comb
	begin
		if(AES_DONE == 1)
			 AES_MSG_DEC = state_output;
	end
	
	
	InvSubBytes byte1(.clk(CLK),.in(state_output[7:0]),.out(sb1));
	InvSubBytes byte2(.clk(CLK),.in(state_output[15:8]),.out(sb2));
	InvSubBytes byte3(.clk(CLK),.in(state_output[23:16]),.out(sb3));
	InvSubBytes byte4(.clk(CLK),.in(state_output[31:24]),.out(sb4));
	InvSubBytes byte5(.clk(CLK),.in(state_output[39:32]),.out(sb5));
	InvSubBytes byte6(.clk(CLK),.in(state_output[47:40]),.out(sb6));
	InvSubBytes byte7(.clk(CLK),.in(state_output[55:48]),.out(sb7));
	InvSubBytes byte8(.clk(CLK),.in(state_output[63:56]),.out(sb8));
	InvSubBytes byte9(.clk(CLK),.in(state_output[71:64]),.out(sb9));
	InvSubBytes byte10(.clk(CLK),.in(state_output[79:72]),.out(sb10));
	InvSubBytes byte11(.clk(CLK),.in(state_output[87:80]),.out(sb11));
	InvSubBytes byte12(.clk(CLK),.in(state_output[95:88]),.out(sb12));
	InvSubBytes byte13(.clk(CLK),.in(state_output[103:96]),.out(sb13));
	InvSubBytes byte14(.clk(CLK),.in(state_output[111:104]),.out(sb14));
	InvSubBytes byte15(.clk(CLK),.in(state_output[119:112]),.out(sb15));
	InvSubBytes byte16(.clk(CLK),.in(state_output[127:120]),.out(sb16));
	
	KeyExpansion key_expansion_instance(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(key_schedule));
	
	addroundkey addroundkey_instance(.KeySchedule(key_schedule), .currState(state_output), .roundnumber(round), .newState(iark));
	
	InvMixColumns mixcol1(.in(state_output[31:0]), .out(MC1));
	InvMixColumns mixcol2(.in(state_output[63:32]), .out(MC2));
	
	InvMixColumns mixcol3(.in(state_output[95:64]), .out(MC3));
	InvMixColumns mixcol4(.in(state_output[127:96]), .out(MC4));
	
	InvShiftRows isr_instance(.data_in(state_output), .data_out(isr));
	
	
	
	ISDU statemachine(.Clk(CLK), .Reset(RESET), .AES_START, .AES_DONE, .mux_en, .mux_select, .stateNumber(state_number), .Round(round));
	
	mux4 mux4Instance (.iark(iark), .isb({sb16, sb15, sb14, sb13, sb12, sb11, sb10, sb9, sb8, sb7, sb6, sb5, sb4, sb3, sb2, sb1}),
										 .imc({MC4, MC3, MC2, MC1}),
										 .isr(isr), 
										 .s(mux_select),
										 .o(mux_output));
	
	stateRegister state_instance(.clk(CLK),.reset(RESET), .encoded_msg(AES_MSG_ENC), .mux_output(mux_output), .state_number(state_number), .mux_enable(mux_en), .state_output(state_output));
	
	
endmodule
