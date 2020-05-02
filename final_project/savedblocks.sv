module savedblocks (
    input  logic          clk, reset,
    input  logic [9:0]    Block_X_Pos,
                          Block_Y_Pos,
    input  logic [15:0]   inputstream,
    input  logic          saveenable,
    output logic [239:0]  state_output
    );

    logic [7:0] topleft_x, topleft_y, i;

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
                state_output[i] <= 1'b1;
            end
        end
        else if (saveenable)
        begin
            state_output[(topleft_y + 8'd0)*8'd10 + topleft_x + 8'd0] <= inputstream[0]  ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd0)*8'd10 + topleft_x + 8'd1] <= inputstream[1]  ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd0)*8'd10 + topleft_x + 8'd2] <= inputstream[2]  ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd0)*8'd10 + topleft_x + 8'd3] <= inputstream[3]  ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd1)*8'd10 + topleft_x + 8'd0] <= inputstream[4]  ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd1)*8'd10 + topleft_x + 8'd1] <= inputstream[5]  ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd1)*8'd10 + topleft_x + 8'd2] <= inputstream[6]  ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd1)*8'd10 + topleft_x + 8'd3] <= inputstream[7]  ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd2)*8'd10 + topleft_x + 8'd0] <= inputstream[8]  ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd2)*8'd10 + topleft_x + 8'd1] <= inputstream[9]  ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd2)*8'd10 + topleft_x + 8'd2] <= inputstream[10] ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd2)*8'd10 + topleft_x + 8'd3] <= inputstream[11] ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd3)*8'd10 + topleft_x + 8'd0] <= inputstream[12] ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd3)*8'd10 + topleft_x + 8'd1] <= inputstream[13] ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd3)*8'd10 + topleft_x + 8'd2] <= inputstream[14] ? 1'b1 : 1'b0;
            state_output[(topleft_y + 8'd3)*8'd10 + topleft_x + 8'd3] <= inputstream[15] ? 1'b1 : 1'b0;
        end
    end
endmodule
