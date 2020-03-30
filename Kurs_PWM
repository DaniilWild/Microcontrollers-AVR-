.def temp = r16
.def temp1 = r17
.def i0 = r18
.MACRO outi
	ldi temp1,@1
	out @0,temp1
.ENDMACRO


;CSEG--------------------------------------
.CSEG
.org 0
rjmp init
.org $0006
rjmp Interraption_PWM_2
.org $0026
rjmp Interraption_PWM_0

table_sin:
.DB 152,176,198,218,234,245,253,255,253,245,234,218,198,176,152,128,103, 79, 57, 37, 21, 10, 2, 0,2, 10, 21, 37, 57, 79,103,128


Init:
	outi spl, low(RAMEND)
	outi sph, high(RAMEND)
	ldi Zl,low(table_sin<<1)
	ldi ZH,high(table_sin<<1)
Start:
	outi PORTB,0
	outi DDRB,0xff
	outi TIMSK,(1<<OCIE0)|(1<<OCIE2)
	outi TCCR0,(0<<WGM01)|(0<<WGM00)|(0<<COM01)|(0<<COM00)|(0<<CS02)|(1<<CS01)|(0<<CS00)
	outi TCCR2,(0<<WGM01)|(0<<WGM00)|(0<<COM01)|(0<<COM00)|(0<<CS22)|(1<<CS21)|(0<<CS20);
	outi TCNT0,0
	outi TCNT2,0
	outi OCR0,0
	outi OCR2,255
	ldi i0,0
	sei
Wait:
	rjmp wait
	
Interraption_PWM_0:
	cpi i0,32
	brne L1
	ldi Zl,low(table_sin<<1)
	ldi ZH,high(table_sin<<1)
	ldi i0,0
L1:
	LPM temp,Z+
	out OCR0,temp
	inc i0
	
	in temp,PORTB
	ldi temp1,(1<<PINB2)
	eor temp,temp1
	out PORTB,temp
	reti
Interraption_PWM_2:
	outi PORTB,(1<<PINB2)
	reti 
