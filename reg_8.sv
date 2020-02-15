module reg_8 (input  logic clk, reset, shift_in, load, shift_en,
              input  logic [7:0] din,
              output logic shift_out,
              output logic [7:0] dout);

    always_ff @ (posedge clk)
    begin
        if (reset)
            dout <= 8'h0;
        else if (load)
            dout <= din;
        else if (shift_en)
        begin
            dout <= { shift_in, dout[7:1] };
        end
    end

    assign shift_out = dout[0];

endmodule
