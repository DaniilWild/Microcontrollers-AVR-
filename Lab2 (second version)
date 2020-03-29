.include &quot;C:\VMLAB\include\m16def.inc&quot;
.def temp =r16
.def buf =r17
.CSEG
.ORG $000
rjmp reset
.org INT0addr ; прерыванию по переполнению 1 счетчика
rjmp blink
reset:
ldi temp, low(RamEnd) ;инцинилизация стека
out spl, temp
ldi temp, high(RamEnd)
out sph, temp
clr temp
SEI
call port_output
call click_button
rjmp forever

click_button: ; Настройка выхода PB2 на прерывание по кнопке
ldi temp,0b01000000
out GICR,temp
ldi temp,0b00000001
out MCUCR,temp
ret
port_output: ;Настройка порта А1 на выход 5v
ldi temp, 0b00000010
out DDRA,temp
ldi temp, 0b00000010
out PORTA,temp
ret
forever: ; основная функция
rjmp forever
blink: ;Переключение светодиода в новое положеине
in temp,PORTA
ldi buf,0b00000010
sub buf,temp
out PORTA,buf
reti
