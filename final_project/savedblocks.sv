module savedblocks (
    input  logic          clk, reset,
    input  logic [9:0]    Block_X_Pos,
                          Block_Y_Pos,
    input  logic [15:0]   inputstream,
    input  logic          saveenable,
    output logic [239:0]  state_output
    );

    logic [7:0] topleft_x, topleft_y, i;
	 logic [7:0] baseindex;

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
                state_output[i] <= 1'b0;
            end
        end
        else if (saveenable)
        begin
				baseindex = topleft_y * 8'd10;
				
            state_output[baseindex + topleft_x + 8'd0] <= inputstream[0] ;
            state_output[baseindex + topleft_x + 8'd1] <= inputstream[1] ;
            state_output[baseindex + topleft_x + 8'd2] <= inputstream[2] ;
            state_output[baseindex + topleft_x + 8'd3] <= inputstream[3] ;
				
            state_output[baseindex + 8'd10 + topleft_x + 8'd0] <= inputstream[4] ;
            state_output[baseindex + 8'd10 + topleft_x + 8'd1] <= inputstream[5] ;
            state_output[baseindex + 8'd10 + topleft_x + 8'd2] <= inputstream[6] ;
            state_output[baseindex + 8'd10 + topleft_x + 8'd3] <= inputstream[7] ;
				
            state_output[baseindex + 8'd20 + topleft_x + 8'd0] <= inputstream[8] ;
            state_output[baseindex + 8'd20 + topleft_x + 8'd1] <= inputstream[9]  ;
            state_output[baseindex + 8'd20 + topleft_x + 8'd2] <= inputstream[10] ;
            state_output[baseindex + 8'd20 + topleft_x + 8'd3] <= inputstream[11] ;
				
            state_output[baseindex + 8'd30 + topleft_x + 8'd0] <= inputstream[12] ;
            state_output[baseindex + 8'd30 + topleft_x + 8'd1] <= inputstream[13] ;
            state_output[baseindex + 8'd30 + topleft_x + 8'd2] <= inputstream[14] ;
            state_output[baseindex + 8'd30 + topleft_x + 8'd3] <= inputstream[15] ;
        end
    end
endmodule
