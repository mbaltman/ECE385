module mux2_3bit( input logic[2:0] d0, d1, input logic s,
						output logic[2:0] y) ;
	always_comb
		begin
			if (s)
				y = d1;
			else
            y = d0;
		end
endmodule
