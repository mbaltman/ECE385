module datapath(input logic [15:0] MDR, PC, ADDADD, ALUOUT,
					 input logic s1,s2,s3,s4,
					 output logic [15:0] data);

	always_comb
		begin
			if(s1)
				data = PC;
			else if(s2)
				data = MDR;
			else if(s3)
				data = ALUOUT;
			else if(s4)
				data = ADDADD;
			else
				data = 16'bZ;
		end 
		
endmodule
