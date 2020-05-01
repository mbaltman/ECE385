module checksavedboundary
(
    input  logic [9:0]    Block_X_Pos,
                          Block_Y_Pos,
    input  logic [1439:0] savedblocks,
    input  logic [9:0]    bottom1,
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
                          right4,
    input  logic          is_currentstate,
    output logic          bottomchecked,
                          leftchecked,
                          rightchecked
);

    // bottom >= 10'd459 means board bottom going to be absolutely reached
    // 10'd1023 means not bounded
    integer topleft_x, topleft_y, b1in, b2in, b3in, b4in, l1i, l2i, l3i, l4i, r1i, r2i, r3i, r4i, b1ic, b2ic, b3ic, b4ic;
    logic b1, b2, b3, b4, l1, l2, l3, l4, r1, r2, r3, r4;

    always_comb
    begin
        topleft_x = Block_X_Pos / 10'd20;
        topleft_y = Block_Y_Pos / 10'd20;
        b1in = (bottom1+10'd2) / 10'd20; // checks next block if close to the current grid edge
        b2in = (bottom2+10'd2) / 10'd20;
        b3in = (bottom3+10'd2) / 10'd20;
        b4in = (bottom4+10'd2) / 10'd20;
        b1ic = bottom1 / 10'd20; // checks current block
        b2ic = bottom2 / 10'd20;
        b3ic = bottom3 / 10'd20;
        b4ic = bottom4 / 10'd20;
        l1i = left1 / 10'd20;
        l2i = left2 / 10'd20;
        l3i = left3 / 10'd20;
        l4i = left4 / 10'd20;
        r1i = right1 / 10'd20;
        r2i = right1 / 10'd20;
        r3i = right3 / 10'd20;
        r4i = right4 / 10'd20;

        if (bottom1 == 10'd1023)
            b1 = 1'b1;
        else if (bottom1 >= 10'd459)
            b1 = 1'b0;
        else if (savedblocks[((b1in*10 + 0)*6) +: 6] == 6'd37 && savedblocks[((b1ic*10 + 0)*6) +: 6] == 6'd37)
            b1 = 1'b1;
        else
            b1 = 1'b0;
        if (bottom2 == 10'd1023)
            b2 = 1'b1;
        else if (bottom2 >= 10'd459)
            b2 = 1'b0;
        else if (savedblocks[((b2in*10 + 1)*6) +: 6] == 6'd37 && savedblocks[((b2ic*10 + 1)*6) +: 6] == 6'd37)
            b2 = 1'b1;
        else
            b2 = 1'b0;
        if (bottom3 == 10'd1023)
            b3 = 1'b1;
        else if (bottom3 >= 10'd459)
            b3 = 1'b0;
        else if (savedblocks[((b3in*10 + 2)*6) +: 6] == 6'd37 && savedblocks[((b3ic*10 + 2)*6) +: 6] == 6'd37)
            b3 = 1'b1;
        else
            b3 = 1'b0;
        if (bottom4 == 10'd1023)
            b4 = 1'b1;
        else if (bottom4 >= 10'd459)
            b4 = 1'b0;
        else if (savedblocks[((b4in*10 + 3)*6) +: 6] == 6'd37 && savedblocks[((b4ic*10 + 3)*6) +: 6] == 6'd37)
            b4 = 1'b1;
        else
            b4 = 1'b0;

        if (left1 == 10'd1023) // check if there exists a block on the first row
            l1 = 1'b1;
        else if (is_currentstate && left1 < 10'd20) // if current state, check whether already at left edge
            l1 = 1'b0;
        else if (!is_currentstate && left1 < 10'd0) // if not current state, check if out of left bound
            l1 = 1'b0;
        else if (is_currentstate && savedblocks[(((topleft_y + 0)*10 + l1i-1)*6) +: 6] == 6'd37) // if current state, check whether vacant on the left
            l1 = 1'b1;
        else if (!is_currentstate && savedblocks[(((topleft_y + 0)*10 + l1i)*6) +: 6] == 6'd37) // if not current state, check whether vacant
            l1 = 1'b1;
        else // operation not allowed by default
            l1 = 1'b0;
        if (left2 == 10'd1023) // check if there exists a block on the second row
            l2 = 1'b1;
        else if (is_currentstate && left2 < 10'd20) // if current state, check whether already at left edge
            l2 = 1'b0;
        else if (!is_currentstate && left2 < 10'd0) // if not current state, check if out of left bound
            l2 = 1'b0;
        else if (is_currentstate && savedblocks[(((topleft_y + 1)*10 + l2i-1)*6) +: 6] == 6'd37) // if current state, check whether vacant on the left
            l2 = 1'b1;
        else if (!is_currentstate && savedblocks[(((topleft_y + 1)*10 + l2i)*6) +: 6] == 6'd37) // if not current state, check whether vacant
            l2 = 1'b1;
        else // operation not allowed by default
            l2 = 1'b0;
        if (left3 == 10'd1023)
            l3 = 1'b1;
        else if (is_currentstate && left3 < 10'd20)
            l3 = 1'b0;
        else if (!is_currentstate && left3 < 10'd0)
            l3 = 1'b0;
        else if (is_currentstate && savedblocks[(((topleft_y + 2)*10 + l3i-1)*6) +: 6] == 6'd37)
            l3 = 1'b1;
        else if (!is_currentstate && savedblocks[(((topleft_y + 2)*10 + l3i)*6) +: 6] == 6'd37)
            l3 = 1'b1;
        else
            l3 = 1'b0;
        if (left4 == 10'd1023)
            l4 = 1'b1;
        else if (is_currentstate && left4 < 10'd20)
            l4 = 1'b0;
        else if (!is_currentstate && left4 < 10'd0)
            l4 = 1'b0;
        else if (is_currentstate && savedblocks[(((topleft_y + 3)*10 + l4i-1)*6) +: 6] == 6'd37)
            l4 = 1'b1;
        else if (!is_currentstate && savedblocks[(((topleft_y + 3)*10 + l4i)*6) +: 6] == 6'd37)
            l4 = 1'b1;
        else
            l4 = 1'b0;

        if (right1 == 10'd1023)
            r1 = 1'b1;
        else if (is_currentstate && right1 > 10'd179)
            r1 = 1'b0;
        else if (!is_currentstate && right1 > 10'd199)
            r1 = 1'b0;
        else if (is_currentstate && savedblocks[(((topleft_y + 0)*10 + r1i+1)*6) +: 6] == 6'd37)
            r1 = 1'b1;
        else if (!is_currentstate && savedblocks[(((topleft_y + 0)*10 + r1i)*6) +: 6] == 6'd37)
            r1 = 1'b1;
        else
            r1 = 1'b0;
        if (right2 == 10'd1023)
            r2 = 1'b1;
        else if (is_currentstate && right2 > 10'd179)
            r2 = 1'b0;
        else if (!is_currentstate && right2 > 10'd199)
            r2 = 1'b0;
        else if (is_currentstate && savedblocks[(((topleft_y + 1)*10 + r2i+1)*6) +: 6] == 6'd37)
            r2 = 1'b1;
        else if (!is_currentstate && savedblocks[(((topleft_y + 1)*10 + r2i)*6) +: 6] == 6'd37)
            r2 = 1'b1;
        else
            r2 = 1'b0;
        if (right3 == 10'd1023)
            r3 = 1'b1;
        else if (is_currentstate && right3 > 10'd179)
            r3 = 1'b0;
        else if (!is_currentstate && right3 > 10'd199)
            r3 = 1'b0;
        else if (is_currentstate && savedblocks[(((topleft_y + 2)*10 + r3i+1)*6) +: 6] == 6'd37)
            r3 = 1'b1;
        else if (!is_currentstate && savedblocks[(((topleft_y + 2)*10 + r3i)*6) +: 6] == 6'd37)
            r3 = 1'b1;
        else
            r3 = 1'b0;
        if (right4 == 10'd1023)
            r4 = 1'b1;
        else if (is_currentstate && right4 > 10'd179)
            r4 = 1'b0;
        else if (!is_currentstate && right4 > 10'd199)
            r4 = 1'b0;
        else if (is_currentstate && savedblocks[(((topleft_y + 3)*10 + r4i+1)*6) +: 6] == 6'd37)
            r4 = 1'b1;
        else if (!is_currentstate && savedblocks[(((topleft_y + 3)*10 + r4i)*6) +: 6] == 6'd37)
            r4 = 1'b1;
        else
            r4 = 1'b0;

        bottomchecked = b1 && b2 && b3 && b4;
        leftchecked = l1 && l2 && l3 && l4;
        rightchecked = r1 && r2 && r3 && r4;
    end

endmodule
