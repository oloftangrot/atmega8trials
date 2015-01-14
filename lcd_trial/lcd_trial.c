#include <avr/io.h>
#include "lcd.h"
#include "led_indicator.h"

//############################################################################
//Main program
//############################################################################
int main (void)
{
	char key;
	
	LCD_Init();
	
	led_init();
	
	LCD_Clear;
	LCD_Write( "Hello World! 2");
	while (1)
	{
		led_schedule();
	}
	return (1);
}
