module addroundkey (
    input logic [1407:0] KeySchedule,
    input integer roundnumber,
    output logic [127:0] roundkey);

    logic [127:0] ck, k0, k1, k2, k3, k4, k5, k6, k7, k8, k9;

    always_comb
    begin
        ck = KeySchedule[1407:1279];
        k0 = KeySchedule[1279:1151];
        k1 = KeySchedule[1151:1023];
        k2 = KeySchedule[1023:895];
        k3 = KeySchedule[895:767];
        k4 = KeySchedule[767:639];
        k5 = KeySchedule[639:511];
        k6 = KeySchedule[511:383];
        k7 = KeySchedule[383:255];
        k8 = KeySchedule[255:127];
        k9 = KeySchedule[127:0];
    end

    mux11 roundkeymux (.ck, .k0, .k1, .k2, .k3, .k4, .k5, .k6, .k7, .k8, .k9, .s(roundnumber), .o(roundkey));
endmodule

module mux11 #(parameter width = 128) (
    input  logic [width-1:0] ck, k0, k1, k2, k3, k4, k5, k6, k7, k8, k9,
    input  integer s,
    output logic [width-1:0] o);

    always_comb
    begin
        unique case(s)
            0:
                o = ck;
            1:
                o = k0;
            2:
                o = k1;
            3:
                o = k2;
            4:
                o = k3;
            5:
                o = k4;
            6:
                o = k5;
            7:
                o = k6;
            8:
                o = k7;
            9:
                o = k8;
            10:
                o = k9;
        endcase
    end
endmodule
