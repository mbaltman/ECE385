module mux4 (
	input  logic [127:0] iark, isr, isb, imc,
	input  logic [1:0] s,
	output logic [127:0] o);

	always_comb
	begin
		unique case(s)
			2'b00:
				o = iark;
			2'b01:
				o = isr;
			2'b10:
				o = isb;
			2'b11:
				o = imc;
		endcase
	end
endmodule
