module draw( input logic drawBlock,input  [9:0] DrawX, DrawY, output logic[3:0]colorindex_draw, input logic [15:0] blockstate,
	input logic [15:0] spriteoffset);


     spriteRAM blockMemory1 (.read_address(address), .Clk(Clk), .data_Out(colorIndex));
	  
		always_comb
		begin
			if(drawBlock)

			else 
				colorindex_draw= 4'h0;
		end

endmodule
