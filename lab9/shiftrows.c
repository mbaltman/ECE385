void ShiftRows(char * currstate)
{
    char newstate[16];
    newstate[0] = currstate[0];
    newstate[1] = currstate[1];
    newstate[2] = currstate[2];
    newstate[3] = currstate[3];

    newstate[4] = currstate[5];
    newstate[5] = currstate[6];
    newstate[6] = currstate[7];
    newstate[7] = currstate[4];

    newstate[8] = currstate[10];
    newstate[9] = currstate[11];
    newstate[10] = currstate[8];
    newstate[11] = currstate[9];

    newstate[12] = currstate[15];
    newstate[13] = currstate[12];
    newstate[14] = currstate[13];
    newstate[15] = currstate[14];
    
    
    currstate = newstate;
}
