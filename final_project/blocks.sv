//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module blocks (input          Clk,                // 50 MHz clock
                            Reset,              // Active-high reset signal
               input [9:0]  DrawX, DrawY,       // Current pixel coordinates
               output logic [2:0] colorIndex,
					output logic drawBlock
              );

    parameter [9:0] Block_x = 10'd0;  // Center position on the X axis
    parameter [9:0] Block_y = 10'd0;  // Center position on the Y axis
	 
	 logic [9:0] address = 10'd0;
	 
    frameRAM blockMemeory(.read_address(address),.Clk(Clk),.data_Out(colorIndex));

    // You need to modify always_comb block.
    always_comb
    begin
     if(DrawX >Block_x & DrawX <Block_x + 10'd20 & DrawX >Block_y & DrawY <Block_y + 10'd20)
		begin 
			address = 20 * (DrawX-Block_x) + (DrawY-Block_y);
			drawBlock = 1'b1;
		end
		else
			drawBlock = 1'b0;
			address = 10'd0;
			
    end

endmodule
