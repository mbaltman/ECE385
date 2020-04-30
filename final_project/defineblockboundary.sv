module defineblockboundary
(
    input  logic [9:0]  Block_X_Pos,
                        Block_Y_Pos,
    input  logic [15:0] blockstate,
    output logic [9:0]  bottom1,
                        bottom2,
                        bottom3,
                        bottom4,
                        left1,
                        left2,
                        left3,
                        left4,
                        right1,
                        right2,
                        right3,
                        right4
);

    always_comb
    begin
        if (blockstate[12])
            bottom1 = Block_Y_Pos + 10'd60;
        else if (blockstate[8])
            bottom1 = Block_Y_Pos + 10'd40;
        else if (blockstate[4])
            bottom1 = Block_Y_Pos + 10'd20;
        else if (blockstate[0])
            bottom1 = Block_Y_Pos;
        else
            bottom1 = 10'd1023; // 1st column does not have a block
        if (blockstate[13])
            bottom2 = Block_Y_Pos + 10'd60;
        else if (blockstate[9])
            bottom2 = Block_Y_Pos + 10'd40;
        else if (blockstate[5])
            bottom2 = Block_Y_Pos + 10'd20;
        else if (blockstate[1])
            bottom2 = Block_Y_Pos;
        else
            bottom2 = 10'd1023;
        if (blockstate[14])
            bottom3 = Block_Y_Pos + 10'd60;
        else if (blockstate[10])
            bottom3 = Block_Y_Pos + 10'd40;
        else if (blockstate[6])
            bottom3 = Block_Y_Pos + 10'd20;
        else if (blockstate[2])
            bottom3 = Block_Y_Pos;
        else
            bottom3 = 10'd1023;
        if (blockstate[15])
            bottom4 = Block_Y_Pos + 10'd60;
        else if (blockstate[11])
            bottom4 = Block_Y_Pos + 10'd40;
        else if (blockstate[7])
            bottom4 = Block_Y_Pos + 10'd20;
        else if (blockstate[3])
            bottom4 = Block_Y_Pos;
        else
            bottom4 = 10'd1023;

        if (blockstate[0])
            left1 = Block_X_Pos;
        else if (blockstate[1])
            left1 = Block_X_Pos + 10'd20;
        else if (blockstate[2])
            left1 = Block_X_Pos + 10'd40;
        else if (blockstate[3])
            left1 = Block_X_Pos + 10'd60;
        else
            left1 = 10'd1023;
        if (blockstate[4])
            left2 = Block_X_Pos;
        else if (blockstate[5])
            left2 = Block_X_Pos + 10'd20;
        else if (blockstate[6])
            left2 = Block_X_Pos + 10'd40;
        else if (blockstate[7])
            left2 = Block_X_Pos + 10'd60;
        else
            left2 = 10'd1023;
        if (blockstate[8])
            left3 = Block_X_Pos;
        else if (blockstate[9])
            left3 = Block_X_Pos + 10'd20;
        else if (blockstate[10])
            left3 = Block_X_Pos + 10'd40;
        else if (blockstate[11])
            left3 = Block_X_Pos + 10'd60;
        else
            left3 = 10'd1023;
        if (blockstate[12])
            left4 = Block_X_Pos;
        else if (blockstate[13])
            left4 = Block_X_Pos + 10'd20;
        else if (blockstate[14])
            left4 = Block_X_Pos + 10'd40;
        else if (blockstate[15])
            left4 = Block_X_Pos + 10'd60;
        else
            left4 = 10'd1023;

        if (blockstate[3])
            right1 = Block_X_Pos + 10'd60;
        else if (blockstate[2])
            right1 = Block_X_Pos + 10'd40;
        else if (blockstate[1])
            right1 = Block_X_Pos + 10'd20;
        else if (blockstate[0])
            right1 = Block_X_Pos;
        else
            right1 = 10'd1023;
        end
        if (blockstate[7])
            right2 = Block_X_Pos + 10'd60;
        else if (blockstate[6])
            right2 = Block_X_Pos + 10'd40;
        else if (blockstate[5])
            right2 = Block_X_Pos + 10'd20;
        else if (blockstate[4])
            right2 = Block_X_Pos;
        else
            right2 = 10'd1023;
        end
        if (blockstate[11])
            right3 = Block_X_Pos + 10'd60;
        else if (blockstate[10])
            right3 = Block_X_Pos + 10'd40;
        else if (blockstate[9])
            right3 = Block_X_Pos + 10'd20;
        else if (blockstate[8])
            right3 = Block_X_Pos;
        else
            right3 = 10'd1023;
        end
        if (blockstate[15])
            right4 = Block_X_Pos + 10'd60;
        else if (blockstate[14])
            right4 = Block_X_Pos + 10'd40;
        else if (blockstate[13])
            right4 = Block_X_Pos + 10'd20;
        else if (blockstate[12])
            right4 = Block_X_Pos;
        else
            right4 = 10'd1023;
        end
endmodule
