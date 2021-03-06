module color_mapper
(
	input  logic [3:0] colorIndex,
	output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
);

	logic [7:0] Red, Green, Blue;

	// output colors to VGA
	assign VGA_R = Red;
	assign VGA_G = Green;
	assign VGA_B = Blue;

	// assign color based on colorIndex from the FIFO
	always_comb
	begin
		case (colorIndex)
			4'h0:
			begin
				Red   = 8'hff;
				Green = 8'h85;
				Blue  = 8'hed;
			end
			4'h1:
			begin
				Red   = 8'h03;
				Green = 8'hfb;
				Blue  = 8'hff;
			end
			4'h2:
			begin
				Red   = 8'h00;
				Green = 8'h04;
				Blue  = 8'hff;
			end
			4'h3:
			begin
				Red   = 8'hff;
				Green = 8'h9d;
				Blue  = 8'h00;
			end
			4'h4:
			begin
				Red   = 8'hfc;
				Green = 8'hf0;
				Blue  = 8'h03;
			end
			4'h5:
			begin
				Red   = 8'h02;
				Green = 8'heb;
				Blue  = 8'h44;
			end
			4'h6:
			begin
				Red   = 8'hb4;
				Green = 8'h02;
				Blue  = 8'heb;
			end
			4'h7:
			begin
				Red   = 8'hde;
				Green = 8'h00;
				Blue  = 8'h00;
			end
			4'h8:
			begin
				Red   = 8'h18;
				Green = 8'h17;
				Blue  = 8'h21;
			end
			4'h9:
			begin
				Red   = 8'h4a;
				Green = 8'h48;
				Blue  = 8'h61;
			end
			4'ha:
			begin
				Red   = 8'hff;
				Green = 8'hff;
				Blue  = 8'hff;
			end

			default: // black
			begin
				Red   = 8'h00;
				Green = 8'h00;
				Blue  = 8'h00;
			end
		endcase
	end
endmodule
