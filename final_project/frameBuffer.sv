
module frameBuffer( input SRAM_OE_N, //signals if reading or writing
						  input [3:0]colorIndex_save , //data being written in 
						  input [9:0] SaveX, SaveY, //determines address being written into 
						  
						  input [9:0] DrawX, DrawY, //determines the address that the VGA wants to read out
						  output [3:0] data_out , //data being read out
						  output [9:0]fifo_address, //address in the fifo being written into
						  output fifo_we, //enable writing into the fifo
						  
						  output [19:0] SRAM_ADDR,
						  inout [15:0] SRAM_DQ,
						  
						  input logic flip_page
						  );
					
parameter offset = 20'd307200; //number of addresses for first fram buffer, can be used for page flipping		
 always_comb
    begin
		if(SRAM_OE_N)//if its a 1 write memory frame buffer
			begin
				SRAM_ADDR = ({10'b0, SaveY} * 640) + {10'b0,SaveX}; //address that should be written into, extended to 20 bits, to gauruntee it wouldnt be truncated.
				SRAM_DQ = {12'b0, colorIndex_save[3:0]};
				if(flip_page)
					SRAM_ADDR = SRAM_ADDR+offset;
					
				fifo_we =1'b0;//fifo can be read from
			end
		else //if its a 0 read memory from frame buffer and write into fifos
			begin 
				SRAM_ADDR = ({10'b0, DrawY} * 640) + {10'b0,DrawX}; //address that should be written into, extended to 20 bits, to gauruntee it wouldnt be truncated.
				if(!flip_page)
					SRAM_ADDR = SRAM_ADDR+offset;
				data_out = SRAM_DQ[3:0];
				fifo_address = DrawX;
				fifo_we = 1'b1;//fifo is being written to
			end 
		end
endmodule
