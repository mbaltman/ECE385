void ShiftRows(char * currstate)
{
    char a0 = currstate[0];
    char a1 = currstate[1];
    char a2 = currstate[2];
    char a3 = currstate[3];

    char a4 = currstate[5];
    char a5 = currstate[6];
    char a6 = currstate[7];
    char a7 = currstate[4];

    char a8 = currstate[10];
    char a9 = currstate[11];
    char a10 = currstate[8];
    char a11 = currstate[9];

    char a12 = currstate[15];
    char a13 = currstate[12];
    char a14 = currstate[13];
    char a15 = currstate[14];

    currstate[0] = a0;
    currstate[1] = a1;
    currstate[2] = a2;
    currstate[3] = a3;
    currstate[4] = a4;
    currstate[5] = a5;
    currstate[6] = a6;
    currstate[7] = a7;
    currstate[8] = a8;
    currstate[9] = a9;
    currstate[10] = a10;
    currstate[11] = a11;
    currstate[12] = a12;
    currstate[13] = a13;
    currstate[14] = a14;
    currstate[15] = a15;
    return;
}
