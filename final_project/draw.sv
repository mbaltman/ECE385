module draw
(
	input  logic         Clk,
	input  logic         drawBlock,
	input  logic [9:0]   DrawX, DrawY, PosX, PosY,
	output logic [3:0]   colorindex_draw,
	input  logic [15:0]  blockstate,
	input  logic [5:0]   spriteindex,
	input  logic [239:0] backgroundstate,
	input  logic         displayMenu
);

	logic [14:0] address;
	logic [3:0]  blockstateindex;
	logic [3:0]  colorindex;
	logic [7:0]  posxi, posyi;
	logic        isblock;
	logic [5:0]  spriteindexcurr, spriteindexbg;

	spriteRAM blockMemory1 (.read_address(address), .Clk(Clk), .data_Out(colorindex));

	background bginstance (.DrawX(DrawX), .DrawY(DrawY), .spriteindex(spriteindexbg));
	always_comb
	begin
		address = 15'b0;
		spriteindexcurr = 6'd0;
		blockstateindex = 4'b0;
		colorindex_draw = 4'h8;
		posxi = (DrawX - 10'd80) / 10'd20;
		posyi = DrawY / 10'd20;

		//check if current background block is a filled
		isblock = backgroundstate[posyi*8'd10 + posxi];

		//calculate index of block state for moving piece
		blockstateindex = ((DrawY - PosY)/10'd20)*10'd4 + ((DrawX - PosX)/10'd20);


		//if draw block and block is there, draw moving block
		if (drawBlock && blockstate[blockstateindex] && DrawX > 10'd80)
		begin
			colorindex_draw = colorindex;
			address = ((DrawY - PosY)%10'd20 * 15'd20) + DrawX%10'd20 + spriteindex*15'd400;
		end
		else if(DrawX < 10'd280 && DrawX >10'd79 && DrawY >10'd78 && DrawY < 10'd82)
		begin
			colorindex_draw = 4'ha;
		end
		else
		begin
			if (DrawX < 10'd280 && DrawX >10'd79)
			begin
				if (isblock)
					spriteindexcurr = 6'd38;
				else
					spriteindexcurr = 6'd37;

			end
			else
			begin
				spriteindexcurr = spriteindexbg;
			end

			if(spriteindexcurr == 6'd45)
				begin
					colorindex_draw = 4'd8;
				end
			else
			begin
				address = ((DrawY%10'd20) * 10'd20) + ((DrawX%10'd20) + spriteindexcurr*15'd400);
				
				if(colorindex!= 4'b0)
					colorindex_draw = colorindex;
				else
					colorindex_draw = 4'd3;
			end
		end
	end
endmodule
