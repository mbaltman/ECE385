/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000040;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
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

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
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

void addRoundKey(int currRound, char * key_schedule, char * state)
{
    for (int i = 0; i < 16; i++)
    {
        state[i] = state[i] ^ key_schedule[currRound*16 + i];
    }
}
/*
keyE
*/
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
    char temp1;//stores one column at a time
    char temp2;
    char temp3;
    char temp4;
    //store first key

    //sets up columns 0-3
    for(int i = 0; i < 16; i++)
    {
        key_schedule[i] = key[i];
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

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{

    char msg_hex[16] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    char key_hex[16] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    //convert msg_ascii characs to hex values
    for(int i = 0; i < 16; i++)
    {   //gets bits 2 at a time
        char currM = charsToHex((char)msg_ascii[2*i], (char)msg_ascii[2*i + 1]);
        char currK = charsToHex((char)key_ascii[2*i], (char)key_ascii[2*i + 1]);

        msg_hex[i] = currM;
        key_hex[i] = currK;
    }

    char key_schedule[16*11];
	for(int k = 0; k < 176; k++)
	{
		key_schedule[k] = 0x00;
	}

    keyExpansion(key_hex, key_schedule);

    addRoundKey(0, key_schedule, msg_hex);
    for(int round = 1; round < 10; round++)
    {
        subBytes(msg_hex);
        ShiftRows(msg_hex);
        MixColumns(msg_hex);
        addRoundKey(round, key_schedule, msg_hex);

    }
    subBytes(msg_hex);
    ShiftRows(msg_hex);
    addRoundKey(10, key_schedule, msg_hex);

    for (int i = 0; i < 4; i++)
    {
        int temp1 = msg_hex[i*4 + 0] & 255;
        int temp2 = msg_hex[i*4 + 1] & 255;
        int temp3 = msg_hex[i*4 + 2] & 255;
        int temp4 = msg_hex[i*4 + 3] & 255;
        msg_enc[i] = (msg_enc[i] ^ temp1) << 8;
        msg_enc[i] = (msg_enc[i] ^ temp2) << 8;
        msg_enc[i] = (msg_enc[i] ^ temp3) << 8;
        msg_enc[i] = msg_enc[i] ^ temp4;
    }

     for (int i = 0; i < 4; i++)
    {
        int temp1 = key_hex[i*4 + 0] & 255;
        int temp2 = key_hex[i*4 + 1] & 255;
        int temp3 = key_hex[i*4 + 2] & 255;
        int temp4 = key_hex[i*4 + 3] & 255;
        key[i] = (key[i] ^ temp1) << 8;
        key[i] = (key[i] ^ temp2) << 8;
        key[i] = (key[i] ^ temp3) << 8;
        key[i] = key[i] ^ temp4;
    }


}
/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// clear registers
	AES_PTR[0]  = 0;
	AES_PTR[1]  = 0;
	AES_PTR[2]  = 0;
	AES_PTR[3]  = 0;
	AES_PTR[4]  = 0;
	AES_PTR[5]  = 0;
	AES_PTR[6]  = 0;
	AES_PTR[7]  = 0;
	AES_PTR[8]  = 0;
	AES_PTR[9]  = 0;
	AES_PTR[10] = 0;
	AES_PTR[11] = 0;
	AES_PTR[14] = 0;
	AES_PTR[15] = 0;

	// send the 128-bit key (split into 4 x 32-bit)
	AES_PTR[0] = key[0];
	AES_PTR[1] = key[1];
	AES_PTR[2] = key[2];
	AES_PTR[3] = key[3];
	// send the 128-bit encrypted message (split into 4 x 32-bit)
	AES_PTR[4] = msg_enc[0];
	AES_PTR[5] = msg_enc[1];
	AES_PTR[6] = msg_enc[2];
	AES_PTR[7] = msg_enc[3];

	// START
	AES_PTR[14] = 1;
	while(AES_PTR[15] == 0){} // waiting for hardware
	// DONE
	msg_dec[0] = AES_PTR[8];
	msg_dec[1] = AES_PTR[9];
	msg_dec[2] = AES_PTR[10];
	msg_dec[3] = AES_PTR[11];
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// input message and key as 32 x 8-bit ASCII characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// key, encrypted message, and decrypted message in 4 x 32-bit format to facilitate read/write to hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];
	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);
	if (run_mode == 0) {
		// continuously perform encryption and decryption
		while (1) {
			// initialization
			for (int k = 0; k < 33; k++)
			{
				msg_ascii[k] = 0x00;
				key_ascii[k] = 0x00;
			}
			for (int k = 0; k < 4; k++)
			{
				key[k] = 0;
				msg_enc[k] = 0;
				msg_dec[k] = 0;
			}

			int i = 0;
			printf("\nEnter message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
