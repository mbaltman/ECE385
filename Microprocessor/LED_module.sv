module LED_module(input logic LD_LED, clk, input logic [11:0] IR11, output logic[11:0] LED);

always_ff @ (posedge clk)
		begin
		if(LD_LED)
			LED=IR11;
		end
endmodule
