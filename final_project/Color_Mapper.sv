// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper
(
	input  logic drawBlock,
	input  logic [7:0] colorIndex,
	input  [9:0] DrawX, DrawY, // Current pixel coordinates
	output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
);

	logic [7:0] Red, Green, Blue;

	// Output colors to VGA
	assign VGA_R = Red;
	assign VGA_G = Green;
	assign VGA_B = Blue;

	// Assign color based on is_ball signal
	always_comb
	begin
		if (drawBlock == 1'b1)
		begin
			case(colorIndex)
				8'h05:
				begin
					Red = 8'h00;
					Green = 8'h58;
					Blue = 8'hf8;
				end
				8'h0e:
				begin
					Red = 8'h36;
					Green = 8'h33;
					Blue = 8'h01;
				end
				8'h13:
				begin
					Red = 8'h65;
					Green = 8'hb0;
					Blue = 8'hff;
				end
				8'h14:
				begin
					Red = 8'h15;
					Green = 8'h5e;
					Blue = 8'hd8;
				end
				8'h16:
				begin
					Red = 8'h24;
					Green = 8'h18;
					Blue = 8'h8a;
				end
				default:
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
			endcase
		end

		else
		begin
			// Background with black
			Red = 8'h00;
			Green = 8'h00;
			Blue = 8'h00;
		end
	end
endmodule
