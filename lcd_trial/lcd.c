/************************************************************
**  LCD-driver for a HD44780 compatible display on
**  the mega8 card.
**
**  The driver code uses 4-bit mode and allows the data bits and 
**  the control bits to be on two different IO-ports.
** 
**  The driver code are designed so that only bit ports used by
**  the LCD are affected. (4 data & 3 control)
**
**  The implementation uses delays to await the LCD-device
**  response.
** 
************************************************************/
#include <util/delay.h>
#include <avr/io.h>

#define LCD_DATA							PORTC
#define LCD_DATA_DDR					DDRC
#define LCD_DATA_OUT_BITMASK	0x0f; // Lower nibble

#define LCD_CTRL							PORTD
#define LCD_CTRL_DDR					DDRD
#define DISPLAY_RS  	(1<<5)  // Out
#define DISPLAY_RW		(1<<6)  // Out (Not used in code but required to be defined as output)
#define DISPLAY_EN  	(1<<7)  // Out
#define LCD_CTRL_OUT_BITMASK	(DISPLAY_RS | DISPLAY_RW | DISPLAY_EN)

#define LONG_DELAY (10)			// [ms]
#define SHORT_DELAY (1)			// [ms]

void long_delay(void)
{
	_delay_ms(LONG_DELAY);
}

static void short_delay(void)
{
	_delay_ms(SHORT_DELAY);
}


void _lcd_write_command(unsigned char data)
{
	LCD_DATA &= ~LCD_DATA_OUT_BITMASK; // Clear data bits before setting any of them.
	LCD_DATA |= (data >> 4 ) & 0x0f;
	LCD_CTRL |= DISPLAY_EN;
	LCD_CTRL &= ~DISPLAY_EN;
	LCD_DATA &= ~LCD_DATA_OUT_BITMASK; // Clear data bits before setting any of them.
	LCD_DATA |= data & 0x0f;
	LCD_CTRL |= DISPLAY_EN;
	LCD_CTRL &= ~DISPLAY_EN;
}

void _lcd_write_4bit(unsigned char data)
{
	LCD_DATA &= ~LCD_DATA_OUT_BITMASK; // Clear data bits before setting any of them.
	LCD_DATA |= data & 0x0f;
	LCD_CTRL |= DISPLAY_EN;
	LCD_CTRL &= ~DISPLAY_EN;
}

void lcd_write_byte(unsigned char data)
{
	LCD_DATA &= ~LCD_DATA_OUT_BITMASK; // Clear data bits before setting any of them.
	LCD_DATA |= (data >> 4 ) & 0x0f;
	LCD_CTRL |= ( DISPLAY_EN | DISPLAY_RS);
	LCD_CTRL &= ~DISPLAY_EN;
	LCD_DATA &= ~LCD_DATA_OUT_BITMASK; // Clear data bits before setting any of them.
	LCD_DATA |= data & 0x0f;
	LCD_CTRL |= DISPLAY_EN;
	LCD_CTRL &= ~( DISPLAY_EN | DISPLAY_RS);
}


int my_pput(int zeichen)
{
	lcd_write_byte((char) zeichen);
	return(1);
}

// initialize the LCD controller
void LCD_Init(void)
{
	LCD_DATA_DDR |=	LCD_DATA_OUT_BITMASK;
	LCD_CTRL_DDR |= LCD_CTRL_OUT_BITMASK;
	LCD_CTRL &= ~( DISPLAY_EN | DISPLAY_RW | DISPLAY_RS); // Define state of control signals.

	long_delay();
	long_delay();
	long_delay();
	_lcd_write_4bit(0x03);	   // noch 8 Bit
	long_delay();
	_lcd_write_4bit(0x03);	   // noch 8 Bit
	long_delay();
	_lcd_write_4bit(0x03);	   // noch 8 Bit
	long_delay();
	_lcd_write_4bit(0x02);	   // jetzt 4 Bit
	long_delay();
	_lcd_write_command(0x28);     // 4 Bit Zweizeilig
	long_delay();
	_lcd_write_command(0x08);     // Display aus
	long_delay();
	_lcd_write_command(0x01);     // Clear
	long_delay();
	_lcd_write_command(0x06);     //Entry mode
	long_delay();
	_lcd_write_command(0x08 + 4); // Display an
	long_delay();
}


void LCD_Gotoxy(unsigned char x , unsigned char y)
{
  short_delay();
  switch(y)
  {
		case 0 : _lcd_write_command(x + 0x80); break;
    case 1 : _lcd_write_command(x + 0xC0); break;
    case 2 : _lcd_write_command(x + (0x80 + 20)); break;
    case 3 : _lcd_write_command(x + (0xC0 + 20)); break;
  }
}


void LCD_Write(unsigned char *this_text)
{
	unsigned char i = 0;
	while(this_text[i] != 0) 
	{
		lcd_write_byte(this_text[i++]);
		long_delay();
	}
}


char LCD_Putchar(char zeichen)
{
	short_delay();
	lcd_write_byte((char) zeichen);
	return(1);
}


