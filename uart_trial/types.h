
/*
  Copyright (C) 2000 Jesper Hansen <jesperh@telia.com>.

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


#ifndef __TYPES_H__
#define __TYPES_H__

typedef unsigned char  BYTE;
typedef unsigned int   WORD;
typedef unsigned long  DWORD;

typedef unsigned short  USHORT;
typedef unsigned char   BOOL;

typedef unsigned char  UCHAR;
typedef unsigned int   UINT;
typedef unsigned long  ULONG;

typedef char  CHAR;
typedef int   INT;
typedef long  LONG;

// alternative types

typedef unsigned char  uint8;
typedef unsigned short uint16;
typedef unsigned long  uint32;
/*
typedef char  S8;
typedef short S16;
typedef long  S32;
*/

//#define NULL    0

#define sbi(a, b) ( ( a ) |= ( 1 << ( b ) ) )
#define cbi(a, b) ( ( a ) &= ~( 1 << ( b ) ) )
#define outp(data, port) ( (port) = (data) )
#define inp(port)	(port)
#define PRG_RDB(a) pgm_read_byte(a)
#define BV(a) _BV(a)
#endif
