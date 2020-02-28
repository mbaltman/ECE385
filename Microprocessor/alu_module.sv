module alu_module(
    input  logic [15:0] A, B,
    input  logic [1:0]  s,
    output logic [15:0] out);
    always_comb
    begin
        if (s == 2'b00)
            out = A + B;
        else if (s == 2'b01)
            out = A & B;
        else if (s == 2'b10)
            out = ~A;
        else if (s == 2'b11)
            out = A;
    end
endmodule
