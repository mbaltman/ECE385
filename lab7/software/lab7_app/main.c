int main()
{
	volatile unsigned int *LED_PIO = (unsigned int*)0x40; // pointer to the LEDs block
	volatile unsigned int *SWITCHES_PIO = (unsigned int*)0x30; // pointer to the switches block
	volatile unsigned int *BUTTONS = (unsigned int*)0x50; // pointer to the push buttons block

	unsigned int sum = 0x00; // initialize summation variable
	*LED_PIO = 0; // clear all LEDs

	while(1) // infinite loop
	{
		if(*BUTTONS  == 0x2) {*LED_PIO = 0;} // check if reset is pressed
		if(*BUTTONS == 0x1) // check if accumulate is pressed
		{
			sum = *LED_PIO + *SWITCHES_PIO;
			if(sum > 0xFF ) {sum = sum - 0x100;} // check and modify for over flow
			*LED_PIO = sum; // display result to LEDs
			while(*BUTTONS == 0x1) {} // do not exit until push button is back to unpressed
		}

	}

	/*
	int i = 0; // initialize variable for loops
	while (1) // infinite loop
	{
		for (i = 0; i < 100000; i++); // software delay
		*LED_PIO |= 0x1; // set LSB
		for (i = 0; i < 100000; i++); // software delay
		*LED_PIO &= ~0x1; // clear LSB
	}
	*/

	return 1; // never gets here
}
