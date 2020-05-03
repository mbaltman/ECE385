module blocks
(
    input  logic          Clk, Reset, frame_clk,
    input  logic [9:0]    DrawX, DrawY,
    input  logic [7:0]    keycode,
    input  logic [15:0]   blockstate_new,
    input  logic [239:0]  savedblocks,
    output logic [15:0]   blockstate,
    output logic [9:0]    Block_X_Pos, Block_Y_Pos,
    output logic          drawBlock,
    output logic          hitbottom,
	 input logic  [5:0]    spriteindex_new,
	 output logic [5:0] 	  spriteindex
);

/********************************************************************************************************************/

    parameter [9:0]  x_initial = 10'd80;
    parameter [9:0]  y_initial = 10'd0;
    logic     [9:0]  Block_Y_Motion;
    logic     [9:0]  Block_X_Pos_in, Block_Y_Pos_in, Block_Y_Motion_in;
    logic            frame_clk_delayed, frame_clk_rising_edge;
    logic            flag, flag_in, rot_flag, rot_flag_in;
    logic            bottomchecked,
                     leftchecked,
                     rightchecked,
                     ccwbottomchecked,
                     ccwleftchecked,
                     ccwrightchecked,
                     cwbottomchecked,
                     cwleftchecked,
                     cwrightchecked;
    logic     [15:0] blockstate_in, cwstate, ccwstate;
    logic     [9:0]  bottom1,
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
                     ccwbottom1,
                     ccwbottom2,
                     ccwbottom3,
                     ccwbottom4,
                     ccwleft1,
                     ccwleft2,
                     ccwleft3,
                     ccwleft4,
                     ccwright1,
                     ccwright2,
                     ccwright3,
                     ccwright4,
                     cwbottom1,
                     cwbottom2,
                     cwbottom3,
                     cwbottom4,
                     cwleft1,
                     cwleft2,
                     cwleft3,
                     cwleft4,
                     cwright1,
                     cwright2,
                     cwright3,
                     cwright4;
    logic hitbottom_in;

    rotation myrotationinstance (.oldstate(blockstate), .ccwstate, .cwstate);

    defineblockboundary currentblockboundaries (
                                               .Block_X_Pos,
                                               .Block_Y_Pos,
                                               .blockstate,
                                               .bottom1,
                                               .bottom2,
                                               .bottom3,
                                               .bottom4,
                                               .left1,
                                               .left2,
                                               .left3,
                                               .left4,
                                               .right1,
                                               .right2,
                                               .right3,
                                               .right4
                                               );

    defineblockboundary ccwblockboundaries (
                                           .Block_X_Pos,
                                           .Block_Y_Pos,
                                           .blockstate(ccwstate),
                                           .bottom1(ccwbottom1),
                                           .bottom2(ccwbottom2),
                                           .bottom3(ccwbottom3),
                                           .bottom4(ccwbottom4),
                                           .left1(ccwleft1),
                                           .left2(ccwleft2),
                                           .left3(ccwleft3),
                                           .left4(ccwleft4),
                                           .right1(ccwright1),
                                           .right2(ccwright2),
                                           .right3(ccwright3),
                                           .right4(ccwright4)
                                           );

    defineblockboundary cwblockboundaries (
                                          .Block_X_Pos,
                                          .Block_Y_Pos,
                                          .blockstate(cwstate),
                                          .bottom1(cwbottom1),
                                          .bottom2(cwbottom2),
                                          .bottom3(cwbottom3),
                                          .bottom4(cwbottom4),
                                          .left1(cwleft1),
                                          .left2(cwleft2),
                                          .left3(cwleft3),
                                          .left4(cwleft4),
                                          .right1(cwright1),
                                          .right2(cwright2),
                                          .right3(cwright3),
                                          .right4(cwright4)
                                          );

    checksavedboundary currentboundariescheck (
                                              .Block_X_Pos,
                                              .Block_Y_Pos,
                                              .savedblocks,
                                              .bottom1,
                                              .bottom2,
                                              .bottom3,
                                              .bottom4,
                                              .left1,
                                              .left2,
                                              .left3,
                                              .left4,
                                              .right1,
                                              .right2,
                                              .right3,
                                              .right4,
                                              .is_currentstate(1'b1),
                                              .bottomchecked,
                                              .leftchecked,
                                              .rightchecked
                                              );

    checksavedboundary ccwboundariescheck (
                                          .Block_X_Pos,
                                          .Block_Y_Pos,
                                          .savedblocks,
                                          .bottom1(ccwbottom1),
                                          .bottom2(ccwbottom2),
                                          .bottom3(ccwbottom3),
                                          .bottom4(ccwbottom4),
                                          .left1(ccwleft1),
                                          .left2(ccwleft2),
                                          .left3(ccwleft3),
                                          .left4(ccwleft4),
                                          .right1(ccwright1),
                                          .right2(ccwright2),
                                          .right3(ccwright3),
                                          .right4(ccwright4),
                                          .is_currentstate(1'b0),
                                          .bottomchecked(ccwbottomchecked),
                                          .leftchecked(ccwleftchecked),
                                          .rightchecked(ccwrightchecked)
                                          );

    checksavedboundary cwboundariescheck (
                                         .Block_X_Pos,
                                         .Block_Y_Pos,
                                         .savedblocks,
                                         .bottom1(cwbottom1),
                                         .bottom2(cwbottom2),
                                         .bottom3(cwbottom3),
                                         .bottom4(cwbottom4),
                                         .left1(cwleft1),
                                         .left2(cwleft2),
                                         .left3(cwleft3),
                                         .left4(cwleft4),
                                         .right1(cwright1),
                                         .right2(cwright2),
                                         .right3(cwright3),
                                         .right4(cwright4),
                                         .is_currentstate(1'b0),
                                         .bottomchecked(cwbottomchecked),
                                         .leftchecked(cwleftchecked),
                                         .rightchecked(cwrightchecked)
                                         );

    always_ff @ (posedge Clk)
    begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end

    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Block_X_Pos <= x_initial;
            Block_Y_Pos <= y_initial;
            Block_Y_Motion <= 10'd1;
            flag <= 1'b0;
            rot_flag <= 1'b0;
            blockstate <= blockstate_new;
				spriteindex <= spriteindex_new;
				hitbottom <= 1'b0;
        end
    end

/********************************************************************************************************************/

    always_comb
    begin
        blockstate_in = blockstate;
        Block_X_Pos_in = Block_X_Pos;
        Block_Y_Pos_in = Block_Y_Pos;
        Block_Y_Motion_in = Block_Y_Motion;
        flag_in = flag;
        rot_flag_in = rot_flag;
        hitbottom_in = hitbottom;

        if (Reset)
            blockstate_in = blockstate_new;

        if (frame_clk_rising_edge)
        begin
            if (!bottomchecked) // check if still moving down
            begin
                hitbottom_in = 1'b1;
                Block_Y_Motion_in = 1'b0;
                flag_in = 1'b1;
                rot_flag_in = 1'b1;
            end
            // A key: move block left by 20 pixels
            else if ((keycode == 8'h04) && leftchecked && (flag == 1'b0))
            begin
                Block_X_Pos_in = Block_X_Pos - 10'd20;
                flag_in = 1'b1;
                rot_flag_in = 1'b1;
            end
            // D key: move block right by 20 pixels
            else if ((keycode == 8'h07) && rightchecked && (flag == 1'b0))
            begin
                Block_X_Pos_in = Block_X_Pos + 10'd20;
                flag_in = 1'b1;
                rot_flag_in = 1'b1;
            end
            // Q key: rotate ccw
            else if ((keycode == 8'd20) && ccwbottomchecked && ccwleftchecked && ccwrightchecked && (rot_flag == 1'b0))
            begin
                blockstate_in = ccwstate;
                flag_in = 1'b1;
                rot_flag_in = 1'b1;
            end
            // E key: rotate cw
            else if ((keycode == 8'd08) && cwbottomchecked && cwleftchecked && cwrightchecked && (rot_flag == 1'b0))
            begin
                blockstate_in = cwstate;
                flag_in = 1'b1;
                rot_flag_in = 1'b1;
            end
            else if ((keycode != 8'h04) && (keycode != 8'h07) && (keycode != 8'd20) && (keycode != 8'd8)) // key released
            begin
                flag_in = 1'b0;
                rot_flag_in = 1'b0;
            end

            Block_Y_Pos_in = Block_Y_Pos + Block_Y_Motion;
        end

/********************************************************************************************************************/

        if ((DrawX >= Block_X_Pos) && (DrawX < (Block_X_Pos + 10'd80)) && (DrawY >= Block_Y_Pos) && (DrawY < Block_Y_Pos + 10'd80))
        begin
            drawBlock = 1'b1;
        end
        else
        begin
            drawBlock = 1'b0;
        end
    end
endmodule
