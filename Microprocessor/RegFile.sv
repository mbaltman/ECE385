module RegFile_module(	input logic[15:0] data, input logic[2:0] SR1_11, input logic[2:0] SR1_8, input logic [2:0] SR2_2,
						input logic DRMUX, SR1MUX, LD_REG, clk, reset,
						output logic [15:0] SR1, SR2 );

	logic[15:0] registers [7:0]; //create 8 8-bit wide registers
	logic[2:0] destinationReg, SR1_SRC;

	mux2 #(3) drmux (.d0(SR1_11), .d1(3'b111), .s(DRMUX), .y(destinationReg));
	mux2 #(3) srmux (.d0(SR1_11), .d1(SR1_8), .s(SR1MUX), .y(SR1_SRC));

	always_ff @ (posedge clk)
	begin
		if (reset)
			begin
				registers[0] = 16'h0000;
				registers[1] = 16'h0000;
				registers[2] = 16'h0000;
				registers[3] = 16'h0000;
				registers[4] = 16'h0000;
				registers[5] = 16'h0000;
				registers[6] = 16'h0000;
				registers[7] = 16'h0000;
			end

		else if (LD_REG)
			unique case(destinationReg)
				3'b000:
					registers[0] = data;
				3'b001:
					registers[1] = data;
				3'b010:
					registers[2] = data;
				3'b011:
					registers[3] = data;
				3'b100:
					registers[4] = data;
				3'b101:
					registers[5] = data;
				3'b110:
					registers[6] = data;
				3'b111:
					registers[7] = data;
			endcase

		unique case(SR2_2)
			3'b000:
				SR2 = registers[0];
			3'b001:
				SR2 = registers[1];
			3'b010:
				SR2 = registers[2];
			3'b011:
				SR2 = registers[3];
			3'b100:
				SR2 = registers[4];
			3'b101:
				SR2 = registers[5];
			3'b110:
				SR2 = registers[6];
			3'b111:
				SR2 = registers[7];
		endcase

		unique case(SR1_SRC)
			3'b000:
				SR1 = registers[0];
			3'b001:
				SR1 = registers[1];
			3'b010:
				SR1 = registers[2];
			3'b011:
				SR1 = registers[3];
			3'b100:
				SR1 = registers[4];
			3'b101:
				SR1 = registers[5];
			3'b110:
				SR1 = registers[6];
			3'b111:
				SR1 = registers[7];
		endcase
	end
endmodule
