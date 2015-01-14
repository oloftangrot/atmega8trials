
# Tools and directories
AS		= avr-gcc -x assembler-with-cpp	
AVRDUDE = avrdude
BIN		= avr-objcopy
CC		= avr-gcc
RM		= rm -f
RN		= mv
INCDIR	= .
LIBDIR	= $(AVR)/avr/lib
#SHELL   = $(AVR)/bin/sh.exe
SHELL   = sh
FORMAT  = ihex
SILENT	= 

############################################################################################
############################################################################################

	
# CPU type
MCU = atmega8

# Processor frequency.
#     This will define a symbol, F_CPU, in all source code files equal to the 
#     processor frequency. You can then use this symbol in your source code to 
#     calculate timings. Do NOT tack on a 'UL' at the end, this will be done
#     automatically to create a 32-bit value in your source code.
F_CPU = 6000000

# Target
TRG	= a2d_trial

# C-source files
SRC	= $(TRG).c a2d.c uart.c

# Assembler source files
ASRC    =

# Libraries 
#LIB = $(AVR)/avr/lib/libc.a
LIB = 

# Compiler flags
CPFLAGS	= -g -O3 -Wall -Wstrict-prototypes -Wa,-ahlms=$(<:.c=.lst) -mcall-prologues
CPFLAGS += -DF_CPU=$(F_CPU)UL

# Assembler flags
ASFLAGS = -Wa,-gstabs

# Linker flags
LDFLAGS = -Wl,-Map=$(TRG).map,--cref


#---------------- Programming Options (avrdude) ----------------

# Programming hardware: alf avr910 avrisp bascom bsd 
# dt006 pavr picoweb pony-stk200 sp12 stk200 stk500
#
# Type: avrdude -c ?
# to get a full listing.
#
AVRDUDE_PROGRAMMER = usbasp

# com1 = serial port. Use lpt1 to connect to parallel port.
#AVRDUDE_PORT = com1    # programmer connected to serial device

AVRDUDE_WRITE_FLASH = -U flash:w:$(TRG).hex -B 16
#AVRDUDE_WRITE_EEPROM = -U eeprom:w:$(TARGET).eep


# Uncomment the following if you want avrdude's erase cycle counter.
# Note that this counter needs to be initialized first using -Yn,
# see avrdude manual.
#AVRDUDE_ERASE_COUNTER = -y

# Uncomment the following if you do /not/ wish a verification to be
# performed after programming the device.
#AVRDUDE_NO_VERIFY = -V

# Increase verbosity level.  Please use this when submitting bug
# reports about avrdude. See <http://savannah.nongnu.org/projects/avrdude> 
# to submit bug reports.
#AVRDUDE_VERBOSE = -v -v

#AVRDUDE_FLAGS = -p $(MCU) -P $(AVRDUDE_PORT) -c $(AVRDUDE_PROGRAMMER)
AVRDUDE_FLAGS = -p $(MCU) -c $(AVRDUDE_PROGRAMMER)
AVRDUDE_FLAGS += $(AVRDUDE_NO_VERIFY)
AVRDUDE_FLAGS += $(AVRDUDE_VERBOSE)
AVRDUDE_FLAGS += $(AVRDUDE_ERASE_COUNTER)

############################################################################################
############################################################################################

#define all project specific object files
OBJ	= $(ASRC:.s=.o) $(SRC:.c=.o)

CPFLAGS += -mmcu=$(MCU)
ASFLAGS += -mmcu=$(MCU)
LDFLAGS += -mmcu=$(MCU)

	  
#this defines the aims of the make process
#all:	$(TRG).obj $(TRG).elf $(TRG).rom $(TRG).hex 
all:	$(TRG).elf $(TRG).rom $(TRG).hex 


#compile: instructions to create assembler and/or object files from C source
%.o : %.c 
	$(SILENT)$(CC) -c $(CPFLAGS) -I$(INCDIR) $< -o $@

%.s : %.c
	$(SILENT)$(CC) -S $(CPFLAGS) -I$(INCDIR) $< -o $@

#assemble: instructions to create object file from assembler files
%.o : %.s
	$(SILENT)$(AS) -c $(ASFLAGS) -I$(INCDIR) $< -o $@

#link: instructions to create elf output file from object files
%.elf: $(OBJ)
	$(SILENT)$(CC) $(OBJ) $(LIB) $(LDFLAGS) -o $@

#create avrobj file from elf output file
#%.obj: %.elf
#	$(SILENT)$(BIN) -O avrobj $< $@

#create bin (ihex, srec) file from elf output file
%.rom: %.elf
	$(SILENT)$(BIN) -O $(FORMAT) $< $@
	$(SILENT)avr-size $(TRG).elf

%.hex: %.elf
	$(SILENT)$(BIN) -O ihex $< $@

# Program the device.  
program: $(TRG).hex
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH)

#make instruction to delete created files
clean:
	$(RM) $(OBJ)
	$(RM) $(TRG).map
	$(RM) $(TRG).elf
	$(RM) $(TRG).obj
	$(RM) $(TRG).eep
	$(RM) $(TRG).rom
	$(RM) $(TRG).hex
	$(RM) *.bak
	$(RM) *.lst
	$(RM) *.?_sym


############################################################################################
############################################################################################

###### dependecies, add any dependencies you need here ###################

$(TRG).o	: $(TRG).c a2d.h uart.h
a2d.o	: a2d.c a2d.h
uart.o : uart.c uart.h
