//
//  trial1.c - some kind of LED blink.
//
#include <avr/io.h>

int main( void )
{
    int i = 0;
    int j = 0;
    int f = 0;
    DDRB |= 1 << PB2;        /* P0 on port A output */
    PORTB &= ~(1 << PB2);        /* Clear PA0 as inital value */
    for (;;)
    {
       if ( i == 0 )
       {
          j++;
          if ( !(j%10) )
          {
             
             if ( f )
             { 
                f = 0;
                PORTB &= ~(1 << PB2);
             }
             else
             {
               f = 1;
               PORTB |= 1 << PB2;
             }
          }
       }
       i++;
    }
    return 0;         
}
