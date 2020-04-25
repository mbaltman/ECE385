module GPU_controller
(
    input  logic Clk, Reset,
    input  logic [9:0] DrawX, DrawY, // inputs from VGA
    input  logic VGA_BLANK_N, // used to determine if the pages should be flipped
    output logic [9:0] SaveX, SaveY, // outputs to Frame buffer, controlling what pixel is currently being calculated and saved
    ReadX, ReadY, // outputs to frame buffer, controlling what pixel is currently being read from memory into fifo
    output logic SRAM_CE_N, SRAM_UB_N, SRAM_LB_N, SRAM_OE_N, SRAM_WE_N, // everthing except OE should always be high
    output logic PauseVGA, // pauses the VGA controller while the next line is being read from memory into fifo
    output logic flip_page, fifo_we
);

    logic   [9:0] SaveX_in, SaveY_in, ReadX_in, ReadY_in;
    logic   flip_page_in;
    integer clkRead, clkRead_in;

    enum logic [4:0] { Read, ReadToWrite, Write, WriteToRead } State, Next_state;

    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            SaveX <= 10'b0;
            SaveY <= 10'b0;
            ReadX <= 10'b0;
            ReadY <= 10'b0;
            flip_page <= 1'b0;
            State <= Read;
            clkRead <= 0;
        end
        else
        begin
            SaveX <= SaveX_in;
            SaveY <= SaveY_in;
            ReadX <= ReadX_in;
            ReadY <= ReadY_in;
            flip_page <= flip_page_in;
            State <= Next_state;
            clkRead <= clkRead_in;
        end
    end

    always_comb
    begin
        //add in
        Next_state = State;
        SRAM_CE_N = 1'b1;
        SRAM_UB_N = 1'b1;
        SRAM_LB_N = 1'b1;
        SRAM_WE_N = 1'b1;
        PauseVGA = 1'b0;
        SRAM_OE_N = 1'b0;
        fifo_we = 1'b0;

        //State Transitions between the four states
        unique case (State)
            Read:
                if (ReadX == 10'd640)
                    Next_state = ReadToWrite;
            ReadToWrite:
                Next_state = Write;
            Write:
                if (DrawX == 10'd640)
                    Next_state = WriteToRead;
            WriteToRead:
                Next_state = Read;
        endcase

        case (State)
            Read:
            begin
                SRAM_OE_N = 1'b0; //enables reading from the frameBuffer
                PauseVGA = 1'b1; //pauses the VGA
                fifo_we = 1'b1; //enables writing into the fifo

                if (clkRead == 3) //clkRead is used to allow 3 clock cycles for reading from an address
                begin
                    clkRead_in = 0;
                    ReadX_in = ReadX + 1;
                end
                else
                    clkRead_in = clkRead + 1;
            end

            ReadToWrite:
            begin
                ReadX_in = 10'b 0; //sets up readX and Ready for next iteration
                ReadY_in = ReadY + 10'b1;

                if (ReadY + 10'b1 >480)
                    ReadY_in = 10'b0;

                SRAM_OE_N = 1'b1; //writing into frame buffer
                fifo_we = 1'b0; //reading from fifo
            end

            Write:
            begin
                PauseVGA = 1'b0; //starts VGA running again
                fifo_we = 1'b0; //reading from fifo
                SRAM_OE_N = 1'b1; //writing into frame buffer

                if (SaveX == 10'd639 & SaveY == 10'd479)//stuck hear until a blank interval comes up
                begin
                    if (VGA_BLANK_N == 1'b0)//if it is a blank period that means we flip the page and reset the pointers.
                    begin
                        flip_page_in = ~flip_page;
                        SaveX_in = 10'b0;
                        SaveY_in = 10'b0;
                    end
                end
                else
                begin
                    SaveX_in = SaveX + 10'b1; //keep increasing x
                    if (SaveX + 10'b1 == 10'd640) //when we reach the end of the line, go to the next line
                    begin
                        SaveX_in = 10'b0;
                        SaveY_in = SaveY_in +10'b1;
                    end
                end
            end

            WriteToRead:
            begin
                SRAM_OE_N = 1'b0; //enables reading from the frameBuffer
                PauseVGA = 1'b1; //pauses the VGA
                fifo_we = 1'b1; //enables writing into the fifo
            end
        endcase
    end
endmodule
