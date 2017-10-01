; 闪烁 Arduino Uno 上的板载 LED
;
; 延时方法来自《AVR 单片机嵌入式系统原理与应用实践》 马潮 编著
;
; 扩展名用 .S 是方便用 gcc 的预处理器 cpp 对汇编源文件进行处理
; 这样可以用 #include #define 等指令
;
; TODO
; 应该写一个 blink without delay 的例子，用 Timer
;
; 参考
; [1] https://www.cypherpunk.at/2015/11/assembler-on-arduino-part-2/

#include <avr/io.h>

; 下面这些寄存器/常量定义在 <avr/io.h> 中
;.equ PORTB, 0x05
;.equ DDRB,  0x04
;.equ PINB,  0x03
;.equ SPH,   0x3E
;.equ SPL,   0x3D
;.equ RAMEND, 0x8FF


.org 0x0000    ; the next instruction has to be written to address 0x0000
    rjmp START ; the reset vector: jump to "main"
               ; here we ignore the interrupt vectors

START:         ; this is a label "START"


    ; reset system status register
    ldi r16, 0
    out _SFR_IO_ADDR(SREG), r16

    ldi r16, lo8(RAMEND)       ; init stack pointer
    out _SFR_IO_ADDR(SPL), r16

    ldi r16, hi8(RAMEND)
    out _SFR_IO_ADDR(SPH), r16

    ldi r16, 0b00100000
    out _SFR_IO_ADDR(DDRB),  r16  ; set PB5 to output mode
    out _SFR_IO_ADDR(PORTB), r16  ; high, LED off

    ldi r16, 249  ; 设置 500ms 延时参数

; infinite loop
LOOP:
    sbi _SFR_IO_ADDR(PORTB), 5 ; switch off the LED
    rcall delay                ; wait for 0.5s (500 ms)
    cbi _SFR_IO_ADDR(PORTB), 5 ; switch it on
    rcall delay                ; wait for 0.5s (500 ms)
    rjmp LOOP                  ; "Relative JuMP" to LOOP


; 通用延时子程序
; 计算方法，第 132 页 "5.1.4 通用延时子程序分析"
; 1/(16MHz) to us = 0.0625 us
; 0.0625us * 8000629 = 500 ms
delay:
    push r16  ; (2t)

del1:
    push r16  ; (2t)

del2:
    push r16  ; (2t)

del3:
    dec r16   ; (1t)
    brne del3 ; 不为 0 跳转到 del3; 为 0 顺序执行 (2t/1t)
    pop r16   ; (2t)
    dec r16   ; (1t)
    brne del2 ; 不为 0 跳转到 del2; 为 0 顺序执行 (2t/1t)
    pop r16   ; (2t)
    dec r16   ; (1t)
    brne del1 ; 不为 0 跳转到 del2; 为 0 顺序执行 (2t/1t)
    pop r16   ; (2t)
    ret       ; 子程序返回 (4t)

