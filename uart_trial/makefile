
# Tools and directories
CC		= avr-gcc
AS		= avr-gcc -x assembler-with-cpp	
RM		= rm -f
RN		= mv
BIN		= avr-objcopy
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
F_CPU = 12000000

# Target
TRG	= uart_test

# C-source files
SRC	= uart.c $(TRG).c

# Assembler source files
ASRC    =

# Libraries 
#LIB = $(AVR)/avr/lib/libc.a
LIB = 

# Compiler flags
CPFLAGS	=  -g -O3 -Wall -Wstrict-prototypes -Wa,-ahlms=$(<:.c=.lst) -mcall-prologues
CPFLAGS += -DF_CPU=$(F_CPU)UL

# Assembler flags
ASFLAGS = -Wa,-gstabs

# Linker flags
LDFLAGS = -Wl,-Map=$(TRG).map,--cref


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

$(TRG).o	: $(TRG).c types.h uart.h
uart.o	: uart.c uart.h
