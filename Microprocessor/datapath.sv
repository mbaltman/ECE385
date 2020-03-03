module datapath(
	input  logic [15:0] MDR, PC, MARMUX, ALUOUT,
	input  logic s1, s2, s3, s4,
	output logic [15:0] data);

	always_comb
	begin
		if (s1)
			data = PC;//select PC
		else if (s2)
			data = MDR;// select MDR
		else if (s3)
			data = ALUOUT;//Slect ALU
		else if (s4)
			data = MARMUX;//Select out put of address adders
		else
			data = 16'hZZZZ;//no data
		end
endmodule
