module draw
(
	input  logic        Clk,
	input  logic        drawBlock,
	input  logic [9:0]  DrawX, DrawY, PosX, PosY,
	output logic [3:0]  colorindex_draw,
	input  logic [15:0] blockstate,
	input  logic [5:0]  spriteindex,
	input logic [239:0] backgroundstate
);

	logic [15:0] address;
	logic [3:0]  blockstateindex;
	logic [3:0] colorindex;
	logic [7:0] posxi,posyi;
	logic isblock;

	spriteRAM blockMemory1 (.read_address(address), .Clk(Clk), .data_Out(colorindex));

	always_comb
	begin
		address = 15'b0;
		blockstateindex = 4'b0;
		colorindex_draw = 4'h8;
		posxi = DrawX / 10'd20;
		posyi = DrawY / 10'd20;

		isblock = backgroundstate[posyi*8'd10 + posxi];
		blockstateindex = ((DrawY - PosY)/10'd20)*10'd4 + ((DrawX - PosX)/10'd20);

		if (drawBlock && blockstate[blockstateindex])
		begin
			colorindex_draw = colorindex;
			address = ((DrawY - PosY)%10'd20 * 15'd20) + DrawX%10'd20 + spriteindex * 15'd400;
		end
		else if( DrawX < 10'd200)
		begin
			if(isblock)
				address = ((DrawY % 10'd20) * 10'd20) + ((DrawX % 10'd20) + 15'd38 * 15'd400);
			else
				address = ((DrawY % 10'd20) * 10'd20) + ((DrawX % 10'd20) + 15'd37 * 15'd400);

			colorindex_draw = colorindex;
		end

	end
endmodule
