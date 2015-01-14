#include <avr/io.h>
#include "led_indicator.h"

/*
** 
*/
void led_init( void )
{
	DDRB |= 1 << PB2;        /* P2 on port A output */
	PORTB &= ~(1 << PB2);        /* Clear PB2 as inital value */
}
/*
**
*/
void led_schedule( void )
{
	static int i = 0;
	static int j = 0;
	static char f = 0;

	if ( i == 0 ) {
		j++;
		if ( !(j%10) ) {
			if ( f ) { 
				f = 0;
				PORTB &= ~(1 << PB2);
			}
			else {
				f = 1;
				PORTB |= 1 << PB2;
			}
		}
	}
	i++;
}