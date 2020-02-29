module ISDU(
	input logic         Clk,
						Reset,
						Run,
						Continue,
	input  logic [3:0]  Opcode,
	input  logic        IR_5,
	input  logic        IR_11,
	input  logic        BEN,

	output logic        LD_MAR,
						LD_MDR,
						LD_IR,
						LD_BEN,
						LD_CC,
						LD_REG,
						LD_PC,
						LD_LED, // for PAUSE instruction
	output logic        GatePC,
						GateMDR,
						GateALU,
						GateMARMUX,
	output logic [1:0]  PCMUX,
	output logic        DRMUX,
						SR1MUX,
						SR2MUX,
						ADDR1MUX,
	output logic [1:0]  ADDR2MUX,
						ALUK,
	output logic        Mem_CE,
						Mem_UB,
						Mem_LB,
						Mem_OE,
						Mem_WE,
	output integer  stateNumber);

	enum logic [4:0] {	Halted,
						PauseIR1,
						PauseIR2,
						S_00,
						S_01,
						S_04,
						S_05,
						S_06,
						S_07,
						S_09,
						S_12,
						S_16_1,
						S_16_2,
						S_16_3,
						S_18,
						S_21,
						S_22,
						S_23,
						S_25_1,
						S_25_2,
						S_27,
						S_32,
						S_33_1,
						S_33_2,
						S_35 } State, Next_state; // Internal state logic

	always_ff @ (posedge Clk)
	begin
		if (Reset)
			State <= Halted;
		else
			State <= Next_state;
	end

	always_comb
	begin
		// Default next state is staying at current state
		Next_state = State;
		stateNumber = 999;
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;

		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;

		ALUK = 2'b00;
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00;

		Mem_OE = 1'b1;
		Mem_WE = 1'b1;

		// Assign next state
		unique case (State)
			Halted :
				if (Run)
					Next_state = S_18;

			PauseIR1 :
				if (~Continue)
					Next_state = PauseIR1;
				else
					Next_state = PauseIR2;
			PauseIR2 :
				if (Continue)
					Next_state = PauseIR2;
				else
					Next_state = S_18;

			S_00 :
				begin
					if(BEN)
						Next_state = S_22;
					else
						Next_state = S_18;
				end

			S_01 :
				Next_state = S_18;
				
			S_04 :
				Next_state = S_21;
				
			S_05 :
				Next_state = S_18;

			S_06 :
				Next_state = S_25_1;

			S_07 :
				Next_state = S_23;
				
			S_09 :
				Next_state = S_18;
				
			S_12 :
				Next_state = S_18;

			S_16_1 :
				Next_state = S_16_2;
			S_16_2 :
				Next_state = S_16_3;
			S_16_3:
				Next_state = S_18;

			S_18 :
				Next_state = S_33_1;
				
			S_21 :
				Next_state = S_18;
				
			S_22 :
				Next_state = S_18;

			S_23 :
				Next_state = S_16_1;

			S_25_1 :
				Next_state = S_25_2;
			S_25_2 :
				Next_state = S_27;

			S_27 :
				Next_state = S_18;

			S_32 :
				case (Opcode)
					4'b0000 :
						Next_state = S_00;
					4'b0001 :
						Next_state = S_01;
					4'b0100 :
						Next_state = S_04;
					4'b0101 :
						Next_state = S_05;
					4'b0110 :
						Next_state = S_06;
					4'b0111 :
						Next_state = S_07;
					4'b1001 :
						Next_state = S_09;
					4'b1100 :
						Next_state = S_12;
					4'b1101 :
						Next_state = PauseIR1;
					default :
						Next_state = S_18;
				endcase

			S_33_1 :
				Next_state = S_33_2;
			S_33_2 :
				Next_state = S_35;

			S_35 :
				Next_state = S_32;

			default: ;
		endcase

		// Assign control signals based on current state
		case (State)
			Halted: ;

			PauseIR1, PauseIR2 : 
				begin
					stateNumber =  991;
					LD_LED =1'b1;
				end
			
			S_00 :stateNumber =  0;
				
			S_01 :
				begin
					SR2MUX = IR_5;
					ALUK = 2'b00;
					GateALU = 1'b1;
					DRMUX = 1'b0;
					LD_REG = 1'b1;
					LD_CC = 1'b1;
					stateNumber =  1;
				end
			
			S_04 :
				begin
					GatePC = 1'b1;
					DRMUX =1'b1;
					LD_REG = 1'b1;
					stateNumber =  4;
				end
			S_05 :
				begin
					SR1MUX = 1'b1;
					ALUK = 2'b01;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					DRMUX = 1'b0;
					LD_CC = 1'b1;
					stateNumber =  5;
				end

			S_06, S_07 :
				begin
					LD_MAR = 1'b1;
					SR1MUX = 1'b1;
					
					ADDR1MUX = 1'b1;
					ADDR2MUX = 2'b01;
					GateMARMUX = 1'b1;
					
					stateNumber = 67;
				end
			
			S_09 :
				begin
					LD_CC =1'b1;
					SR1MUX = 1'b1;
					DRMUX = 1'b0;
					LD_REG = 1'b1;
					ALUK = 2'b10;
					GateALU =1'b1;
					stateNumber = 09;
				end
			S_12 :
				begin
					LD_PC = 1'b1;
					PCMUX = 2'b10;
					ADDR1MUX = 1'b1;
					ADDR2MUX = 2'b01;
					SR1MUX = 1'b1;
					stateNumber = 12;
				end
			S_16_1, S_16_2, S_16_3 :
				begin
					Mem_WE = 1'b0;
					Mem_OE = 1'b0;
					stateNumber =  16;
				end

			S_18 :
				begin
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
					stateNumber =  18;
				end
			S_21 :
				begin
					ADDR2MUX = 2'b11;
					ADDR1MUX = 1'b0;
					PCMUX = 2'b10;
					LD_PC = 1'b1;
					stateNumber =  21;
				end

			S_22:
				begin
					LD_PC = 1'b1;
					ADDR2MUX = 2'b10;
					ADDR1MUX = 1'b0;
					PCMUX = 2'b10;
					stateNumber = 22;
				end

			S_23 :
				begin
					SR1MUX = 1'b0;
					ALUK = 2'b11;
					GateALU = 1'b1;
					LD_MDR = 1'b1;
					Mem_OE = 1'b1;
					stateNumber = 23;
				end

			S_25_1, S_25_2 :
				begin
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
					stateNumber = 25;
				end

			S_27 :
				begin
					LD_CC = 1'b1;
					GateMDR = 1'b1;
					DRMUX = 1'b0;
					LD_REG = 1'b1;
					stateNumber = 27;
				end

			S_32 :
			begin
				LD_BEN = 1'b1;
				stateNumber = 32;
			end

			S_33_1 :
			begin
				Mem_OE = 1'b0;
				stateNumber = 331;
			end
			S_33_2 :
				begin
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
					stateNumber = 332;
				end

			S_35 :
				begin
					GateMDR = 1'b1;
					LD_IR = 1'b1;
					stateNumber = 35;
				end

			default: ;
		endcase
	end

	// These should always be active
	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;
endmodule
