#ifndef _LCD_H_
#define _LCD_H_

#define LCD_Clear  {_lcd_write_command(0x01); long_delay();}

extern void    long_delay(void);
extern void    _lcd_write_command(unsigned char);
extern void    LCD_Write(unsigned char *);
extern void    LCD_Init(void);
extern char    LCD_Putchar(char);
extern void    LCD_Gotoxy(unsigned char  , unsigned char );

#endif
