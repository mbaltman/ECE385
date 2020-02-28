module sr2mux_module(
    input  logic [15:0] SR2,
    input  logic [4:0]  IM5,
    input  logic SR2MUX,
    output logic [15:0] out);
    always_comb
    begin
        if (SR2MUX)
            out = { 11{IM5[4]}, IM5 };
        else
            out = SR2;
    end
endmodule
