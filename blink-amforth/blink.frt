\ let the LED at digital-13 aka PortB.5 blink
\ see http://amforth.sourceforge.net/TG/recipes/Arduino-HelloWorld.html

$25 constant PORTB
$24 constant DDRB

\ initialize the Port: change to output mode
: led-init
  $20 DDRB c!
;

\ turn the LED on
: led-on
  $20 PORTB c!
;

\ turn the LED off
: led-off
  0 PORTB c!
;

\ let LED blink once
: led-blink
  led-on 500 ms led-off 500 ms
;

\ let LED blink until a keystroke
: blink
  ." press any key to stop "
  begin
    led-blink
    key?
  until
  key drop \ we do not want to keep this key stroke

\ and do it...
led-init blink


