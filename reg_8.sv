module reg_8 (input  logic clk, reset, shift_in, load, shift_en,
              input  logic [7:0]  din,
              output logic shift_out,
              output logic [7:0]  dout);

    always_ff @ (posedge Clk)
    begin
	 	 if (reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  dout <= 8'h0;
		 else if (load)
			  Data_Out <= D;
		 else if (shift_en)
		 begin
			  //concatenate shifted in data to the previous left-most 3 bits
			  //note this works because we are in always_ff procedure block
			  dout <= { shift_in, dout[7:1] }; 
	    end
    end
	
    assign shift_out = dout[0];

endmodule
