// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper
(
    input  logic drawBlock,
    input  logic [2:0] colorIndex,
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
            // White ball
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
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
