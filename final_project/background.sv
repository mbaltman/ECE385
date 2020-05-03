module background( input  logic [9:0]   DrawX, DrawY,
						 output logic [5:0] spriteindex
);					 
						 
logic [3:0][5:0] hold  = {6'd18, 6'd25, 6'd22, 6'd14}; 
logic [5:0][4:0] queue = {6'd27, 6'd31, 6'd15, 6'd31, 6'd15 };
/*
assign logic space =
assign logic score =
assign logic pause =
assign logic reset = 
*/
enum logic [4:0] { H, Q, BG, D} State;

logic [7:0]  posxi, posyi;
						
				
		
always_comb
begin
	posxi = (DrawX) / 10'd20;
	posyi = DrawY/ 10'd20;

	if(posxi< 8'd4 && posyi == 8'd4)
		State = H;
	else if(posxi <8'd4 && posyi > 8'd4 && posyi < 8'd9)
			State = BG;
	else if(posxi > 8'd13 && posxi < 8'd19 && posyi == 8'd4)
		State = Q;
	else if(posxi >8'd13 && posxi < 8'd18 && posyi > 8'd4 && posyi < 8'd9)
		State = BG;
	else
		State = D;
	
	case(State)
	
	H:
		spriteindex =  hold[DrawX/10'd20];
	Q: 
		spriteindex = queue[(DrawX-10'd280)/10'd20];
	BG:
		spriteindex = 6'd37;
	D:
		spriteindex = 6'd45;

	endcase
end

endmodule
