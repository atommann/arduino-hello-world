; The "hello world" program in assembler for Arduino
; (i.e. blink the on-board LED on PB5)
;
; Operating System: GNU/Linux
; Needed tools: avr-binutils
; Assembler: avr-as
;
; Ref
; [1] https://medium.com/jungletronics/meeting-assembly-hello-world-arduino-blinking-code-330386652309
; [2] http://nerdathome.blogspot.com/2008/04/avr-as-usage-tutorial.html
; [3] https://www.cypherpunk.at/2014/09/native-assembler-programming-on-arduino/
; [4] https://www.cypherpunk.at/2015/11/assembler-on-arduino-part-2/

;#include <avr/io.h>

.equ PORTB, 0x05  ; these numbers are the register addresses
.equ DDRB,  0x04
.equ PINB,  0x03

.equ SPH,   0x3E  ; Stack Pointer High register
.equ SPL,   0x3D  ; Stack Pointer Low retister

.equ RAMEND, 0x8FF


.org 0x0000    ; the next instruction has to be written to address 0x0000
    rjmp START ; the reset vector: jump to "main"
               ; here we ignore the interrupt vectors

START:         ; this is a label "START"

    ; set up the stack
    ldi r16, lo8(RAMEND) ; lo8() get the lower byte of a data
    out SPL, r16

    ldi r16, hi8(RAMEND)  ; hi8() get the 2nd higher byte
    out SPH, r16

    sbi DDRB,  5 ; set PB5 as output mode
    sbi PORTB, 5 ; high, LED off


; infinite loop
LOOP:

    sbi PORTB, 5       ; switch off the LED

    rcall DELAY_500MS  ; wait for 0.5s (500 ms)

    cbi PORTB, 5       ; switch it on

    rcall DELAY_500MS  ; wait for 0.5s (500 ms)

    rjmp LOOP          ; "Relative JuMP" to LOOP


; The 500ms delay subroutine
; for the detailed calculation see Ref[1]
DELAY_500MS:

    ldi r16, 31        ; load r16 with 31

OUTER_LOOP:            ; outer loop label
    
    ldi r24, lo8(1021) ; load register r24:r25 with 1021, our new init value
    ldi r25, hi8(1021)

DELAY_LOOP:

    adiw r24, 1        ; "add immediate to word": r24:r25 are incremented

    brne DELAY_LOOP    ; if no overflow ("branch if not equal")
                       ; go back to "delay_loop"

    dec r16            ; decrment r16

    brne OUTER_LOOP    ; and loop if outer loop not finished

    ret                ; return from subroutine

