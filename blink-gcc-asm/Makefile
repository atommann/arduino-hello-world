all:
	avr-as -mmcu=atmega328p -o blink.o blink.s
	avr-ld -o blink.elf blink.o
	avr-objcopy --output-target=ihex blink.elf blink.hex

program:
	avrdude -F -V -c arduino -p ATMEGA328P -P /dev/ttyACM0 -b 115200 -U flash:w:blink.hex

clean:
	rm *.o *.hex *.elf
