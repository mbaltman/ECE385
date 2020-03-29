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
        char a0 = currstate[i*4 + 0];
        char a1 = currstate[i*4 + 1];
        char a2 = currstate[i*4 + 2];
        char a3 = currstate[i*4 + 3];

        char b0 = xtime(a0) ^ (xtime(a1)^a1) ^ (a2) ^ (a3);
        char b1 = (a0) ^ (xtime(a1)) ^ (xtime(a2)^a2) ^ (a3);
        char b2 = (a0) ^ (a1) ^ (xtime(a2)) ^ (xtime(a3)^a3);
        char b3 = (xtime(a0)^a0) ^ (a1) ^ (a2) ^ (xtime(a3));

        currstate[i*4 + 0] = b0;
        currstate[i*4 + 1] = b1;
        currstate[i*4 + 2] = b2;
        currstate[i*4 + 3] = b3;
    }
    return;
}

int main()
{
    printf("\n");
    char input [16] = {
        0xce, 0x94, 0x4f, 0x66,
        0x9b, 0xe9, 0x90, 0x9e,
        0x69, 0xdf, 0xb8, 0xb9,
        0xe1, 0x11, 0x0b, 0x0e
        };

    MixColumns(input);
    for (int i = 0; i < 16; i++)
    {
        printf("%02x ", input[i] & 0xff);
        if (i % 4 == 3) printf("\n");
    }
    printf("\n");
    return 0;
}
