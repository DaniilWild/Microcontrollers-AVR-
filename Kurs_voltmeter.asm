.DEF	tmp0		= R16
.DEF	tmp1		= R17
.DEF	suml		= R19
.DEF	sumlm		= R20
.DEF	sumhm		= R21
.DEF	sumh		= R22
.DEF	il		= R23
.DEF	ih		= R24
.DEF	input		= R25
.DEF	zero		= R15
.DEF	tmp2		= R18
.DEF	led1		= R14
.DEF	led2		= R13
.DEF	led3		= R12

.MACRO Nextnumber
   clr il 
   inc il
   sub suml,tmp1  
   sbc sumlm,tmp0 
   sbc sumhm,zero
   brcc PC-4
   add suml,tmp1
   adc sumlm,tmp0
   adc sumhm,zero
   dec il

   ldi ZL,LOW(nums*2)
   ldi ZH,HIGH(nums*2)
   clr ih
   dec ih
   Ledloop1:
      inc ih
      cp il,ih
      lpm tmp0,Z+
   brne Ledloop1 
.ENDM

.MACRO Sqrt
   clr tmp0
   SqrtCycle:
      inc tmp0
      cpi tmp0,255
      breq Equal
      mul tmp0,tmp0
      cp R1,@1
      brlo SqrtCycle
      brne Finish
      cp R0,@2
      brlo SqrtCycle
      breq Equal
   Finish:
      dec tmp0
   Equal:
      mov @0,tmp0
.ENDM

.MACRO Outi
   ldi tmp0,@1
   out @0,tmp0
.ENDM

.CSEG
.ORG $0000
rjmp Init
.ORG $001C
rjmp ADCC

Nums:	.DB 0b11000000,0b11111001,
.DB 0b10100100,0b10110000,
.DB 0b10011001,0b10010010,
.DB 0b10000010,0b11111000,
.DB 0b10000000,0b10010000

ADCC:
   cbi ADCSRA,ADEN

   in input,ADCH

   ldi tmp0,1
   add il,tmp0
   adc ih,zero
   brcs OVF

   cp input,zero
   breq Exit

   mul input,input
   add suml,R0
   adc sumlm,R1
   adc sumhm,zero
   adc sumh,zero
   Exit:
   sbi ADCSRA,ADEN
   sbi ADCSRA,ADSC
   reti

   OVF:

      Sqrt tmp1,sumh,sumhm
      out PORTB, tmp1
      ; 280
      ldi tmp0,0b00000001
      ldi tmp2,0b00011000

      clr suml
      clr sumlm
      clr sumhm
      clr sumh

      mul tmp1,tmp2
      mov suml,R0
      mov sumlm,R1
      mul tmp1,tmp0
      add sumlm,R0
      adc sumhm,R1

      ; 10000
      ldi tmp0,0b00100111
      ldi tmp1,0b00010000

      Nextnumber

      subi tmp0,0b10000000
      mov led1,tmp0

      ; 1000
      ldi tmp0,0b00000011
      ldi tmp1,0b11101000

      Nextnumber

      mov led2,tmp0

      ; 100
      clr tmp0
      ldi tmp1,0b01100100

      Nextnumber

      mov led3,tmp0
      sbi ADCSRA,ADEN
      sbi ADCSRA,ADSC
      reti

Init:
   sei
   outi SPL,LOW(RAMEND)
   outi SPH,HIGH(RAMEND)
   outi ADMUX,(1<<REFS0)|(1<<ADLAR)
   outi ADCSRA,(1<<ADEN)|(1<<ADSC)|(1<<ADIE)|(0<<ADPS2)|(1<<ADPS1)|(0<<ADPS0)
   outi DDRD,0xFF
   outi DDRC,0xFF
   outi DDRB,0xFF
   clr zero

Loop:
   Outi PORTC,0xFF
   Outi PORTD,0b00000001
   out PORTC,led1

   Outi PORTC,0xFF
   Outi PORTD,0b00000010
   out PORTC,led2

   Outi PORTC,0xFF
   Outi PORTD,0b00000100
   out PORTC,led3

   rjmp Loop
