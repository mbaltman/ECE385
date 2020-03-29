#include <stdlib.h>
#include <stdio.h>

char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

void ShiftRows(char * currstate)
{
    char a0 = currstate[0];
    char a1 = currstate[5];
    char a2 = currstate[10];
    char a3 = currstate[15];

    char a4 = currstate[4];
    char a5 = currstate[9];
    char a6 = currstate[14];
    char a7 = currstate[3];

    char a8 = currstate[8];
    char a9 = currstate[13];
    char a10 = currstate[2];
    char a11 = currstate[7];

    char a12 = currstate[12];
    char a13 = currstate[1];
    char a14 = currstate[6];
    char a15 = currstate[11];

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

int main()
{
    printf("\n");
    char input [16] = {
        0xce, 0x11, 0xb8, 0x9e,
        0x9b, 0x94, 0x0b, 0xb9,
        0x69, 0xe9, 0x4f, 0x0e,
        0xe1, 0xdf, 0x90, 0x66
        };

    ShiftRows(input);
	for (int i = 0; i < 16; i++)
    {
        printf("%02x ", input[i] & 0xff);
        if (i % 4 == 3) printf("\n");
    }
    printf("\n");
    return 0;
}
