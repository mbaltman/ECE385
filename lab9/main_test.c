#include <stdlib.h>
#include <stdio.h>
#include "aes.h"

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

void addRoundKey(int currRound, char * key_schedule, char * state)
{
    for (int i = 0; i < 16; i++)
    {
        state[i] = state[i] ^ key_schedule[currRound*16 + i];
    }
}

char subWord(char currChar)
{
    int firstNumber = 0;
    int secondNumber = 0;

    if((currChar >> 7) & 1==1)
    {
        firstNumber = firstNumber+8;
    }
    if((currChar >> 6) & 1==1)
    {
        firstNumber = firstNumber+4;
    }
    if((currChar >> 5) & 1==1)
    {
        firstNumber = firstNumber+2;
    }
    if((currChar >> 4) & 1==1)
    {
        firstNumber = firstNumber+1;
    }

    if((currChar >> 3) & 1==1)
    {
        secondNumber = secondNumber+8;
    }
    if((currChar >> 2) & 1==1)
    {
        secondNumber = secondNumber+4;
    }
    if((currChar >> 1) & 1==1)
    {
        secondNumber = secondNumber+2;
    }
    if((currChar >> 0) & 1==1)
    {
        secondNumber = secondNumber+1;
    }
    char curr = aes_sbox[16*firstNumber + secondNumber];
    return curr;
}

void subBytes(char * state)
{
    for(int i = 0; i<16; i++)
    {
        state[i] = subWord(state[i]);
    }
}

void keyExpansion(char * key, char * key_schedule)
{
    char myRcon [] = {0x00,0x01,0x02,0x04,0x08,0x10,
        0x20,0x40,0x80,0x1b,0x36,0x6c,
        0xd8,0xab,0x4d,0x9a};
    char temp1;//stores one column at a time
    char temp2;
    char temp3;
    char temp4;
    //store first key

    //sets up columns 0-3
    for(int i =0; i < 16; i++)
    {
        key_schedule[i]= key[i];
    }


    int i = 4;

    while(i < 44)
    {
    //look at the previous column
        temp1 = key_schedule[0+(i-1)*4];
        temp2 = key_schedule[1+(i-1)*4];
        temp3 = key_schedule[2+(i-1)*4];
        temp4 = key_schedule[3+(i-1)*4];
        if(i % 4 == 0)
        {
            char temptemp = temp1;
            temp1 = subWord(temp2) ^ myRcon[i/4];
            temp2 = subWord(temp3);
            temp3 = subWord(temp4);
            temp4 = subWord(temptemp);
        }
        key_schedule[0+(i*4)]= key_schedule[0 + (i-4)*4] ^ temp1;
        key_schedule[1+(i*4)]= key_schedule[1 + (i-4)*4] ^ temp2;
        key_schedule[2+(i*4)]= key_schedule[2 + (i-4)*4] ^ temp3;
        key_schedule[3+(i*4)]= key_schedule[3 + (i-4)*4] ^ temp4;
        i++;
    }
}

int main()
{
    printf("\n");
    char key_hex [16] = {
        0x00, 0x01, 0x02, 0x03,
        0x04, 0x05, 0x06, 0x07,
        0x08, 0x09, 0x0A, 0x0B,
        0x0C, 0x0D, 0x0E, 0x0F
        };

    char * key_schedule;
    key_schedule = (char*) malloc (176 * sizeof(char));
    printf("Calling keyexpansion: ......");
    keyExpansion(key_hex, key_schedule);
    printf("\n\n");
    fflush(stdout);
    for(int j = 0; j < 11; j++)
    {
        for (int i = 0; i < 16; i++)
        {
            printf("%02x ", key_schedule[j*16 + i] & 0xff);
            if (i % 4 == 3) printf("\n");
        }
        printf("\n");
    }
    //free(key_schedule);
    printf("******\n\n");

    char msg_hex [16] = {
        0x09, 0x4a, 0x6e, 0x5e,
        0x03, 0x67, 0xf0, 0xe8,
        0xa9, 0xa6, 0x0d, 0xb5,
        0xef, 0xd0, 0xf4, 0x3e
        };

    addRoundKey(1, key_schedule, msg_hex);
    for (int i = 0; i < 16; i++)
    {
        printf("%02x ", msg_hex[i] & 0xff);
        if (i % 4 == 3) printf("\n");
    }
    printf("\n");
    return 0;
}
