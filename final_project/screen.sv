module screen( input logic [2:0] screen, 
					input  logic [9:0] DrawX, DrawY,
					output logic [5:0] spriteindex,
					output logic screenshow);
                                    // P A U S E D 
logic [5:0][5:0] pausescreen  = {6'd26, 6'd11, 6'd31, 6'd29, 6'd15, 6'd14};
                                 //W    E     L        C      O      M    E
logic [6:0][5:0] startscreen  = {6'd33, 6'd15, 6'd22, 6'd13, 6'd25, 6'd23, 6'd15};
                                //G   A       M      E     _45      O       v    E     R
logic [8:0][5:0] endscreen  = {6'd17, 6'd11, 6'd23, 6'd15, 6'd45,  6'd25, 6'd32, 6'd15, 6'd28};


											//S   P   A    C  E  _ T  O   _ S T A R T
//logic [3:0][5:0] instructions  = {};

enum logic [4:0] { pause1, S, E, I} screenState;
logic [7:0]  posxi, posyi, baseindex;
			
always_comb
begin
		posxi = DrawX / 10'd20;
		posyi = DrawY / 10'd20;
		screenshow = 1'b0;
		screenState = I;
		spriteindex = 6'b0;
		
	if(screen != 3'b0)
	begin
	
   /* if(posxi> 8'd1 && posxi < 8'd16 && posyi > 8'd12 && posyi < 8'd17)
	 begin
		screenState = I;
		screenshow = 1'b0;
	 end
	 else */
	 if( screen == 3'b1 && posyi == 8'd12 && posxi >8'b1 && posxi < 8'd8)
	 begin
		screenState = pause1;
		screenshow = 1'b1;
	 end
	  else if( screen == 3'd2 && posyi == 8'd12 && posxi >8'b1 && posxi < 8'd9)
	 begin
		screenState = S;
		screenshow = 1'b1;
	 end
	  else if( screen == 3'd3 && posyi == 8'd12 && posxi >8'b1 && posxi < 8'd11)
	 begin
		screenState = E;
		screenshow = 1'b1;
	 end
	 
	end
	baseindex = (DrawX-10'd40)/10'd20;
	case(screenState)
	
		//I:
		
		pause1:
			spriteindex =  pausescreen[10'd5 - baseindex];
		S:
			spriteindex =  startscreen[10'd6 - baseindex];
			
		E:
			spriteindex =  endscreen[10'd8 - baseindex];
	
	endcase
	
	
	
end
					
endmodule