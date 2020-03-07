// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x40; //make a pointer to access the PIO block
	volatile unsigned int *SWITCHES_PIO = (unsigned int*)0x30;
	volatile unsigned int *BUTTONS = (unsigned int*)0x50;

	unsigned int sum = 0x00;
	*LED_PIO = 0; //clear all LEDs

	while(1)
	{

		if(*BUTTONS  == 0x2)
		{
			*LED_PIO = 0;
		}
		if(*BUTTONS == 0x1)
		{
			sum = *LED_PIO + *SWITCHES_PIO;
			if(sum > 0xFF )
			{
				sum = sum - 0x100;
			}
			*LED_PIO = sum;

			while(*BUTTONS == 0x1)
			{

			}

		}

	}
	/*
	while ( (1+1) != 3) //infinite loop
	{
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
	}
	*/
	return 1; //never gets here
}
