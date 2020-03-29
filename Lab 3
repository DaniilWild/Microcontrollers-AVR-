******************************************************
; BASIC .ASM template file for AVR
; ******************************************************
.includeC:\VMLAB\include\m16def.inc;
.def temp =r16
.def digit = r17
.def tim = r18

.dseg
Digit_table:
    .byte 10
  
.cseg
.org 0x0000
rjmp Init

.org OVF1addr
rjmp timer_ovf

timer_ovf:
  ldi temp, 0x00000000
  out PORTD, temp
  rcall Set_digit
  out PORTD, tim
  lsl tim
  inc digit
  cpi tim, 16
  brlo label_1
  ldi tim, 1
  ldi digit, 3
  
label_1:
  ldi temp, 0b11111111
  out TCNT1H, temp
  ldi temp, 0b10110010
  out TCNT1l, temp
  reti
  
Set_digit:
  ldi ZL, LOW(Digit_table)
  ldi ZH, HIGH(Digit_table)
  add ZL, digit
  brcc No_carry
  inc ZH
  No_carry:
  ld temp, Z
  out PORTB, temp
  ret
  
Init:
  ldi temp, LOW(RAMEND)
  out SPL, temp

  ldi temp, HIGH(RAMEND)
  out SPH, temp
  ldi temp, 0b00001111
  out DDRD, temp
  ldi temp, 0b00000000
  out PORTD, temp
  ldi temp, 0b11111111
  out DDRB, temp
  ldi temp, 0b11111111
  out PORTB, temp
  sei
  ldi temp, 0b00000011
  out TCCR1B, temp
  ldi temp, (1&lt;&lt;TOIE1)
  out TIMSK, temp
  ldi temp, 0b11111111
  out TCNT1H, temp
  ldi temp, 0b10110010
  out TCNT1l, temp
  ldi tim, 1
  ldi digit,
  Set_table:
  ldi ZL, LOW(Digit_table)
  ldi ZH, HIGH(Digit_table)
  ldi temp, 0b11000000
  st Z+, temp
  ldi temp, 0b11111001
  st Z+, temp
  ldi temp, 0b10100100
  st Z+, temp
  ldi temp, 0b10110000
  st Z+, temp
  ldi temp, 0b10011001
  st Z+, temp
  ldi temp, 0b10010010
  st Z+, temp
  ldi temp, 0b10000010
  st Z+, temp
  ldi temp, 0b11111000
  st Z+, temp
  ldi temp, 0b10000000
  st Z+, temp
  ldi temp, 0b10010000
  st Z+, temp
  
Start:
  rjmp Start
.exit
