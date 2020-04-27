module rotation
(
    input  logic [15:0] oldstate,
    output logic [15:0] ccwstate, cwstate
);

    always_comb
    begin
        ccwstate[0]  = oldstate[3];
        ccwstate[1]  = oldstate[7];
        ccwstate[2]  = oldstate[11];
        ccwstate[3]  = oldstate[15];
        ccwstate[4]  = oldstate[2];
        ccwstate[5]  = oldstate[6];
        ccwstate[6]  = oldstate[10];
        ccwstate[7]  = oldstate[14];
        ccwstate[8]  = oldstate[1];
        ccwstate[9]  = oldstate[5];
        ccwstate[10] = oldstate[9];
        ccwstate[11] = oldstate[13];
        ccwstate[12] = oldstate[0];
        ccwstate[13] = oldstate[4];
        ccwstate[14] = oldstate[8];
        ccwstate[15] = oldstate[12];
        cwstate[0]   = oldstate[12];
        cwstate[1]   = oldstate[8];
        cwstate[2]   = oldstate[4];
        cwstate[3]   = oldstate[0];
        cwstate[4]   = oldstate[13];
        cwstate[5]   = oldstate[9];
        cwstate[6]   = oldstate[5];
        cwstate[7]   = oldstate[1];
        cwstate[8]   = oldstate[14];
        cwstate[9]   = oldstate[10];
        cwstate[10]  = oldstate[6];
        cwstate[11]  = oldstate[2];
        cwstate[12]  = oldstate[15];
        cwstate[13]  = oldstate[11];
        cwstate[14]  = oldstate[7];
        cwstate[15]  = oldstate[3];
    end
endmodule
