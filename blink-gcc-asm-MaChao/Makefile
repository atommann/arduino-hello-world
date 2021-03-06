# Makefile to build and upload assembler sources for Arduino.
#
# @author Bernhard R. Fischer, 2048R/5C5FFD47 <bf@abenteuerland.at>
#
# @license This is free software, do what ever you like with it.
#
# @usage Put this file into the directory with your assembler sources. The name
# of the directory will be the name of the final (TARGET) file. All assembler
# sources shall have the extension .S, thus being preprocessed by cpp.
# Assembler include (header) files should not have the extensions .s or .S but
# .inc or .h. Have a look at the macros MCU, USBDEV, and BAUD which probably
# have to be changed according to your Arduino board. Finally run `make`. It
# will assemble everything into an elf binary (TARGET.elf) and an Intel hex
# file (TARGET.hex). This can be uploaded by calling `make upload`. To show the
# final disassembly call `make dump`.
#
# @notes To compile and upload using this Makefile you need the packages
# 'gcc-avr' and 'avrdude' (the upload utility).
#
TARGET = $(notdir $(CURDIR))
SOURCES = $(wildcard *.S)
OBJECTS = $(SOURCES:.S=.o)
MCU = atmega328p
#MCU = atmega16
## settings for Uno
USBDEV = /dev/ttyACM0
BAUD = 115200
# settings for Duemilanove
#USBDEV = /dev/ttyUSB0
#BAUD = 57600

AS = avr-as
CC = avr-gcc
LD = avr-ld
OBJDUMP = avr-objdump
CPP = avr-cpp

CFLAGS = -g -mmcu=$(MCU)
ASFLAGS = -g -mmcu=$(MCU)
LDFLAGS = -Tdata=0x800100 -nostdlib
#LDFLAGS = -Tbss=0x800100 -Tdata=0x800300
AVRDUDE = avrdude
AVRDUDE_CONF = /etc/avrdude/avrdude.conf

all: $(TARGET).hex

$(TARGET).elf: $(OBJECTS)
	$(CC)	$(LDFLAGS) $(OBJECTS) -o $@

$(TARGET).hex: $(TARGET).elf
	avr-objcopy -O ihex -R .eeprom $(TARGET).elf $(TARGET).hex

upload: $(TARGET).hex
	$(AVRDUDE) -C $(AVRDUDE_CONF) -p $(MCU) -c arduino -P $(USBDEV) -b $(BAUD) -D -U flash:w:$(TARGET).hex:i

dump: $(TARGET).elf
	$(OBJDUMP) -d $(TARGET).elf

clean:
	rm -f $(TARGET).elf $(TARGET).hex $(OBJECTS)

.PHONY: clean upload dump

