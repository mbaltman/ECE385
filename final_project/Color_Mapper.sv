// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper
(
    input  logic drawBlock,
    input  logic [7:0] colorIndex,
    input  [9:0] DrawX, DrawY, // Current pixel coordinates
    output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
);

    logic [7:0] Red, Green, Blue;
/*	
	logic  [23:0]colorpallet [22:0] = '{24'hff0000, 24'hf83800, 24'hf0d0b0, 24'h503000,
												 24'hffe0a8, 24'h0058f8, 24'hfcfcfc, 24'hbcbcbc, 
												24'ha40000, 24'hd82800, 24'hfc7460, 24'hfcbcb0, 
												24'hf0bc3c, 24'haeacae, 24'h363301, 24'h6c6c01, 
												24'hbbbd00, 24'h88d500, 24'h398802, 24'h65b0ff, 
												24'h155ed8, 24'h800080, 24'h24188a};
	*/

	 
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
				Red= 8'h00;
				Green=8'h58;
				Blue = 8'hf8;
			end
			 8'h0e:
			 begin
				Red= 8'h36;
				Green=8'h33;
				Blue = 8'h01;
			end
				
			 8'h13:
			 begin
				Red= 8'h65;
				Green=8'hb0;
				Blue = 8'hff;
				end
			 8'h14:
			 begin
				Red= 8'h15;
				Green=8'h5e;
				Blue = 8'hd8;
			end
			 8'h16:
			 begin
				Red= 8'h24;
				Green=8'h18;
				Blue = 8'h8a;
				end
			default:
			begin
				Red= 8'h00;
				Green=8'h00;
				Blue = 8'h00;
				end
				
				endcase
        end
        else
        begin
            // Background with nice color gradient
            Red = 8'h3f;
            Green = 8'h00;
            Blue = 8'h7f - {1'b0, DrawX[9:3]};
        end
    end
endmodule
