/* Name: main.c
 * Project: DDS based on ObDev's PowerSwitch based on AVR USB driver
 * Author: Christian Starkjohann (PowerSwitch) and Thomas Baier DG8SAQ (DDS extensions)
 * Creation Date: 2005-01-16
 * Tabsize: 4
 * Copyright: (c) 2005 by OBJECTIVE DEVELOPMENT Software GmbH
 * License: GNU GPL v2 (see License.txt) or proprietary (CommercialLicense.txt)
 * This Revision: 
 */

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <avr/wdt.h>

#include "usbdrv.h"
#include "oddebug.h"


#define DDS1_SDA (1<<1)		//PORTB1
#define DDS_SCL  (1<<3)		//PORTB3
#define DDS_UPDATE (1<<4)	//PORTB4

static uchar usb_val;

USB_PUBLIC uchar usbFunctionWrite(uchar *data, uchar len) //sends len bytes to DDS_SDA
{
uchar i;
uchar b;
uchar adr=0;
	while (len!=0){
		b=1;
		for (i=0;i<8;i++){
			if (b & data[adr]){
				PORTB = (PORTB | DDS1_SDA) & ~DDS_SCL;
				PORTB = PORTB | DDS_SCL;
			}
			else{
				PORTB = PORTB & (~DDS1_SDA & ~DDS_SCL);
				PORTB = PORTB | DDS_SCL;
			}
			b=b<<1;
		}
	len--;
	adr++;
	}
if (usb_val){
    PORTB = PORTB | DDS_UPDATE;		// update DDS
	PORTB = PORTB & ~DDS_UPDATE;
    }
return 1;
}


USB_PUBLIC uchar usbFunctionSetup(uchar data[8])
{
usbRequest_t *rq = (void *)data;
static uchar    replyBuf[3];
    usbMsgPtr = replyBuf;
	if(rq->bRequest == 0){       		// ECHO value
        replyBuf[0] = data[2];			// rq->bRequest identical data[1]!
        replyBuf[1] = data[3];
        return 2;
    }
	if(rq->bRequest == 1){       		// set port directions
//        DDRA = data[2];
        DDRB = data[3];
		DDRD = data[4] & (~USBMASK & ~(1 << 2)); // protect USB interface
        return 0;
    }
	if(rq->bRequest == 2){       		// read ports 
//        replyBuf[0] = PINA;
        replyBuf[1] = PINB;
		replyBuf[2] = PIND;
        return 3;
	}
	if(rq->bRequest == 3){       		// read port states 
//        replyBuf[0] = PORTA;
        replyBuf[1] = PORTB;
		replyBuf[2] = PORTD;
        return 3;
    }
	if(rq->bRequest == 4){       		// set ports 
//        PORTA = data[2];
        PORTB = data[3];
		PORTD = data[4];
        return 0;
    }
	if(rq->bRequest == 5){       		// use usbFunctionWrite to transfer len bytes to DDS
		usb_val = data[2];				// usb_val!=0 => DDS update pulse after data transfer
        return 0xff;
	}
	if(rq->bRequest == 6){       
        PORTB = PORTB | DDS_UPDATE;		// issue update pulse to DDS
		PORTB = PORTB & ~DDS_UPDATE;
        return 0;
    }
	replyBuf[0] = 0xff;					// return value 0xff => command not supported 
    return 1;
}


int main(void)
{
	wdt_enable(WDTO_1S);	//set Watchdog Timer
	odDebugInit();
	PORTB=0xe0;				//Set PortB 0-4 zero
	DDRB=0x1f; 				//Set PORTB 0-4 output
    PORTD = 0;          	/* no pullups on USB pins */
    DDRD = ~USBMASK & ~(1 << 2);    /* all outputs except USB data and PD2 = INT0 */
    usbInit();
    sei();
    for(;;){    /* main event loop */
	    wdt_reset();//restart watchdog timer
        usbPoll();
    }
    return 0;
}

