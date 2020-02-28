module alu_module(
    input  logic [15:0] A, B, // B comes from the output of sr2mux_module
    input  logic [1:0]  s,
    output logic [15:0] out);

    always_comb
	begin
    unique case(s)
        2'b00:
            out = A + B;
        2'b01:
            out = A & B;
        2'b10:
            out = ~A;
        2'b11:
            out = A;
	 endcase
    end
endmodule
