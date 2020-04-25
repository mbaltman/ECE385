module draw( input logic drawBlock, input logic [3:0] colorindex, output colorindex_draw);

		always_comb
		begin
			if(drawBlock)
				colorindex_draw = 4'h6;
			else 
				colorindex_draw= 4'h0;
		end

endmodule
