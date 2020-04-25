module draw( input logic Clk, input logic drawBlock,input  [9:0] DrawX, DrawY, PosX, PosY, output logic[3:0]colorindex_draw, 
				 input logic [15:0] blockstate, input logic [5:0] spriteindex);

	  logic [15:0] address;
	  logic [3:0] blockstateindex;
	  
     spriteRAM blockMemory1 (.read_address(address), .Clk(Clk), .data_Out(colorindex_draw));
	  
		always_comb
		begin
		address = 15'b 0;
		blockstateindex = 4'b0;
		
			if(drawBlock)
			begin
				blockstateindex = ((DrawY -PosY)/ 10'd20)*4 + ((DrawX -PosX)/ 10'd20);
				
				if(blockstate[blockstateindex])
				begin
					address =( (DrawY-PosY) % 10'd20  * 16'd20) + (DrawX % 10'd20 ) * spriteindex * 16'd400;			
				end
			end
			else 
			begin
				address =( (DrawY) % 10'd20  * 10'd20) + (DrawX % 10'd20 ) * 16'd37 * 400;
			end
		end

endmodule
