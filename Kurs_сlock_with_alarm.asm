.DEF tcntl = R12
.DEF tcnth = R13
.DEF tmp2 = R14
.DEF tmp3 = R15
.DEF tmp0 = R16
.DEF tmp1 = R17
.DEF i1 = R18
.DEF i2 = R19
.DEF hours = R20
.DEF minutes = R21
.DEF led1 = R22
.DEF led2 = R23
.DEF led3 = R24
.DEF led4 = R25

; макрос вывода константы в регистр ввода/вывода
.MACRO outi
   LDI tmp0,@1
   OUT @0,tmp0
.ENDM

; деление на 10
.MACRO number
   LDI tmp1,@1
   CLR i2
   INC i2
   SUB @0,tmp1
   BRCC PC-2
   ADD @0,tmp1
   DEC i2
   LDI ZL,LOW(nums*2)
   LDI ZH,HIGH(nums*2)
   CLR i1
   DEC i1
   loop1:
      INC i1
      CP i2,i1
      LPM tmp0,Z+
   BRNE loop1
.ENDM

.CSEG
; таблица векторов прерываний
.ORG $0000
RJMP Init
.ORG $0008
RJMP OVF

; массив цифр
;nums: .DB 0b00111111,0b00000110,0b01011011,0b01001111,0b01100110,0b01101101,0b01111101,0b00000111,0b01111111,0b01101111
nums:	.DB	0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000

; обработка переполнения счётчика
OVF:
   LDI tmp0,1
   ADD tcntl,tmp0
   LDI tmp0,0
   ADC tcnth,tmp0
   MOV tmp0,tcnth
   CPI tmp0,0b00001110
   BRNE endif3
   MOV tmp0,tcntl
   CPI tmp0,0b01001110
   BREQ OVF2
   endif3:
   RETI

OVF2:
   CLR tcntl
   CLR tcnth
   INC minutes
   ; если минуты переполнились, то обнуляем и увеличиваем часы
   CPI minutes,60
   BRLO endif
   CLR minutes
   INC hours
   ; если часы переполнились, то обнуляем
   CPI hours,24
   BRLO endif
   CLR hours
   endif:
   ; запись часов и минут в регистры для 7сегментников
   MOV tmp2,hours
   MOV tmp3,minutes
   number tmp2,10
   MOV led1,tmp0
   number tmp2,1
   MOV led2,tmp0
   number tmp3,10
   MOV led3,tmp0
   number tmp3,1
   MOV led4,tmp0
   
   CPI hours,0
   BRNE else
   CPI minutes,1
   BRNE else
      outi PORTB,0b00000001
      RETI
   else:
      outi PORTB,0
      RETI
   
Init:
   ; глобальное разрешение прерываний
   SEI
   ; разрешение прерывания по переполнению таймера 2
   outi TIMSK,(1<<TOIE2)
   ; предделитель
   outi TCCR2,(1<<CS22)|(0<<CS21)|(0<<CS20)
   ; инициализация стека
   outi SPL,LOW(RAMEND)
   outi SPH,HIGH(RAMEND)
   ; инициализация портов вывода
   outi DDRB,0b00000001
   outi DDRC,0b11111111
   outi DDRD,0b00001111
   
   LDI ZL,LOW(nums*2)
   LDI ZH,HIGH(nums*2)
   LPM tmp0,Z
   MOV led1,tmp0
   MOV led2,tmp0
   MOV led3,tmp0
   MOV led4,tmp0
   
; главный цикл, вывод цифр на 7сегментники
Loop:	
   outi PORTC,0xFF
   outi PORTD,0b00000001
   OUT PORTC,led1
   outi PORTC,0xFF
   outi PORTD,0b00000010
   OUT PORTC,led2
   outi PORTC,0xFF
   outi PORTD,0b00000100
   OUT PORTC,led3
    outi PORTC,0xFF
   outi PORTD,0b00001000
   OUT PORTC,led4
   
   RJMP Loop
