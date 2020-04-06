module addroundkey (
    input  logic   [1407:0] KeySchedule,
    input  logic   [127:0] currState,
    input  integer roundnumber,
    output logic   [127:0] newState);

    logic [127:0] ck, k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, roundkey;

    always_comb
    begin
        ck = KeySchedule[1407:1280];
        k0 = KeySchedule[1279:1152];
        k1 = KeySchedule[1151:1024];
        k2 = KeySchedule[1023:896];
        k3 = KeySchedule[895:768];
        k4 = KeySchedule[767:640];
        k5 = KeySchedule[639:512];
        k6 = KeySchedule[511:384];
        k7 = KeySchedule[383:256];
        k8 = KeySchedule[255:128];
        k9 = KeySchedule[127:0];
        newState = currState^roundkey;
    end

    mux11 roundkeymux(.ck, .k0, .k1, .k2, .k3, .k4, .k5, .k6, .k7, .k8, .k9, .s(roundnumber), .o(roundkey));
endmodule

module mux11 (
    input  logic   [127:0] ck, k0, k1, k2, k3, k4, k5, k6, k7, k8, k9,
    input  integer s,
    output logic   [127:0] o);

    always_comb
    begin
        unique case (s)
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
