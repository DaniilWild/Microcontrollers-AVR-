.EQU		XTAL 					= 8000000
.EQU		baudrate 				= 9600
.EQU		bauddivider 				= XTAL/(16*baudrate)-1
.DEF		tmp 					= R16
.DEF		scnt					= R19
.DEF		tcnt					= R20
.DEF		received				= R17
.DEF		i					= R18

.MACRO outi
	LDI tmp,@1
	OUT @0,tmp
.ENDM

.CSEG
.ORG $000
RJMP Init
.ORG $010
RJMP Main

Keys: 	.DB						0xFE,0x34,0x42,0x63,0x07,0xDA,0x0F,0xAB,0xF1,0xBE	

Init:
	SEI
	outi SPH,HIGH(RAMEND)
	outi SPL,LOW(RAMEND)
	outi DDRB,(1<<PB2)
	outi TCCR1B,(0<<CS12)|(1<<CS11)|(1<<CS10)
	outi TIMSK,(1<<TOIE1)
	outi UBRRL,LOW(bauddivider)
	outi UBRRH,HIGH(bauddivider)
	outi UCSRA,0
	outi UCSRB,(1<<RXEN)|(0<<TXEN)|(0<<RXCIE)|(0<<TXCIE)|(0<<UDRIE)
	outi UCSRC,(1<<URSEL)|(1<<UCSZ0)|(1<<UCSZ1)
	RJMP Main

UART_receive:
	SBIS UCSRA,RXC
	RJMP UART_receive
	IN received,UDR
	RETI
	
Wait:
	RJMP Wait	
Main:
	outi PORTB,(0<<PB2)
	RCALL UART_receive
	LDI ZL,LOW(Keys*2)
	LDI ZH,HIGH(Keys*2)
	CLR i
Loop:
	LPM tmp,Z+
	CP received,tmp
	BREQ Open
	INC i
	CPI i,10
	BREQ Main
	RJMP Loop	
Open:
	outi PORTB,(1<<PB2)
	outi TCNT1H,0x00
	outi TCNT1L,0x00
	RJMP Wait
