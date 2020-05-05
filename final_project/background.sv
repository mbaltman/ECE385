module background
(
	input  logic [9:0] DrawX, DrawY,
	input logic [3:0] score_thousand,
   input logic [3:0] score_hundred,
   input logic [3:0] score_dec,
   input logic [3:0]score_one,
	output logic [5:0] spriteindex
);

	logic [3:0][5:0] hold  = {6'd18, 6'd25, 6'd22, 6'd14};
	logic [4:0][5:0] queue = {6'd27, 6'd31, 6'd15, 6'd31, 6'd15};
	logic [9:0][5:0] score = {6'd29, 6'd13, 6'd25, 6'd28, 6'd15, 6'd0,6'd0, 6'd0,6'd0, 6'd45};

	enum logic [4:0] {H, Q, BG, D, S} State;
	logic [7:0] posxi, posyi;

	always_comb
	begin
		posxi = DrawX / 10'd20;
		posyi = DrawY / 10'd20;
		score = {6'd29, 6'd13, 6'd25, 6'd28, 6'd15, {2'b0,score_thousand},{2'b0,score_hundred}, {2'b0,score_dec},{2'b0,score_one}, 6'd44};
		
		if (posxi < 8'd4 && posyi == 8'd4)
			State = H;
		else if (posxi < 8'd4 && posyi > 8'd4 && posyi < 8'd9)
			State = BG;
		else if (posxi > 8'd13 && posxi < 8'd19 && posyi == 8'd4)
			State = Q;
		else if (posxi > 8'd13 && posxi < 8'd18 && posyi > 8'd4 && posyi < 8'd9)
			State = BG;
		else if(posxi > 8'd13 && posxi < 8'd19 && posyi >8'd8 && posyi < 8'd11)
			State = S;
		else
			State = D;

		case (State)
		H:
			spriteindex =  hold[10'd3 - DrawX/10'd20];
		Q:
			spriteindex = queue[10'd4 - (DrawX - 10'd280)/10'd20];
		BG:
			spriteindex = 6'd37;
		D:
			spriteindex = 6'd45;
		S:
			begin
			spriteindex = score[((10'd1 -((DrawY - 10'd180)/10'd20))*10'd5) + (10'd4 - (DrawX - 10'd280)/10'd20)];
			if(posyi == 8'd10)
				spriteindex=spriteindex + 6'b1;
			end
		endcase
	end
endmodule
