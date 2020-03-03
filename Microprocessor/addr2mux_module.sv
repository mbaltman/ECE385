
module addr2mux_module(
	input  logic [15:0] d1, d2, d3,
	input  logic [1:0] s,
	output logic [15:0] o);

	always_comb
	begin
		unique case(s)
			2'b00:
				o = 16'h0000;
			2'b01:
				o = d1;
			2'b10:
				o = d2;
			2'b11:
				o = d3;
		endcase
	end
endmodule
