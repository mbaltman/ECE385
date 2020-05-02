module savedblocks (
    input  logic          clk, reset,
    input  logic [9:0]    Block_X_Pos,
                          Block_Y_Pos,
    input  logic [15:0]   inputstream,
    input  logic [5:0]    spriteindex,
    input  logic          saveenable,
    output logic [1439:0] state_output
    );

    logic [8:0] topleft_x, topleft_y;
	 logic [7:0] i;

    always_comb
    begin
        topleft_x = Block_X_Pos / 10'd20; // ranging from 0 to 9
        topleft_y = Block_Y_Pos / 10'd20; // ranging from 0 to 23
    end

    always_ff @ (posedge clk)
    begin
        if (reset)
        begin
            for (i = 8'd0; i < 8'd240; i = i + 8'd1)
            begin
                state_output[i*8'd6 +: 8'd6] <= 6'd37;
            end
        end
        else if (saveenable)
        begin
            state_output[(((topleft_y + 5'd0)*5'd10 + topleft_x + 5'd0)*5'd6) +: 5'd6] <= inputstream[0]  ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd0)*5'd10 + topleft_x + 5'd1)*5'd6) +: 5'd6] <= inputstream[1]  ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd0)*5'd10 + topleft_x + 5'd2)*5'd6) +: 5'd6] <= inputstream[2]  ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd0)*5'd10 + topleft_x + 5'd3)*5'd6) +: 5'd6] <= inputstream[3]  ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd1)*5'd10 + topleft_x + 5'd0)*5'd6) +: 5'd6] <= inputstream[4]  ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd1)*5'd10 + topleft_x + 5'd1)*5'd6) +: 5'd6] <= inputstream[5]  ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd1)*5'd10 + topleft_x + 5'd2)*5'd6) +: 5'd6] <= inputstream[6]  ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd1)*5'd10 + topleft_x + 5'd3)*5'd6) +: 5'd6] <= inputstream[7]  ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd2)*5'd10 + topleft_x + 5'd0)*5'd6) +: 5'd6] <= inputstream[8]  ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd2)*5'd10 + topleft_x + 5'd1)*5'd6) +: 5'd6] <= inputstream[9]  ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd2)*5'd10 + topleft_x + 5'd2)*5'd6) +: 5'd6] <= inputstream[10] ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd2)*5'd10 + topleft_x + 5'd3)*5'd6) +: 5'd6] <= inputstream[11] ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd3)*5'd10 + topleft_x + 5'd0)*5'd6) +: 5'd6] <= inputstream[12] ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd3)*5'd10 + topleft_x + 5'd1)*5'd6) +: 5'd6] <= inputstream[13] ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd3)*5'd10 + topleft_x + 5'd2)*5'd6) +: 5'd6] <= inputstream[14] ? spriteindex : 6'd37;
            state_output[(((topleft_y + 5'd3)*5'd10 + topleft_x + 5'd3)*5'd6) +: 5'd6] <= inputstream[15] ? spriteindex : 6'd37;
        end
    end
endmodule
