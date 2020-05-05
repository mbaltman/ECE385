

module newPiece(input logic pickPiece,
					 input logic Clk,Reset,
					 output logic [15:0] blockstate_new,
					 output logic [5:0] spriteindex_new);

logic [2:0] piece;
logic [7:0] counter, counter_in;


always_ff @ (posedge Clk)
	begin
	
		counter <=counter_in;
		
		if(Reset)
			counter <= 8'b0;
	end
	
 always_comb
 begin
 blockstate_new = 16'b1111111111111111;
 spriteindex_new = 6'b0;
	counter_in= counter +8'b1;
	
  piece = counter % 3'h7;
  
  if(pickPiece)
	begin	
		case(piece)
		 //T piece
			3'd0:
			begin
				blockstate_new = 16'b0000000000100111;
				spriteindex_new = 6'd41;
				counter_in= counter +8'd4;
			end
		//I piece
			3'd1:
			begin
				blockstate_new = 16'b0001000100010001;
				spriteindex_new = 6'd43;
				counter_in= counter +8'd3;
			end
		// J
			3'd2:
			begin
				blockstate_new = 16'b0000001100100010;
				spriteindex_new = 6'd38;
				counter_in= counter +8'd2;
			end
		// L
			3'd3:
			begin
				blockstate_new = 16'b0000001100010001;
				spriteindex_new = 6'd40;
				counter_in= counter +8'd3;
			end
		// O
			3'd4:
			begin
				blockstate_new = 16'b0000000000110011;
				spriteindex_new = 6'd44;
				counter_in= counter +8'd7;
			end
		// S
			3'd5:
			begin
				blockstate_new = 16'b0000000000110110;
				spriteindex_new = 6'd39;
				counter_in= counter +8'd3;
			end
		// Z
			3'd6:
			begin
				blockstate_new = 16'b0000000001100011;
				spriteindex_new = 6'd42;
				counter_in= counter +8'd2;
			end
			
			
		endcase
	 end
 
 end
 
endmodule

