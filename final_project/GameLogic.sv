module GameLogic(input logic Clk, Reset,
					  input logic [7:0] keycode,
					  input logic hitbottom,
					  output logic [15:0] blockstate_new, blockstate_hold,
					  output logic [5:0] spriteindex, spriteindex_hold,
					  output logic resetBlocks, Pause, 
					  input logic  endgame,
					  output logic [2:0] screen );
					  
enum logic [4:0] { Wait, Drop,DropNoReset, Falling, Hold1 , Bottom, PauseState1, PauseState2, endScreen  } 
						State, Next_state;
						
logic canHold, canHold_in, resetPiece;
logic [5:0] spriteindex_in, spriteindex_pick, spriteindex_hold_in;
logic [15:0] blockstate_in, blockstate_pick, blockstate_hold_in;
			
newPiece newPiecePicker(.pickPiece(resetPiece), .Clk(Clk), .blockstate_new(blockstate_pick), .spriteindex_new(spriteindex_pick));
			
	always_ff @ (posedge Clk)
	begin
		if (Reset)
			begin
				State <= Wait;
				blockstate_hold<= 16'b0;
				canHold <= 1'b1;
			end
		else if(endgame)
			State <= endScreen;
		else
		begin
			State <= Next_state;
			canHold <= canHold_in;
			spriteindex <= spriteindex_in;
			blockstate_new <= blockstate_in;
			
			blockstate_hold <= blockstate_hold_in;
			spriteindex_hold <= spriteindex_hold_in;
		end
	end

	always_comb
	begin
		Next_state = State;
		canHold_in =canHold;
		spriteindex_in = spriteindex;
		blockstate_in = blockstate_new;
		blockstate_hold_in = blockstate_hold;
		spriteindex_hold_in = spriteindex_hold;
		
		resetBlocks = 1'b0;
		resetPiece = 1'b0;
		Pause =1'b0;
		screen = 3'b0;
		
		unique case(State)
			Wait :
				if(keycode == 8'h2C)//space key pressed
					Next_state = Drop;
			Drop:
				Next_state = Falling;
				
			DropNoReset:
				Next_state = Falling;
			
			Falling:
				begin
					if(hitbottom) //if you hit the bottom
						Next_state = Bottom;
						
					else if(keycode == 8'd19) 
						Next_state = PauseState1;
						
					else if(keycode == 8'd43 && canHold)//if you hit the tab button
						Next_state = Hold1;
						
					else if(keycode == 8'h29) //if you press esc reset the game
						Next_state = Wait;
						
					else
						Next_state = Falling;
				end
				
			Hold1:
				Next_state = DropNoReset;
			
			
			Bottom:
				Next_state = Drop;
				
			PauseState1://first half of pause if you just hold P you stay in this state
				if(keycode != 8'h13) //move to this state once you let go of P,
					Next_state = PauseState2;
				else
					Next_state = PauseState1;
					
			PauseState2: 
				if(keycode == 8'd36)//pressing U will unpause the game
					Next_state = Drop;
				else
					Next_state = PauseState2;
			
			endScreen:
				if(keycode == 8'h29) //if you press esc reset the game
					Next_state = Wait;
				else
					Next_state = endScreen;
			
		
		endcase
		
		
		case(State)
			Wait:
			begin
				resetPiece = 1'b1;
				Pause = 1'b1;
				screen = 3'd2;
			end
			
			Drop:
			begin
				
				blockstate_in = blockstate_pick;
		      spriteindex_in = spriteindex_pick;
				resetBlocks = 1'b1;
				resetPiece = 1'b1;

			end
			
			DropNoReset:
			begin 
				resetBlocks = 1'b1;
			end
			
			Falling:
			begin
			end
		
			Hold1:
				begin
					blockstate_hold_in = blockstate_new;
					spriteindex_hold_in = spriteindex;
					
					if(blockstate_hold == 16'b0)
					begin
						resetPiece = 1'b1;
						blockstate_in = blockstate_pick;
						spriteindex_in = spriteindex_pick;
					end
					else
					begin
						blockstate_in = blockstate_hold;
						spriteindex_in = spriteindex_hold;
					end
					canHold_in = 1'b0;
				end
		
			Bottom:
				canHold_in = 1'b1;
		
			PauseState1, PauseState2:
				begin
					Pause = 1'b1;
					screen = 3'b1;
				end
			
			endScreen:
				begin
					Pause = 1'd1;
					screen = 3'd3	
				end
			
			endcase
	end
endmodule
