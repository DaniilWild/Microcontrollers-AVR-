.include "C:\VMLAB\include\m16def.inc"
.def  temp  =r16
.def  flag =r17
.def  digit = r18
.def  buff  =r19
.dseg
Digit_table:
    .byte 10
.cseg
.org 0
rjmp reset
.org $010
rjmp Button_chek
reset:
    ldi temp, HIGH(RAMEND)
    out SPH, temp
    ldi temp, LOW(RAMEND)
    out SPL, temp
    SEI
    ldi temp, 0b11111111
    out DDRD, temp
    ldi temp, 0b11111111
    out DDRC, temp
    ldi temp, 0b11111111
    out PORTC, temp
    ldi temp, 0b00000011
    out TCCR1B, temp
    ldi temp, (1<<TOIE1)
    out TIMSK, temp
    ldi temp, 0b11111111
    out TCNT1H, temp
    ldi temp, 0b10110010
    out TCNT1L, temp
    ldi digit, 0b00000001
Set_table:
    ldi ZL, LOW(Digit_table)
    ldi ZH, HIGH(Digit_table)
    ldi temp, 0b11000000
    st Z+, temp; "0"
    ldi temp, 0b11111001
    st Z+, temp; "1"
    ldi temp, 0b10100100
    st Z+, temp; "2"
    ldi temp, 0b10110000
    st Z+, temp; "3"
    ldi temp, 0b10011001
    st Z+, temp; "4"
    ldi temp, 0b10010010
    st Z+, temp; "5"
    ldi temp, 0b10000010
    st Z+, temp; "6"
    ldi temp, 0b11111000
    st Z+, temp; "7"
    ldi temp, 0b10000000
    st Z+, temp; "8"
    ldi temp, 0b10010000
    st Z+, temp; "9"
forever:
    ldi temp , 0b00000001
    out PORTD, temp
    rcall Set_digit
    ldi temp , 0b00000010
    out PORTD, temp
    rcall Set_digit
    ldi temp , 0b00000100
    out PORTD, temp
    rcall Set_digit
    ldi temp , 0b00001000
    out PORTD, temp
    rcall Set_digit
    rjmp forever
Button_chek:
    ldi temp, 0b11111111
    out PORTC, temp
    ldi temp, 0b00000000
    out DDRD, temp
    ldi temp, 0b00000011
    out PORTD, temp

    in buff, PIND
    cpi buff ,  0b10111110
    breq clic_inc
	 cpi buff ,  0b10111101
    breq clic_dec
	 ldi flag,0
    timer_res:
    ldi temp, 0b11111111
    out TCNT1H, temp
    ldi temp, 0b10110010
    out TCNT1l, temp
    reti
clic_inc:
	 cpi flag ,1
	 breq no_flag_inc
cpi digit ,9
	 breq no_flag_inc
    inc digit
    ldi flag,1
 no_flag_inc:
    rjmp timer_res
clic_dec:
	 cpi flag ,1
	 breq no_flag_dec
	 cpi digit ,0
	 breq no_flag_dec
	
    dec digit
    ldi flag,1
    no_flag_dec:
    rjmp timer_res

Set_digit:
    ldi ZL, LOW(Digit_table)
    ldi ZH, HIGH(Digit_table)
    add ZL, digit
    ld temp, Z
    out PORTC, temp
    ret
