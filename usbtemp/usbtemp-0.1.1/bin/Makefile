# Name: Makefile
# Project: usbtemp
# Author: Mathias Dalheimer, md@gonium.net
# Based on PowerSwitch example code of AVR-USB.
# Copyright: (c) 2005 by OBJECTIVE DEVELOPMENT Software GmbH
# (c) 2008 Mathias Dalheimer
# License: GNU GPL v2 (see License.txt) or proprietary (CommercialLicense.txt)


# Concigure the following definitions according to your system. The powerSwitch
# tool has been successfully compiled on Mac OS X, Linux and Windows.

# Use the following 3 lines on Unix (uncomment the framework on Mac OS X):
USBFLAGS = `libusb-config --cflags`
USBLIBS = `libusb-config --libs` #-framework CoreFoundation
PYFLAGS = `pkg-config --cflags python`
EXE_SUFFIX =

# Use the following 3 lines on Windows and comment out the 3 above. You may
# have to change the include paths to where you installed libusb-win32
#USBFLAGS = -I/usr/local/include
#USBLIBS = -L/usr/local/lib -lusb
#EXE_SUFFIX = .exe

CC		= gcc
CFLAGS	= $(USBFLAGS) -O -Wall -std=c99
LIBS	= $(USBLIBS)

PROGRAM = usbtemp$(EXE_SUFFIX)


all: $(PROGRAM)

_usbtemp.o: usbtemp.c
	$(CC) $(CFLAGS) -c $< -o $@

usbtemp.o: usbtemp.c
	$(CC) -fpic $(CFLAGS) -c $< -o $@

usbtemp_wrap.o: usbtemp_wrap.c
	$(CC) -fpic $(CFLAGS) $(PYFLAGS) -c $<

$(PROGRAM): _usbtemp.o
	$(CC) -o $(PROGRAM) $< $(LIBS)

strip: $(PROGRAM)
	strip $(PROGRAM)

setuid: $(PROGRAM)
	@echo "Attempting to modify the binary. Please provide root password."
	su -c "chown root $(PROGRAM) && chmod u+s $(PROGRAM)" root

usbtemp_wrap.c: usbtemp.i
	swig -python usbtemp.i

_usbtemp.so: usbtemp.o usbtemp_wrap.o
	ld -shared usbtemp.o usbtemp_wrap.o -o $@ $(LIBS)

swig: _usbtemp.so


clean:
	rm -f *.o $(PROGRAM) *wrap.c *.so *.py *.pyc *~
