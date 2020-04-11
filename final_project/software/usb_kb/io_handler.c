//io_handler.c
#include "io_handler.h"
#include <stdio.h>
#include "system.h"

void IO_init(void)
{
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
	// Reset OTG chip
	*otg_hpi_cs = 0;
	*otg_hpi_reset = 0;
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
}

void IO_write(alt_u8 Address, alt_u16 Data)
{
	*otg_hpi_cs = 0; // select chip
	*otg_hpi_r = 1; // disenable read
	*otg_hpi_address = Address; // prepare the address to write
	*otg_hpi_w = 0; // enable write
	*otg_hpi_data = Data; // prepare the data to write
	*otg_hpi_w = 1; // disable write
	*otg_hpi_cs = 1; // deselect chip
	return;
}

alt_u16 IO_read(alt_u8 Address)
{
	alt_u16 temp; // temporary variable to store the data read
	*otg_hpi_cs = 0; // select chip
	*otg_hpi_w = 1; // disenable write
	*otg_hpi_r = 0; // enable read
	*otg_hpi_address = Address; // prepare the address to read
	temp = *otg_hpi_data; // put the read data into the temporary variable
	*otg_hpi_r = 1; // disable read
	*otg_hpi_cs = 1; // deselect chip
	return temp; // return the data read using the temporary variable
}
