.include C:\VMLAB\include\m16def.inc
.equ XTAL = 16000000
.equ baudrate = 9600
.equ bauddivider = XTAL/(16*baudrate)-1
.def temp =r16
.def low_bit =r17
.def hight_bit =r18

.dseg
Adr: .byte 2

.cseg
.org 0
rjmp reset

.org $018
rjmp start_send

.org $01A
rjmp forever

info: .db "Postavite 5 avtomatom&quot",0
reset:
  ldi temp, HIGH(RAMEND)
  out SPH, temp
  ldi temp, LOW(RAMEND)
  out SPL, temp
  clr temp
  ldi low_bit,low(2*info)
  ldi hight_bit,high(2*info)
  sts Adr,low_bit
  sts Adr+1,hight_bit
uart_reset:
  ldi temp, low(bauddivider)
  out UBRRL, temp
  ldi temp, high(bauddivider)
  out UBRRH, temp
  ldi temp, 0x00000000
  out UCSRA, temp
  ldi temp, (0<<RXEN)|(1<<TXEN)|(0<<RXCIE)|(1<<TXCIE)|(1<<UDRIE)
  out UCSRB, temp
  ldi temp, (1<<URSEL)|(1<<UCSZ0)|(1<<UCSZ1)
  out UCSRC, temp
  SEI

forever:
  rjmp forever
  
stop_send:
  ldi temp, (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)|(0<<UDRIE)
  out UCSRB, temp
  ret
  start_send:
  lds ZL,Adr
  lds ZH,Adr+1
  lpm temp,Z+
  cpi temp,0
  breq stop_send
  out UDR,temp
  sts Adr,ZL
  sts Adr+1,ZH
  reti
