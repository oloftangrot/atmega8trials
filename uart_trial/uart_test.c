/*
  Olof Tångrot <olof.tangrot@gmail.com>
  
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
#include <avr/io.h>
#include <avr/pgmspace.h>
#include "types.h"
#include "uart.h"

char f1= 0;

int main(void) 
{
 
//------------------------------
// Initialize 
//------------------------------

//////////////////////////////////////////////////////////////////
// B - Port
//////////////////////////////////////////////////////////////////

  DDRB |= 1 << PB2;        /* P2 on port B output */
  PORTB &= ~(1 << PB2);        /* Clear PB2 as inital value */

//	outp(0xbe, DDRB);	// all output except PB0 and PB6
//	outp(0xff, PORTB);	// all high, and pullup on PB0 and PB6

	UART_Init();		// init RS-232 link

  int i = 0;
  int j = 0;
  char f = 0;
 //----------------------------------------------------------------------------
 // setup some pointers
 //----------------------------------------------------------------------------

	// say hello
	UDR = 'A';
	EOL();
	PRINT("uart_test  ");
	UART_Puts( (unsigned char*) __DATE__);
	PRINT(" ");
	UART_Putsln( (unsigned char*) __TIME__);
	EOL();
	PRINT("Press a key to test recive loop back.\r\n");

 //----------------------------------------------------------------------------
 // Run tests
 //----------------------------------------------------------------------------                        

	while (1)
	{
	  if ( UART_HasChar() )
	  {
		 	 
 		   UDR = UART_ReceiveByte();
	  } 
    if ( i == 0 )
    {
      j++;
      if ( !(j%10) )
      {
        if ( f ) // Toggle hart beat LED.
        { 
           f = 0;
//           PORTB &= ~(1 << PB2); 
           UDR = 'A';
        }
        else
        {
           f = 1;
//           PORTB |= 1 << PB2;
           UDR = 'Z';
        }
      }
    }
    i++;
	}
	return 0;
}
