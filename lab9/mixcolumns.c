char xtime(char a)
{
    char a_out;
    char comp_1b = charsToHex('1', 'b'); // define {1b} character in HEX
    if (a < 0) a_out = (a << 1) ^ comp_1b; // left shift by 1 bit and XOR {1b}
    else a_out = a << 1; // left shift only
    return a_out;
}

void MixColumns(char * currstate)
{
    for(int i = 0; i < 4; i++) // column number 0~3
    {
        char a0 = currstate[0 + i];
        char a1 = currstate[4 + i];
        char a2 = currstate[8 + i];
        char a3 = currstate[12 + i];

        char b0 = xtime(a0) ^ (xtime(a1)^a1) ^ (a2) ^ (a3);
        char b1 = (a0) ^ (xtime(a1)) ^ (xtime(a2)^a2) ^ (a3);
        char b2 = (a0) ^ (a1) ^ (xtime(a2)) ^ (xtime(a3)^a3);
        char b3 = (xtime(a0)^a0) ^ (a1) ^ (a2) ^ (xtime(a3));

        currstate[0 + i] = b0;
        currstate[4 + i] = b1;
        currstate[8 + i] = b2;
        currstate[12 + i] = b3;
    }
    return;
}
