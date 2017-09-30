#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
  DDRB  |= _BV(PB5); // set pin 5 as output mode
  PORTB |= _BV(PB5); // high, LED off

  // loop forever
  while (1) {
    PORTB &= ~_BV(PB5); // low, LED on
    _delay_ms(500);
 
    PORTB |= _BV(PB5); // high, LED off
    _delay_ms(500);
 }
}

