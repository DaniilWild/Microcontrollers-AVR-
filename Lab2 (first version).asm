.include &quot;C:\VMLAB\include\m16def.inc&quot;
.def temp =r16
.def buf =r17
.CSEG
.ORG $000
rjmp reset
.org OVF1addr ; прерыванию по переполнению 1 счетчика
rjmp blink
reset:
ldi temp, low(RamEnd) ;инцинилизация стека
out spl, temp
ldi temp, high(RamEnd)
out sph, temp
clr temp
SEI
call port_output
call click_timer
rjmp forever
click_timer:
ldi temp,0b00000100 ;разрешаем прерывание первого таймера по переполнению
out TIMSK,temp
ldi temp,0b00000001 ;предделитель на 2
out TCCR1B,temp
ldi temp,0b11100000
out TCNT1H,temp
ldi temp,0b11000000
out TCNT1L,temp
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

8

reti
