module ISDU (
	input  logic       Clk, Reset, AES_START,
	output logic       AES_DONE, mux_en,
	output logic       [1:0] mux_select,
	output integer     stateNumber, Round);

	enum logic [4:0] {	Wait,
						Key_Expansion1,
						Key_Expansion2,
						Key_Expansion3,
						Key_Expansion4,
						Key_Expansion5,
						Key_Expansion6,
						Key_Expansion7,
						Key_Expansion8,
						Key_Expansion9,
						Key_Expansion10,
						IARK,
						ISR,
						ISB,
						IMC,
						Done,
						S0,
						S1,
						S2,
						S3,
						S4,
						S5,
						S6,
						S7,
						S8,
						S9,
						S10
						} State, Next_state, State_counter, Next_state_counter; // internal state logic


	always_ff @ (posedge Clk)
	begin
		if (Reset)
			begin
			State <= Wait;
			State_counter <= S0;
			end
		else
		begin
			State <= Next_state;
			State_counter <= Next_state_counter;
		end
	end

	always_comb
	begin
		// default next state is staying at current state
		Next_state = State;
		Next_state_counter = State_counter;

		// default controls signal values
		stateNumber = 999;
		mux_en = 1'b0;
		mux_select = 2'b00;
		Round = 0;
		AES_DONE = 1'b0;

		// assign next state
		unique case (State) // state transtions
			Wait :
			begin
				if (AES_START)
					Next_state = Key_Expansion1;
					Next_state_counter = S0;
			end

			Key_Expansion1  : Next_state = Key_Expansion2;
			Key_Expansion2  : Next_state = Key_Expansion3;
			Key_Expansion3  : Next_state = Key_Expansion4;
			Key_Expansion4  : Next_state = Key_Expansion5;
			Key_Expansion5  : Next_state = Key_Expansion6;
			Key_Expansion6  : Next_state = Key_Expansion7;
			Key_Expansion7  : Next_state = Key_Expansion8;
			Key_Expansion8  : Next_state = Key_Expansion9;
			Key_Expansion9  : Next_state = Key_Expansion10;
			Key_Expansion10 : Next_state = IARK;

			IARK :
			begin
				if (State_counter == S0)
				begin
					Next_state = ISR;
				end
				else if (State_counter == S10)
				begin
					Next_state = Done;
				end
				else
				begin
					Next_state = IMC;
				end

				begin
					unique case (State_counter) // takes care of number of rounds
					S0  : Next_state_counter = S1;
					S1  : Next_state_counter = S2;
					S2  : Next_state_counter = S3;
					S3  : Next_state_counter = S4;
					S4  : Next_state_counter = S5;
					S5  : Next_state_counter = S6;
					S6  : Next_state_counter = S7;
					S7  : Next_state_counter = S8;
					S8  : Next_state_counter = S9;
					S9  : Next_state_counter = S10;
					S10 : Next_state_counter = S10;
					endcase
				end
			end

			ISR : Next_state = ISB;

			ISB : Next_state = IARK;

			IMC : Next_state = ISR;

			Done :
			begin
				if (AES_START == 1'b0)
					Next_state = Wait;
				else
					Next_state = Done;
			end

			default: ;
		endcase

		// assign control signals based on current state
		case (State)
			Wait:
				begin
					stateNumber = 0;
				end

			Key_Expansion1, Key_Expansion2, Key_Expansion3, Key_Expansion4, Key_Expansion5, Key_Expansion6, Key_Expansion7, Key_Expansion8, Key_Expansion9, Key_Expansion10:
				begin
					stateNumber = 1;
				end

			IARK:
				begin
					mux_en = 1'b1;
					stateNumber = 2;
				end

			ISR:
				begin
					mux_select = 2'b01;
					mux_en = 1'b1;
					stateNumber = 3;
				end

			ISB:
				begin
					mux_select = 2'b10;
					mux_en = 1'b1;
					stateNumber = 4;
				end

			IMC:
				begin
					mux_select = 2'b11;
					mux_en = 1'b1;
					stateNumber = 5;
				end

			Done:
				begin
					AES_DONE = 1'b1;
					stateNumber = 6;
				end

			default: ;
		endcase

		case (State_counter) // output round number integer
			S0:  Round = 10;
			S1:  Round = 9;
			S2:  Round = 8;
			S3:  Round = 7;
			S4:  Round = 6;
			S5:  Round = 5;
			S6:  Round = 4;
			S7:  Round = 3;
			S8:  Round = 2;
			S9:  Round = 1;
			S10: Round = 0;
		endcase
	end
endmodule
