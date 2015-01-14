/*
  Copy right (C) Olof Tångrot <olof.tangrot@gmail.com>
  
  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either version 2
  of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software Foundation, 
  Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/
#include "global.h"
#include "a2d.h"
#include "uart.h"
#include <stdlib.h>
#include <util/delay.h>

char f1= 0;
char buf[8];

const int adc_offset = 0x200;

int main ( void )
{
	int16_t res0, res1, res2;
	a2dInit();
	UART_Init();		// init RS-232 link

	EOL();
	PRINT("a2d trial ");
	UART_Puts( __DATE__ );
	PRINT(" ");
	UART_Putsln( __TIME__ );
	EOL();
	PRINT("Press a key to test recive loop back.\r\n");


	for(;;) {
		res0 = a2dConvert10bit( ADC_CH_ADC0 ) - adc_offset; // Read and substract offset
		res1 = a2dConvert10bit( ADC_CH_ADC1 ) - adc_offset;
		res2 = a2dConvert10bit( ADC_CH_ADC2 ) - adc_offset;
		
		itoa( res0, buf, 10);
		UART_Puts( buf );
//		UART_Printfu16( res0 );
		PRINT(" ");
		itoa( res1, buf, 10);
		UART_Puts( buf );
//		UART_Printfu16( res1 );
		PRINT(" ");
		itoa( res2, buf, 10);
		UART_Puts( buf );
//		UART_Printfu16( res2 );
		EOL();
		_delay_ms( 500 );
	}
	return 0;
}
