#include <stdlib.h>
#include <stdio.h>
#include <time.h>
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
    char returnVal[16];
    for(int i = 0; i<16; i++ )
    {
        returnVal[i]= state[i] ^ key_schedule[currRound*16 + i];
    }
}

char subWord(char currChar)
{
	printf("Start Subword");
    int firstNumber;
    int secondNumber;

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
	printf("end Subword");

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
	printf("start Keyexpansion");
    char lastXbits;
    unsigned  mask;
    mask = (1 << 8) - 1;



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

    while(i< (44))
    {
       //look at the previous column
         temp1 = key_schedule[0+(i-1)*4];
         temp2 = key_schedule[1+(i-1)*4];
         temp3 = key_schedule[2+(i-1)*4];
         temp4 = key_schedule[3+(i-1)*4];

         if(i % 4 == 0)
         {
             unsigned int curr = Rcon[i/4];
             curr = curr<<24;
             lastXbits =  curr & mask;
             temp1 = subWord(temp2) ^ lastXbits;
             temp2 = subWord(temp3);
             temp3 = subWord(temp4);
             temp4 = subWord(temp1);

         }
        key_schedule[0+(i*4)]= key_schedule[0 + (i-4)*4] ^ temp1;
        key_schedule[1+(i*4)]= key_schedule[1 + (i-4)*4] ^ temp2;
        key_schedule[2+(i*4)]= key_schedule[2 + (i-4)*4] ^ temp3;
        key_schedule[3+(i*4)]= key_schedule[3 + (i-4)*4] ^ temp4;
		i++;
    }
	printf("end Keyexpansion");

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

    char *key_schedule;
	key_schedule = (char*) malloc(176* sizeof(char));
	printf("call Keyexpansion");
	keyExpansion(key_hex, key_schedule);
	for(int j = 0; j < 11; j++)
	{
    	for (int i = 0; i < 16; i++)
    	{
        	printf("%02x ", key_schedule[j*16 + i] & 0xff);
        	if (i % 4 == 3) printf("\n");
    	}
		printf("\n");
	}
    printf("\n");

	free(key_schedule);

    return 0;
}
