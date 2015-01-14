

/*
  Jesper Hansen <jesperh@telia.com>
  
  Original Author: Volker Oth <volkeroth@gmx.de>

  This file is part of the yampp system.

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


#ifndef __UART_H__
#define __UART_H__
#include <stdint.h>
#include <avr/pgmspace.h>
/* Global definitions */
#if 0
typedef unsigned char  uint8_t;
typedef          char  s08;
typedef unsigned short u16;
typedef          short s16;
typedef unsigned long  u32;
typedef          long  s32;
#endif

/* UART Baud rate calculation */
#define UART_BAUD_RATE         9600        /* baud rate*/
#define UART_BAUD_SELECT       (F_CPU/(UART_BAUD_RATE*16L)-1)

/* Global functions */
extern void UART_SendByte       (uint8_t Data);
extern uint8_t  UART_ReceiveByte    (void);
extern void UART_PrintfProgStr  ( char const * const pBuf);
extern void UART_PrintfEndOfLine(void);
extern void UART_Printfuint8_t      (uint8_t Data);
extern void UART_Printfu16      (uint16_t Data);
extern void UART_Printfu32      (uint32_t Data);
extern void UART_Init           (void);
extern unsigned char UART_HasChar(void);
extern void UART_Puts  			( char const * const pBuf);
extern void UART_Putsln			( char const * const pBuf);

extern void print_number(int base, int unsigned_p, long n);


/* Macros */
#define PRINT(string) (UART_PrintfProgStr( PSTR(string)))
#define EOL           UART_PrintfEndOfLine
#endif

