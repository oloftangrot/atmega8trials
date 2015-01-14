
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


#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include "uart.h"
#include "types.h"

/* UART global variables */
volatile u08   UART_Ready;
volatile u08   UART_ReceivedChar;
         u08   UART_RxChar;
         u08*  pUART_Buffer;

/* end-of-line string = 'Line End' + 'Line Feed' character */
//prog_char UART_pszEndOfLine[3] = {0x0d,0x0a,0};

/* UART Transmit Complete Interrupt Function */
// SIGNAL(SIG_UART_TRANS)      
SIGNAL( USART_TXC_vect )
{
    /* Test if a string is being sent */
    if (pUART_Buffer!=0)
    {
        /* Go to next character in string */
        pUART_Buffer++;
        /* Test if the end of string has been reached */
        if ( pgm_read_byte( pUART_Buffer ) == 0 )
        {
            /* String has been sent */
            pUART_Buffer = 0;
            /* Indicate that the UART is now ready to send */
            UART_Ready   = 1;
            return;
        }
        /* Send next character in string */
        outp( pgm_read_byte(pUART_Buffer), UDR );
        return;
    }
    /* Indicate that the UART is now ready to send */
    UART_Ready = 1;
}

extern char f1;
/* UART Receive Complete Interrupt Function */
// SIGNAL(SIG_UART_RECV)      
SIGNAL( USART_RXC_vect )
{
    /* Indicate that the UART has received a character */
    UART_ReceivedChar = 1;
    /* Store received character */
    UART_RxChar = UDR;
	if ( f1 ) // Toggle hart beat LED.
	{ 
		f1 = 0;
		PORTB &= ~(1 << PB2); 
	}
	else
	{
		f1 = 1;
		PORTB |= 1 << PB2;
	}
}

void UART_SendByte(u08 Data)
{   
	while ((UCSRA & 0x20) != 0x20);

    /* wait for UART to become available */
//    while(!UART_Ready);
//    UART_Ready = 0;

    /* Send character */
    UDR = Data ;
}

u08 UART_ReceiveByte(void)
{
    /* wait for UART to indicate that a character has been received */
    while(!UART_ReceivedChar);
    UART_ReceivedChar = 0;
    /* read byte from UART data buffer */
    return UART_RxChar;
}

void UART_PrintfProgStr(s08 const * const pBuf)
{
	  s08 b;

    pUART_Buffer = (u08*) pBuf;
	
	  do
		{
		    b = pgm_read_byte(pUART_Buffer);
		    pUART_Buffer++;
		    if (b) 
		    {
			      UART_SendByte(b);    
			  }
    } 
		while (b);

#ifdef HUGO	
    /* wait for UART to become available */
    while(!UART_Ready);
    UART_Ready = 0;
    /* Indicate to ISR the string to be sent */
    pUART_Buffer = pBuf;
    /* Send first character */
    UDR = pgm_read_byte( pUART_Buffer );
#endif    

}

void UART_PrintfEndOfLine(void)
{
	UART_SendByte(0x0d);
	UART_SendByte(0x0a);
}

void UART_PrintfU4(u08 Data)
{
    /* Send 4-bit hex value */
    u08 Character = Data&0x0f;
    if (Character>9)
    {
        Character+='A'-10;
    }
    else
    {
        Character+='0';
    }
    UART_SendByte(Character);
}

void UART_Printfu08(u08 Data)
{
    /* Send 8-bit hex value */
    UART_PrintfU4(Data>>4);
    UART_PrintfU4(Data);
}

void UART_Printfu16(u16 Data)
{
    /* Send 16-bit hex value */
    UART_Printfu08(Data>>8);
    UART_Printfu08(Data);
}

void UART_Printfu32(u32 Data)
{
    /* Send 32-bit hex value */
    UART_Printfu16(Data>>16);
    UART_Printfu16(Data);
}

void UART_Init(void)
{
	UART_Ready        = 1;
	UART_ReceivedChar = 0;
	pUART_Buffer      = 0;

	/* enable RxD/TxD and interrupts */
	UCSRB = BV(RXCIE) | /*BV(TXCIE)|*/ BV(RXEN) | BV(TXEN );

	/* set baud rate */
/*    outp( UART_BAUD_SELECT, UBRR);  */
	UBRRL = UART_BAUD_SELECT & 0xff;	// ATMega16 baud rate low byte.
	UBRRH = ( UART_BAUD_SELECT >> 8 ) & 0x0f; // ATMega16 baud rate high byte.


	/* enable interrupts */
	sei();
}

unsigned char UART_HasChar(void)
{
	return UART_ReceivedChar;
}


void UART_Puts(u08 const * pBuf)
{
	while (*pBuf)
	{
		if (*pBuf == '\n')
			UART_SendByte('\r'); // for stupid terminal program
		UART_SendByte(*pBuf++);
	}
}

void UART_Putsln(u08 const * const pBuf)
{
	UART_Puts(pBuf);
	UART_PrintfEndOfLine();
}

