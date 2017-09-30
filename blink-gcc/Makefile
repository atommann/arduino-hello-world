all:
	avr-gcc -g -Os -DF_CPU=16000000UL -mmcu=atmega328p -Wall -Werror -c blink.c
	avr-gcc -g -mmcu=atmega328p -o blink.elf blink.o
	avr-objdump -h -S blink.elf > blink.lst
	avr-objcopy -j .text -j .data -O ihex blink.elf blink.hex
	avr-objcopy -j .eeprom --change-section-lma .eeprom=0 -O ihex blink.elf blink_eeprom.hex

program:
	avrdude -F -V -c arduino -p ATMEGA328P -P /dev/ttyACM0 -b 115200 -U flash:w:blink.hex:i

clean:
	rm *.o *.lst *.hex *.elf

# Ref
# http://www.nongnu.org/avr-libc/user-manual/group__demo__project.html

