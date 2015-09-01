
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 4,000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _menu_var=R5
	.DEF _i=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_chars:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x27
	.DB  0x7F,0x6F,0x0,0x8,0x58,0x37,0x71,0x39
	.DB  0x38
_weeks:
	.DB  0x37,0x76,0x7F,0x73,0x39,0x73,0x66,0x31
	.DB  0x37,0x3E,0x39,0x7D,0x7F,0x39
_conv_delay_G102:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G102:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0018

_0x3:
	.DB  0xA
_0x4:
	.DB  0x0,0x4
_0x11A:
	.DB  0x0,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _d
	.DW  _0x3*2

	.DW  0x02
	.DW  _light_var
	.DW  _0x4*2

	.DW  0x02
	.DW  0x04
	.DW  _0x11A*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <spi.h>
;  #asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=6
   .equ __scl_bit=7
; 0000 0008 #endasm
;#include <i2c.h>
;#include <stdlib.h>
;   #asm
 .equ __w1_port=0x18 ;PORTB
 .equ __w1_bit=0
; 0000 000E  #endasm
;#include <1wire.h>
;#include <ds18b20.h>
;#include <ds1307.h>
;#define WRI PORTC.1=1; PORTC.1=0; // Защелка
;#define L1 PORTC.5
;#define L2 PORTC.4
;#define L3 PORTC.3
;#define L4 PORTC.2
;#define DS PORTD.5
;#define LIGHT(D)OCR1AH=(0xFF00 & D) >> 8; OCR1AL=(0x00FF & D)
;#define BEEP(D)TCCR1A=0x83 | (D<<5);
;#define FAD(F)TCCR0=F;
;#define B1 PINB.6
;#define B2 PIND.4
;#define MENU PINB.7
;#define Ext_EEPROM_Adr 0b10100000
;flash unsigned char chars[] =
;{
;0b00111111, // 0
;0b00000110, // 1
;0b01011011, // 2
;0b01001111,//  3
;0b01100110,//  4
;0b01101101,//  5
;0b01111101,//  6
;0b00100111,//  7
;0b01111111,//  8
;0b01101111,//  9
;0,        // 10 -
;0b00001000,// 11 -  _
;0b01011000, // 12-  c
;0b00110111, // 13- n
;0b01110001, // 14- f
;0b00111001, // 15- C
;0b00111000, // 16- L
;};
;flash unsigned char weeks[7][2] ={
;{0b00110111,0b01110110},
;{0b01111111,0b01110011},
;{0b00111001,0b01110011},
;{0b01100110,0b00110001},
;{0b00110111,0b00111110},
;{0b00111001,0b01111101},
;{0b01111111,0b00111001}
;};
;unsigned char menu_var=0, i=0;
;unsigned char d[4]= {10};

	.DSEG
;volatile unsigned char t_delay=0,step=0;
;volatile bit BEEP_DIS=0, BEEP_START=0, sec_led=0,time_start=1, alph=1,sec_en=0, b_menu=0;
;volatile unsigned int light_var=1024;
;typedef struct{
;    unsigned char sec;
;    unsigned char min;
;    unsigned char hour;
;    unsigned char dow;
;    unsigned char date;
;    unsigned char month;
;    unsigned char year;
;}time; time t;
;
;
;typedef struct{
;
;    unsigned char min;
;    unsigned char hour;
;    unsigned char ae;
;    unsigned char dow[7];
;
;}alert;
;alert a={0};
;#include <func.c>
; void send(unsigned char data);
; void gettime();
; void disp(unsigned char n);
; void fade(unsigned char ms);
; void insert_weeks(unsigned char dy);
; void paste_time(unsigned char s);
; void hardware_init();
; void paste_date();
; void send(unsigned char data);
; void paste_year();
; void settime();
; unsigned char eeprom_write(unsigned int address, unsigned char data);
; unsigned char eeprom_read(unsigned int address);
; void read_alerts();
; void write_alerts();
;
;void send(unsigned char data)
; 0000 0055  {

	.CSEG
_send:
;SPDR=data | (sec_led<<7); //data & 0xff;
;	data -> Y+0
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	MOV  R30,R26
	ROR  R30
	LDI  R30,0
	ROR  R30
	LD   R26,Y
	OR   R30,R26
	OUT  0xF,R30
;while (!(SPSR & (1 << SPIF)));
_0x5:
	SBIC 0xE,7
	RJMP _0x7
	RJMP _0x5
_0x7:
;WRI;
	SBI  0x15,1
	CBI  0x15,1
;}
	ADIW R28,1
	RET
;
;void settime()
;{
_settime:
;  rtc_set_time(t.hour,t.min,t.sec);
	__GETB1MN _t,2
	ST   -Y,R30
	__GETB1MN _t,1
	ST   -Y,R30
	LDS  R30,_t
	ST   -Y,R30
	RCALL _rtc_set_time
;  rtc_set_date(t.dow,t.date,t.month,t.year);
	__GETB1MN _t,3
	ST   -Y,R30
	__GETB1MN _t,4
	ST   -Y,R30
	__GETB1MN _t,5
	ST   -Y,R30
	__GETB1MN _t,6
	ST   -Y,R30
	RCALL _rtc_set_date
;}
	RET
;
; void gettime()
; {
_gettime:
;  if(time_start){
	SBRS R2,3
	RJMP _0xC
;  rtc_get_time(&t.hour,&t.min,&t.sec);
	__POINTW1MN _t,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _t,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_t)
	LDI  R31,HIGH(_t)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rtc_get_time
;  rtc_get_date(&t.dow,&t.date,&t.month,&t.year);
	__POINTW1MN _t,3
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _t,4
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _t,5
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _t,6
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rtc_get_date
;  time_start=0;
	CLT
	BLD  R2,3
;  }
; }
_0xC:
	RET
;
;void disp(unsigned char n)
;{
_disp:
;n = abs(n);
;	n -> Y+0
	LD   R30,Y
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _abs
	ST   Y,R30
;send( (alph)?chars[n]:n );
	SBRS R2,4
	RJMP _0xD
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_chars*2)
	SBCI R31,HIGH(-_chars*2)
	LPM  R30,Z
	RJMP _0xE
_0xD:
	LD   R30,Y
_0xE:
_0xF:
	ST   -Y,R30
	RCALL _send
;}
	ADIW R28,1
	RET
;
; void fade(unsigned char ms)
; {
_fade:
;unsigned  int j=0,i=0;
;for (j=0 ; j<light_var; j++ ) { LIGHT(j); delay_ms(1);}
	RCALL __SAVELOCR4
;	ms -> Y+4
;	j -> R16,R17
;	i -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 16,17,0
_0x11:
	LDS  R30,_light_var
	LDS  R31,_light_var+1
	CP   R16,R30
	CPC  R17,R31
	BRLO PC+2
	RJMP _0x12
	MOVW R30,R16
	ANDI R30,LOW(0xFF00)
	MOV  R30,R31
	LDI  R31,0
	OUT  0x2B,R30
	MOV  R30,R16
	OUT  0x2A,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
_0x10:
	__ADDWRN 16,17,1
	RJMP _0x11
_0x12:
;for (i=0; i<ms; i++) {   gettime();  if(sec_en) paste_time(0);   delay_ms(1000); while(b_menu || !B1 || !B2); } ;
	__GETWRN 18,19,0
_0x14:
	LDD  R30,Y+4
	MOVW R26,R18
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRLO PC+2
	RJMP _0x15
	RCALL _gettime
	SBRS R2,5
	RJMP _0x16
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _paste_time
_0x16:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
_0x17:
	SBRC R2,6
	RJMP _0x1A
	SBIS 0x16,6
	RJMP _0x1A
	SBIS 0x10,4
	RJMP _0x1A
	RJMP _0x19
_0x1A:
	RJMP _0x17
_0x19:
_0x13:
	__ADDWRN 18,19,1
	RJMP _0x14
_0x15:
;for (j=light_var; j>0; j-- ) { LIGHT(j); delay_ms(1);}
	__GETWRMN 16,17,0,_light_var
_0x1D:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRLO PC+2
	RJMP _0x1E
	MOVW R30,R16
	ANDI R30,LOW(0xFF00)
	MOV  R30,R31
	LDI  R31,0
	OUT  0x2B,R30
	MOV  R30,R16
	OUT  0x2A,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
_0x1C:
	__SUBWRN 16,17,1
	RJMP _0x1D
_0x1E:
; }
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
;
;void insert_weeks(unsigned char dy)
;{
_insert_weeks:
;unsigned char i=0;
;d[0]=chars[0];
	ST   -Y,R17
;	dy -> Y+1
;	i -> R17
	LDI  R17,0
	LDI  R30,LOW(_chars*2)
	LDI  R31,HIGH(_chars*2)
	LPM  R0,Z
	STS  _d,R0
;d[1]=chars[dy];
	LDD  R30,Y+1
	LDI  R31,0
	SUBI R30,LOW(-_chars*2)
	SBCI R31,HIGH(-_chars*2)
	LPM  R0,Z
	__PUTBR0MN _d,1
;for(i=0; i<2; i++)
	LDI  R17,LOW(0)
_0x20:
	CPI  R17,2
	BRLO PC+2
	RJMP _0x21
;{
;d[i+2]=weeks[dy-1][i];
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _d,2
	MOVW R0,R30
	LDD  R30,Y+1
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(_weeks*2)
	LDI  R27,HIGH(_weeks*2)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R0
	ST   X,R30
;}
_0x1F:
	SUBI R17,-1
	RJMP _0x20
_0x21:
;}
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
; void paste_time(unsigned char s)
; {
_paste_time:
; if(s) { d[0]=a.hour/10;
;	s -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE PC+2
	RJMP _0x22
	__GETB2MN _a,1
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	STS  _d,R30
; d[1]=a.hour%10;
	__GETB2MN _a,1
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTB1MN _d,1
;  d[2]=a.min/10;
	LDS  R26,_a
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	__PUTB1MN _d,2
;  d[3]=a.min%10;} else {
	LDS  R26,_a
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTB1MN _d,3
	RJMP _0x23
_0x22:
;      d[0]=t.hour/10;
	__GETB2MN _t,2
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	STS  _d,R30
; d[1]=t.hour%10;
	__GETB2MN _t,2
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTB1MN _d,1
;  d[2]=t.min/10;
	__GETB2MN _t,1
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	__PUTB1MN _d,2
;  d[3]=t.min%10;
	__GETB2MN _t,1
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTB1MN _d,3
;  }
_0x23:
; }
	ADIW R28,1
	RET
;
; void paste_date()
; {
_paste_date:
; d[0]=t.date/10;
	__GETB2MN _t,4
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	STS  _d,R30
;d[1]=t.date%10;
	__GETB2MN _t,4
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTB1MN _d,1
;d[2]=t.month/10;
	__GETB2MN _t,5
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	__PUTB1MN _d,2
;d[3]=t.month%10;
	__GETB2MN _t,5
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTB1MN _d,3
; }
	RET
; void paste_year(){
_paste_year:
;d[0]=2;
	LDI  R30,LOW(2)
	STS  _d,R30
;d[1]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _d,1
;d[2]=t.year/10;
	__GETB2MN _t,6
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	__PUTB1MN _d,2
;d[3]=t.year%10;
	__GETB2MN _t,6
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTB1MN _d,3
;}
	RET
; void hardware_init()
; {
_hardware_init:
;PORTB=0xC0;
	LDI  R30,LOW(192)
	OUT  0x18,R30
;DDRB=0x2E;
	LDI  R30,LOW(46)
	OUT  0x17,R30
;PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;DDRC=0x7F;
	LDI  R30,LOW(127)
	OUT  0x14,R30
;PORTD=0x10;
	LDI  R30,LOW(16)
	OUT  0x12,R30
;DDRD=0x20;
	LDI  R30,LOW(32)
	OUT  0x11,R30
;TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
;TCNT0=0x00;
	OUT  0x32,R30
;TCCR1A=0x83;
	LDI  R30,LOW(131)
	OUT  0x2F,R30
;TCCR1B=0x09;
	LDI  R30,LOW(9)
	OUT  0x2E,R30
;TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;TCNT1L=0x00;
	OUT  0x2C,R30
;ICR1H=0x00;
	OUT  0x27,R30
;ICR1L=0x00;
	OUT  0x26,R30
;OCR1AH=0x00;
	OUT  0x2B,R30
;OCR1AL=0x00;
	OUT  0x2A,R30
;OCR1BH=0x02;
	LDI  R30,LOW(2)
	OUT  0x29,R30
;OCR1BL=0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
;ASSR=0x00;
	OUT  0x22,R30
;TCCR2=0x07;
	LDI  R30,LOW(7)
	OUT  0x25,R30
;TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
;OCR2=0x00;
	OUT  0x23,R30
;GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
;MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
;GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
;TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x39,R30
;UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
;ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;ADCSRA=0x00;
	OUT  0x6,R30
;SPCR=0x51;
	LDI  R30,LOW(81)
	OUT  0xD,R30
;SPSR=0;
	LDI  R30,LOW(0)
	OUT  0xE,R30
;TWCR=0x00;
	OUT  0x36,R30
;}
	RET
;
;unsigned char eeprom_read(unsigned int address) //Функция чтения из внешней EEPROM
;{
_eeprom_read:
;unsigned char data;
;i2c_start();                       //Кидаем команду "Cтарт" на шину I2C
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
	RCALL _i2c_start
;i2c_write(Ext_EEPROM_Adr);         //Кидаем на шину адрес 24LC512
	LDI  R30,LOW(160)
	ST   -Y,R30
	RCALL _i2c_write
;i2c_write(address>>8);               //Старший байт адресного пространства 24LC512
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _i2c_write
;i2c_write(address & 0xFF);               //Младший байт
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _i2c_write
;i2c_start();                       //Снова посылаем "старт" в шину
	RCALL _i2c_start
;i2c_write(Ext_EEPROM_Adr | 1);     //Обращаемся к 24LC512 в режиме чтения, т.е. по адресу 101000001
	LDI  R30,LOW(161)
	ST   -Y,R30
	RCALL _i2c_write
;data=i2c_read(0);                  //Принимаем данные с шины и сохраняем в переменную
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _i2c_read
	MOV  R17,R30
;i2c_stop();                        //Посылаем команду "Cтоп"
	RCALL _i2c_stop
;return data;                       //Возвращаем значение прочитанного
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,3
	RET
;}
;
;
;unsigned char eeprom_write(unsigned int address, unsigned char data) //Функция записи во внешнюю EEPROM
;{
_eeprom_write:
;i2c_start();                           //Кидаем команду "Cтарт" на шину I2C
;	address -> Y+1
;	data -> Y+0
	RCALL _i2c_start
;i2c_write(Ext_EEPROM_Adr);             //Кидаем на шину адрес 24LC512
	LDI  R30,LOW(160)
	ST   -Y,R30
	RCALL _i2c_write
;i2c_write(address>>8);                   //Старший байт адресного пространства 24LC512
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _i2c_write
;i2c_write(address & 0xFF);                   //Младший байт
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _i2c_write
;if(!i2c_write(data )) return 0;
	LD   R30,Y
	ST   -Y,R30
	RCALL _i2c_write
	CPI  R30,0
	BREQ PC+2
	RJMP _0x24
	LDI  R30,LOW(0)
	ADIW R28,3
	RET
;i2c_stop();                          //Посылаем команду "Стоп"
_0x24:
	RCALL _i2c_stop
;delay_ms(5);                           //Даем микросхеме время записать данные, EEPROM довольно медлительна
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
;return 1;
	LDI  R30,LOW(1)
	ADIW R28,3
	RET
;}
;
;void read_alerts()
;{
_read_alerts:
;unsigned char i=0;
;a.min=eeprom_read(0);
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _eeprom_read
	STS  _a,R30
;a.hour=eeprom_read(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _eeprom_read
	__PUTB1MN _a,1
;a.ae=eeprom_read(2);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _eeprom_read
	__PUTB1MN _a,2
;for (i=3; i<10; i++) a.dow[i-3]=eeprom_read(i);
	LDI  R17,LOW(3)
_0x26:
	CPI  R17,10
	BRLO PC+2
	RJMP _0x27
	__POINTW2MN _a,3
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,3
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _eeprom_read
	POP  R26
	POP  R27
	ST   X,R30
_0x25:
	SUBI R17,-1
	RJMP _0x26
_0x27:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _eeprom_read
	STS  _t_delay,R30
;}
	LD   R17,Y+
	RET
;
;void write_alerts()
;{
_write_alerts:
;eeprom_write(0,a.min);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_a
	ST   -Y,R30
	RCALL _eeprom_write
;eeprom_write(1,a.hour);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _a,1
	ST   -Y,R30
	RCALL _eeprom_write
;eeprom_write(2,a.ae);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _a,2
	ST   -Y,R30
	RCALL _eeprom_write
;for (i=3; i<10; i++) eeprom_write(i, a.dow[i-3]);
	LDI  R30,LOW(3)
	MOV  R4,R30
_0x29:
	LDI  R30,LOW(10)
	CP   R4,R30
	BRLO PC+2
	RJMP _0x2A
	MOV  R30,R4
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _a,3
	MOV  R30,R4
	LDI  R31,0
	SBIW R30,3
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RCALL _eeprom_write
_0x28:
	INC  R4
	RJMP _0x29
_0x2A:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_t_delay
	ST   -Y,R30
	RCALL _eeprom_write
;}
	RET
;
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0058 {
_ext_int0_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0059 sec_led=(sec_led^1) & sec_en;
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R26,R30
	LDI  R30,0
	SBRC R2,5
	LDI  R30,1
	AND  R30,R26
	RCALL __BSTB1
	BLD  R2,2
; 0000 005A time_start=1;
	SET
	BLD  R2,3
; 0000 005B if(a.ae) if( a.dow[t.dow-1] && t.hour==a.hour && !BEEP_START) {  if( t.min==a.min  && !BEEP_DIS && !b_menu)  { BEEP_START=1;} }  else  BEEP_DIS=0;
	__GETB1MN _a,2
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2B
	__POINTW2MN _a,3
	__GETB1MN _t,3
	LDI  R31,0
	SBIW R30,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2D
	__GETB2MN _t,2
	__GETB1MN _a,1
	CP   R30,R26
	BREQ PC+2
	RJMP _0x2D
	SBRC R2,1
	RJMP _0x2D
	RJMP _0x2E
_0x2D:
	RJMP _0x2C
_0x2E:
	__GETB2MN _t,1
	LDS  R30,_a
	CP   R30,R26
	BREQ PC+2
	RJMP _0x30
	SBRC R2,0
	RJMP _0x30
	SBRC R2,6
	RJMP _0x30
	RJMP _0x31
_0x30:
	RJMP _0x2F
_0x31:
	SET
	BLD  R2,1
_0x2F:
	RJMP _0x32
_0x2C:
	CLT
	BLD  R2,0
; 0000 005C if(BEEP_START) if(t.min > a.min+5 || (!B1&&!B2) || t.hour!=a.hour || !a.dow[t.dow-1] || !a.ae) { BEEP_START=0; BEEP(0);  BEEP_DIS=1;}
_0x32:
_0x2B:
	SBRS R2,1
	RJMP _0x33
	__GETB2MN _t,1
	LDS  R30,_a
	LDI  R31,0
	ADIW R30,5
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRGE PC+2
	RJMP _0x35
	SBIC 0x16,6
	RJMP _0x36
	SBIC 0x10,4
	RJMP _0x36
	RJMP _0x35
_0x36:
	__GETB2MN _t,2
	__GETB1MN _a,1
	CP   R30,R26
	BREQ PC+2
	RJMP _0x35
	__POINTW2MN _a,3
	__GETB1MN _t,3
	LDI  R31,0
	SBIW R30,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BRNE PC+2
	RJMP _0x35
	__GETB1MN _a,2
	CPI  R30,0
	BRNE PC+2
	RJMP _0x35
	RJMP _0x34
_0x35:
	CLT
	BLD  R2,1
	LDI  R30,LOW(131)
	OUT  0x2F,R30
	SET
	BLD  R2,0
; 0000 005D }
_0x34:
_0x33:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0060 {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0061 send(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _send
; 0000 0062 L1=L2=L3=L4=0;
	CBI  0x15,2
	CBI  0x15,3
	CBI  0x15,4
	CBI  0x15,5
; 0000 0063 switch (step)
	LDS  R30,_step
	LDI  R31,0
; 0000 0064 {
; 0000 0065 case 0: L1=1; L2=L3=L4=0; break;
	SBIW R30,0
	BREQ PC+2
	RJMP _0x44
	SBI  0x15,5
	CBI  0x15,2
	CBI  0x15,3
	CBI  0x15,4
	RJMP _0x43
; 0000 0066 case 1: L2=1; L1=L3=L4=0; break;
_0x44:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x4D
	SBI  0x15,4
	CBI  0x15,2
	CBI  0x15,3
	CBI  0x15,5
	RJMP _0x43
; 0000 0067 case 2: L3=1; L1=L2=L4=0; break;
_0x4D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x56
	SBI  0x15,3
	CBI  0x15,2
	CBI  0x15,4
	CBI  0x15,5
	RJMP _0x43
; 0000 0068 case 3: L4=1; L1=L2=L3=0; break;
_0x56:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x43
	SBI  0x15,2
	CBI  0x15,3
	CBI  0x15,4
	CBI  0x15,5
; 0000 0069 }
_0x43:
; 0000 006A disp(d[step]) ;
	LDS  R30,_step
	LDI  R31,0
	SUBI R30,LOW(-_d)
	SBCI R31,HIGH(-_d)
	LD   R30,Z
	ST   -Y,R30
	RCALL _disp
; 0000 006B step=(step<3)?(step+1):0;
	LDS  R26,_step
	CPI  R26,LOW(0x3)
	BRLO PC+2
	RJMP _0x68
	LDS  R30,_step
	LDI  R31,0
	ADIW R30,1
	RJMP _0x69
_0x68:
	LDI  R30,LOW(0)
_0x69:
_0x6A:
	STS  _step,R30
; 0000 006C }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 006E {
_timer2_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 006F 
; 0000 0070 
; 0000 0071 if(BEEP_START) { i=(i>128)?0:(i+1); if(i% ( 12/( (t.min - a.min)+1 )) ==0)  { BEEP(1); } else  BEEP(0); }
	SBRS R2,1
	RJMP _0x6B
	LDI  R30,LOW(128)
	CP   R30,R4
	BRLO PC+2
	RJMP _0x6C
	LDI  R30,LOW(0)
	RJMP _0x6D
_0x6C:
	MOV  R30,R4
	LDI  R31,0
	ADIW R30,1
_0x6D:
_0x6E:
	MOV  R4,R30
	MOV  R22,R4
	CLR  R23
	__GETB2MN _t,1
	CLR  R27
	LDS  R30,_a
	LDI  R31,0
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	ADIW R30,1
	LDI  R26,LOW(12)
	LDI  R27,HIGH(12)
	RCALL __DIVW21
	MOVW R26,R22
	RCALL __MODW21
	SBIW R30,0
	BREQ PC+2
	RJMP _0x6F
	LDI  R30,LOW(163)
	OUT  0x2F,R30
	RJMP _0x70
_0x6F:
	LDI  R30,LOW(131)
	OUT  0x2F,R30
_0x70:
; 0000 0072 if(!MENU && B1 && B2) {
_0x6B:
	SBIC 0x16,7
	RJMP _0x72
	SBIS 0x16,6
	RJMP _0x72
	SBIS 0x10,4
	RJMP _0x72
	RJMP _0x73
_0x72:
	RJMP _0x71
_0x73:
; 0000 0073 
; 0000 0074 FAD(4);
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 0075 menu_var++;
	INC  R5
; 0000 0076 delay_ms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0077 sec_en=sec_led=0;
	CLT
	BLD  R2,2
	BLD  R2,5
; 0000 0078 b_menu=alph=1;
	SET
	BLD  R2,4
	BLD  R2,6
; 0000 0079  }
; 0000 007A   if(!B1 && !B2 && !MENU)#asm("RJMP 0");
_0x71:
	SBIC 0x16,6
	RJMP _0x75
	SBIC 0x10,4
	RJMP _0x75
	SBIC 0x16,7
	RJMP _0x75
	RJMP _0x76
_0x75:
	RJMP _0x74
_0x76:
	RJMP 0
; 0000 007B if(!b_menu && MENU) {
_0x74:
	SBRC R2,6
	RJMP _0x78
	SBIS 0x16,7
	RJMP _0x78
	RJMP _0x79
_0x78:
	RJMP _0x77
_0x79:
; 0000 007C  if(!B1)  light_var = (light_var>=1023)?1023:(light_var+8);
	SBIC 0x16,6
	RJMP _0x7A
	LDS  R26,_light_var
	LDS  R27,_light_var+1
	CPI  R26,LOW(0x3FF)
	LDI  R30,HIGH(0x3FF)
	CPC  R27,R30
	BRSH PC+2
	RJMP _0x7B
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	RJMP _0x7C
_0x7B:
	LDS  R30,_light_var
	LDS  R31,_light_var+1
	ADIW R30,8
_0x7C:
_0x7D:
	STS  _light_var,R30
	STS  _light_var+1,R31
; 0000 007D if(!B2)  light_var = (light_var<=8)?0:(light_var-8);
_0x7A:
	SBIC 0x10,4
	RJMP _0x7E
	LDS  R26,_light_var
	LDS  R27,_light_var+1
	SBIW R26,9
	BRLO PC+2
	RJMP _0x7F
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x80
_0x7F:
	LDS  R30,_light_var
	LDS  R31,_light_var+1
	SBIW R30,8
_0x80:
_0x81:
	STS  _light_var,R30
	STS  _light_var+1,R31
; 0000 007E if(!B1 || !B2)  {
_0x7E:
	SBIS 0x16,6
	RJMP _0x83
	SBIS 0x10,4
	RJMP _0x83
	RJMP _0x82
_0x83:
; 0000 007F alph=1;
	SET
	BLD  R2,4
; 0000 0080 d[0]=( (int) light_var/100 ) /10;
	LDS  R26,_light_var
	LDS  R27,_light_var+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	STS  _d,R30
; 0000 0081 d[1]=( (int) light_var/100 ) %10;
	LDS  R26,_light_var
	LDS  R27,_light_var+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTB1MN _d,1
; 0000 0082 d[2]=( (int) light_var%100 ) /10;
	LDS  R26,_light_var
	LDS  R27,_light_var+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	__PUTB1MN _d,2
; 0000 0083 d[3]=( (int) light_var%100 ) %10;
	LDS  R26,_light_var
	LDS  R27,_light_var+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTB1MN _d,3
; 0000 0084 LIGHT(light_var);
	LDS  R30,_light_var
	LDS  R31,_light_var+1
	ANDI R30,LOW(0xFF00)
	MOV  R30,R31
	LDI  R31,0
	OUT  0x2B,R30
	LDS  R30,_light_var
	OUT  0x2A,R30
; 0000 0085  }
; 0000 0086 }
_0x82:
; 0000 0087 if(!MENU && !B1 && B2) {a.ae=1; d[0]=0;d[1]=13;d[2]=10;d[3]=10;write_alerts(); }
_0x77:
	SBIC 0x16,7
	RJMP _0x86
	SBIC 0x16,6
	RJMP _0x86
	SBIS 0x10,4
	RJMP _0x86
	RJMP _0x87
_0x86:
	RJMP _0x85
_0x87:
	LDI  R30,LOW(1)
	__PUTB1MN _a,2
	LDI  R30,LOW(0)
	STS  _d,R30
	LDI  R30,LOW(13)
	__PUTB1MN _d,1
	LDI  R30,LOW(10)
	__PUTB1MN _d,2
	__PUTB1MN _d,3
	RCALL _write_alerts
; 0000 0088 if(!MENU && B1 && !B2) {a.ae=0; d[0]=0;d[1]=14;d[2]=14;d[3]=10;write_alerts();}
_0x85:
	SBIC 0x16,7
	RJMP _0x89
	SBIS 0x16,6
	RJMP _0x89
	SBIC 0x10,4
	RJMP _0x89
	RJMP _0x8A
_0x89:
	RJMP _0x88
_0x8A:
	LDI  R30,LOW(0)
	__PUTB1MN _a,2
	STS  _d,R30
	LDI  R30,LOW(14)
	__PUTB1MN _d,1
	__PUTB1MN _d,2
	LDI  R30,LOW(10)
	__PUTB1MN _d,3
	RCALL _write_alerts
; 0000 0089 if(menu_var) switch (menu_var)
_0x88:
	TST  R5
	BRNE PC+2
	RJMP _0x8B
	MOV  R30,R5
	LDI  R31,0
; 0000 008A {
; 0000 008B case 1: if(!B1){t.hour=t.hour>=23?0:t.hour+1;} if(!B2){t.hour=t.hour<=0?23:t.hour-1;}   paste_time(0); d[2]=d[3]=10;     break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x8F
	SBIC 0x16,6
	RJMP _0x90
	__GETB2MN _t,2
	CPI  R26,LOW(0x17)
	BRSH PC+2
	RJMP _0x91
	LDI  R30,LOW(0)
	RJMP _0x92
_0x91:
	__GETB1MN _t,2
	LDI  R31,0
	ADIW R30,1
_0x92:
_0x93:
	__PUTB1MN _t,2
_0x90:
	SBIC 0x10,4
	RJMP _0x94
	__GETB2MN _t,2
	CPI  R26,0
	BREQ PC+2
	RJMP _0x95
	LDI  R30,LOW(23)
	RJMP _0x96
_0x95:
	__GETB1MN _t,2
	LDI  R31,0
	SBIW R30,1
_0x96:
_0x97:
	__PUTB1MN _t,2
_0x94:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _paste_time
	LDI  R30,LOW(10)
	__PUTB1MN _d,3
	__PUTB1MN _d,2
	RJMP _0x8E
; 0000 008C case 2: if(!B1){t.min=t.min>=59?0:t.min+1;} if(!B2){t.min=t.min<=0?59:t.min-1;}  paste_time(0);  d[0]=d[1]=10;     break;
_0x8F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x98
	SBIC 0x16,6
	RJMP _0x99
	__GETB2MN _t,1
	CPI  R26,LOW(0x3B)
	BRSH PC+2
	RJMP _0x9A
	LDI  R30,LOW(0)
	RJMP _0x9B
_0x9A:
	__GETB1MN _t,1
	LDI  R31,0
	ADIW R30,1
_0x9B:
_0x9C:
	__PUTB1MN _t,1
_0x99:
	SBIC 0x10,4
	RJMP _0x9D
	__GETB2MN _t,1
	CPI  R26,0
	BREQ PC+2
	RJMP _0x9E
	LDI  R30,LOW(59)
	RJMP _0x9F
_0x9E:
	__GETB1MN _t,1
	LDI  R31,0
	SBIW R30,1
_0x9F:
_0xA0:
	__PUTB1MN _t,1
_0x9D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _paste_time
	LDI  R30,LOW(10)
	__PUTB1MN _d,1
	STS  _d,R30
	RJMP _0x8E
; 0000 008D case 3: if(!B1){t.dow=t.dow>=7?1:t.dow+1;} if(!B2){t.dow=t.dow<=1?7:t.dow-1;}  d[0]=0; d[1]=t.dow;     d[2]=d[3]=10;  break;
_0x98:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xA1
	SBIC 0x16,6
	RJMP _0xA2
	__GETB2MN _t,3
	CPI  R26,LOW(0x7)
	BRSH PC+2
	RJMP _0xA3
	LDI  R30,LOW(1)
	RJMP _0xA4
_0xA3:
	__GETB1MN _t,3
	LDI  R31,0
	ADIW R30,1
_0xA4:
_0xA5:
	__PUTB1MN _t,3
_0xA2:
	SBIC 0x10,4
	RJMP _0xA6
	__GETB2MN _t,3
	CPI  R26,LOW(0x2)
	BRLO PC+2
	RJMP _0xA7
	LDI  R30,LOW(7)
	RJMP _0xA8
_0xA7:
	__GETB1MN _t,3
	LDI  R31,0
	SBIW R30,1
_0xA8:
_0xA9:
	__PUTB1MN _t,3
_0xA6:
	LDI  R30,LOW(0)
	STS  _d,R30
	__GETB1MN _t,3
	__PUTB1MN _d,1
	LDI  R30,LOW(10)
	__PUTB1MN _d,3
	__PUTB1MN _d,2
	RJMP _0x8E
; 0000 008E case 4: if(!B1){t.date=t.date>=31?0:t.date+1;} if(!B2){t.date=t.date<=1?31:t.date-1;}   paste_date(); d[2]=d[3]=10;     break;
_0xA1:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xAA
	SBIC 0x16,6
	RJMP _0xAB
	__GETB2MN _t,4
	CPI  R26,LOW(0x1F)
	BRSH PC+2
	RJMP _0xAC
	LDI  R30,LOW(0)
	RJMP _0xAD
_0xAC:
	__GETB1MN _t,4
	LDI  R31,0
	ADIW R30,1
_0xAD:
_0xAE:
	__PUTB1MN _t,4
_0xAB:
	SBIC 0x10,4
	RJMP _0xAF
	__GETB2MN _t,4
	CPI  R26,LOW(0x2)
	BRLO PC+2
	RJMP _0xB0
	LDI  R30,LOW(31)
	RJMP _0xB1
_0xB0:
	__GETB1MN _t,4
	LDI  R31,0
	SBIW R30,1
_0xB1:
_0xB2:
	__PUTB1MN _t,4
_0xAF:
	RCALL _paste_date
	LDI  R30,LOW(10)
	__PUTB1MN _d,3
	__PUTB1MN _d,2
	RJMP _0x8E
; 0000 008F case 5: if(!B1){t.month=t.month>=12?1:t.month+1;} if(!B2){t.month=t.month<=1?12:t.month-1;}  paste_date();  d[0]=d[1]=10;     break;
_0xAA:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xB3
	SBIC 0x16,6
	RJMP _0xB4
	__GETB2MN _t,5
	CPI  R26,LOW(0xC)
	BRSH PC+2
	RJMP _0xB5
	LDI  R30,LOW(1)
	RJMP _0xB6
_0xB5:
	__GETB1MN _t,5
	LDI  R31,0
	ADIW R30,1
_0xB6:
_0xB7:
	__PUTB1MN _t,5
_0xB4:
	SBIC 0x10,4
	RJMP _0xB8
	__GETB2MN _t,5
	CPI  R26,LOW(0x2)
	BRLO PC+2
	RJMP _0xB9
	LDI  R30,LOW(12)
	RJMP _0xBA
_0xB9:
	__GETB1MN _t,5
	LDI  R31,0
	SBIW R30,1
_0xBA:
_0xBB:
	__PUTB1MN _t,5
_0xB8:
	RCALL _paste_date
	LDI  R30,LOW(10)
	__PUTB1MN _d,1
	STS  _d,R30
	RJMP _0x8E
; 0000 0090 case 6: if(!B1){t.year=t.year>=50?12:t.year+1;} if(!B2){t.year=t.year<=12?50:t.year-1;}  paste_year();      break;
_0xB3:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xBC
	SBIC 0x16,6
	RJMP _0xBD
	__GETB2MN _t,6
	CPI  R26,LOW(0x32)
	BRSH PC+2
	RJMP _0xBE
	LDI  R30,LOW(12)
	RJMP _0xBF
_0xBE:
	__GETB1MN _t,6
	LDI  R31,0
	ADIW R30,1
_0xBF:
_0xC0:
	__PUTB1MN _t,6
_0xBD:
	SBIC 0x10,4
	RJMP _0xC1
	__GETB2MN _t,6
	CPI  R26,LOW(0xD)
	BRLO PC+2
	RJMP _0xC2
	LDI  R30,LOW(50)
	RJMP _0xC3
_0xC2:
	__GETB1MN _t,6
	LDI  R31,0
	SBIW R30,1
_0xC3:
_0xC4:
	__PUTB1MN _t,6
_0xC1:
	RCALL _paste_year
	RJMP _0x8E
; 0000 0091 
; 0000 0092 case 7: if(!B1){t_delay=t_delay>=99?1:t_delay+1;} if(!B2){t_delay=t_delay<=1?99:t_delay-1;} d[0]=15;d[1]=16;d[2]=t_delay/10;d[3]=t_delay%10;   break;
_0xBC:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xC5
	SBIC 0x16,6
	RJMP _0xC6
	LDS  R26,_t_delay
	CPI  R26,LOW(0x63)
	BRSH PC+2
	RJMP _0xC7
	LDI  R30,LOW(1)
	RJMP _0xC8
_0xC7:
	LDS  R30,_t_delay
	LDI  R31,0
	ADIW R30,1
_0xC8:
_0xC9:
	STS  _t_delay,R30
_0xC6:
	SBIC 0x10,4
	RJMP _0xCA
	LDS  R26,_t_delay
	CPI  R26,LOW(0x2)
	BRLO PC+2
	RJMP _0xCB
	LDI  R30,LOW(99)
	RJMP _0xCC
_0xCB:
	LDS  R30,_t_delay
	LDI  R31,0
	SBIW R30,1
_0xCC:
_0xCD:
	STS  _t_delay,R30
_0xCA:
	LDI  R30,LOW(15)
	STS  _d,R30
	LDI  R30,LOW(16)
	__PUTB1MN _d,1
	LDS  R26,_t_delay
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	__PUTB1MN _d,2
	LDS  R26,_t_delay
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTB1MN _d,3
	RJMP _0x8E
; 0000 0093 
; 0000 0094 case 8: if(!B1) a.ae=1; if(!B2) a.ae=0;  if(a.ae) {d[0]=0;d[1]=13;d[2]=10;d[3]=10;} else {d[0]=0;d[1]=14;d[2]=14;d[3]=10;}  break;
_0xC5:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xCE
	SBIC 0x16,6
	RJMP _0xCF
	LDI  R30,LOW(1)
	__PUTB1MN _a,2
_0xCF:
	SBIC 0x10,4
	RJMP _0xD0
	LDI  R30,LOW(0)
	__PUTB1MN _a,2
_0xD0:
	__GETB1MN _a,2
	CPI  R30,0
	BRNE PC+2
	RJMP _0xD1
	LDI  R30,LOW(0)
	STS  _d,R30
	LDI  R30,LOW(13)
	__PUTB1MN _d,1
	LDI  R30,LOW(10)
	__PUTB1MN _d,2
	__PUTB1MN _d,3
	RJMP _0xD2
_0xD1:
	LDI  R30,LOW(0)
	STS  _d,R30
	LDI  R30,LOW(14)
	__PUTB1MN _d,1
	__PUTB1MN _d,2
	LDI  R30,LOW(10)
	__PUTB1MN _d,3
_0xD2:
	RJMP _0x8E
; 0000 0095 
; 0000 0096 case 9:  if(!B1){a.hour=a.hour>=23?0:a.hour+1;} if(!B2){a.hour=a.hour<=0?23:a.hour-1;}   paste_time(1); d[2]=d[3]=10;     break;
_0xCE:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xD3
	SBIC 0x16,6
	RJMP _0xD4
	__GETB2MN _a,1
	CPI  R26,LOW(0x17)
	BRSH PC+2
	RJMP _0xD5
	LDI  R30,LOW(0)
	RJMP _0xD6
_0xD5:
	__GETB1MN _a,1
	LDI  R31,0
	ADIW R30,1
_0xD6:
_0xD7:
	__PUTB1MN _a,1
_0xD4:
	SBIC 0x10,4
	RJMP _0xD8
	__GETB2MN _a,1
	CPI  R26,0
	BREQ PC+2
	RJMP _0xD9
	LDI  R30,LOW(23)
	RJMP _0xDA
_0xD9:
	__GETB1MN _a,1
	LDI  R31,0
	SBIW R30,1
_0xDA:
_0xDB:
	__PUTB1MN _a,1
_0xD8:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _paste_time
	LDI  R30,LOW(10)
	__PUTB1MN _d,3
	__PUTB1MN _d,2
	RJMP _0x8E
; 0000 0097 case 10: if(!B1){a.min=a.min>=59?0:a.min+1;} if(!B2){a.min=a.min<=0?59:a.min-1;}  paste_time(1);  d[0]=d[1]=10;     break;
_0xD3:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xDC
	SBIC 0x16,6
	RJMP _0xDD
	LDS  R26,_a
	CPI  R26,LOW(0x3B)
	BRSH PC+2
	RJMP _0xDE
	LDI  R30,LOW(0)
	RJMP _0xDF
_0xDE:
	LDS  R30,_a
	LDI  R31,0
	ADIW R30,1
_0xDF:
_0xE0:
	STS  _a,R30
_0xDD:
	SBIC 0x10,4
	RJMP _0xE1
	LDS  R26,_a
	CPI  R26,0
	BREQ PC+2
	RJMP _0xE2
	LDI  R30,LOW(59)
	RJMP _0xE3
_0xE2:
	LDS  R30,_a
	LDI  R31,0
	SBIW R30,1
_0xE3:
_0xE4:
	STS  _a,R30
_0xE1:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _paste_time
	LDI  R30,LOW(10)
	__PUTB1MN _d,1
	STS  _d,R30
	RJMP _0x8E
; 0000 0098 
; 0000 0099 case 11:   if(!B1) a.dow[0]=1;if(!B2) a.dow[0]=0;  d[0]=0; d[1]=1; d[2]=0; d[3]=a.dow[0];    break;
_0xDC:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xE5
	SBIC 0x16,6
	RJMP _0xE6
	LDI  R30,LOW(1)
	__PUTB1MN _a,3
_0xE6:
	SBIC 0x10,4
	RJMP _0xE7
	LDI  R30,LOW(0)
	__PUTB1MN _a,3
_0xE7:
	LDI  R30,LOW(0)
	STS  _d,R30
	LDI  R30,LOW(1)
	__PUTB1MN _d,1
	LDI  R30,LOW(0)
	__PUTB1MN _d,2
	__GETB1MN _a,3
	__PUTB1MN _d,3
	RJMP _0x8E
; 0000 009A case 12:   if(!B1) a.dow[1]=1;if(!B2) a.dow[1]=0;  d[0]=0; d[1]=2; d[2]=0; d[3]=a.dow[1];    break;
_0xE5:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xE8
	SBIC 0x16,6
	RJMP _0xE9
	LDI  R30,LOW(1)
	__PUTB1MN _a,4
_0xE9:
	SBIC 0x10,4
	RJMP _0xEA
	LDI  R30,LOW(0)
	__PUTB1MN _a,4
_0xEA:
	LDI  R30,LOW(0)
	STS  _d,R30
	LDI  R30,LOW(2)
	__PUTB1MN _d,1
	LDI  R30,LOW(0)
	__PUTB1MN _d,2
	__GETB1MN _a,4
	__PUTB1MN _d,3
	RJMP _0x8E
; 0000 009B case 13:   if(!B1) a.dow[2]=1;if(!B2) a.dow[2]=0;  d[0]=0; d[1]=3; d[2]=0; d[3]=a.dow[2];    break;
_0xE8:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xEB
	SBIC 0x16,6
	RJMP _0xEC
	LDI  R30,LOW(1)
	__PUTB1MN _a,5
_0xEC:
	SBIC 0x10,4
	RJMP _0xED
	LDI  R30,LOW(0)
	__PUTB1MN _a,5
_0xED:
	LDI  R30,LOW(0)
	STS  _d,R30
	LDI  R30,LOW(3)
	__PUTB1MN _d,1
	LDI  R30,LOW(0)
	__PUTB1MN _d,2
	__GETB1MN _a,5
	__PUTB1MN _d,3
	RJMP _0x8E
; 0000 009C case 14:   if(!B1) a.dow[3]=1;if(!B2) a.dow[3]=0;  d[0]=0; d[1]=4; d[2]=0; d[3]=a.dow[3];    break;
_0xEB:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xEE
	SBIC 0x16,6
	RJMP _0xEF
	LDI  R30,LOW(1)
	__PUTB1MN _a,6
_0xEF:
	SBIC 0x10,4
	RJMP _0xF0
	LDI  R30,LOW(0)
	__PUTB1MN _a,6
_0xF0:
	LDI  R30,LOW(0)
	STS  _d,R30
	LDI  R30,LOW(4)
	__PUTB1MN _d,1
	LDI  R30,LOW(0)
	__PUTB1MN _d,2
	__GETB1MN _a,6
	__PUTB1MN _d,3
	RJMP _0x8E
; 0000 009D case 15:   if(!B1) a.dow[4]=1;if(!B2) a.dow[4]=0;  d[0]=0; d[1]=5; d[2]=0; d[3]=a.dow[4];    break;
_0xEE:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xF1
	SBIC 0x16,6
	RJMP _0xF2
	LDI  R30,LOW(1)
	__PUTB1MN _a,7
_0xF2:
	SBIC 0x10,4
	RJMP _0xF3
	LDI  R30,LOW(0)
	__PUTB1MN _a,7
_0xF3:
	LDI  R30,LOW(0)
	STS  _d,R30
	LDI  R30,LOW(5)
	__PUTB1MN _d,1
	LDI  R30,LOW(0)
	__PUTB1MN _d,2
	__GETB1MN _a,7
	__PUTB1MN _d,3
	RJMP _0x8E
; 0000 009E case 16:   if(!B1) a.dow[5]=1;if(!B2) a.dow[5]=0;  d[0]=0; d[1]=6; d[2]=0; d[3]=a.dow[5];    break;
_0xF1:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xF4
	SBIC 0x16,6
	RJMP _0xF5
	LDI  R30,LOW(1)
	__PUTB1MN _a,8
_0xF5:
	SBIC 0x10,4
	RJMP _0xF6
	LDI  R30,LOW(0)
	__PUTB1MN _a,8
_0xF6:
	LDI  R30,LOW(0)
	STS  _d,R30
	LDI  R30,LOW(6)
	__PUTB1MN _d,1
	LDI  R30,LOW(0)
	__PUTB1MN _d,2
	__GETB1MN _a,8
	__PUTB1MN _d,3
	RJMP _0x8E
; 0000 009F case 17:   if(!B1) a.dow[6]=1;if(!B2) a.dow[6]=0;  d[0]=0; d[1]=7; d[2]=0; d[3]=a.dow[6];    break;
_0xF4:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xF7
	SBIC 0x16,6
	RJMP _0xF8
	LDI  R30,LOW(1)
	__PUTB1MN _a,9
_0xF8:
	SBIC 0x10,4
	RJMP _0xF9
	LDI  R30,LOW(0)
	__PUTB1MN _a,9
_0xF9:
	LDI  R30,LOW(0)
	STS  _d,R30
	LDI  R30,LOW(7)
	__PUTB1MN _d,1
	LDI  R30,LOW(0)
	__PUTB1MN _d,2
	__GETB1MN _a,9
	__PUTB1MN _d,3
	RJMP _0x8E
; 0000 00A0 
; 0000 00A1 case 18: menu_var=b_menu=0; t.sec=0; settime(); write_alerts();  #asm("RJMP 0");  break;
_0xF7:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x8E
	CLT
	BLD  R2,6
	CLR  R5
	LDI  R30,LOW(0)
	STS  _t,R30
	RCALL _settime
	RCALL _write_alerts
	RJMP 0
; 0000 00A2 }
_0x8E:
; 0000 00A3 
; 0000 00A4 
; 0000 00A5 }
_0x8B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;void main(void)
; 0000 00A8 {
_main:
; 0000 00A9 signed int temper=0;
; 0000 00AA unsigned char count=0;
; 0000 00AB 
; 0000 00AC hardware_init();
;	temper -> R16,R17
;	count -> R19
	__GETWRN 16,17,0
	LDI  R19,0
	RCALL _hardware_init
; 0000 00AD LIGHT(0);
	LDI  R30,LOW(0)
	OUT  0x2B,R30
	OUT  0x2A,R30
; 0000 00AE send(0);
	ST   -Y,R30
	RCALL _send
; 0000 00AF 
; 0000 00B0 i2c_init();
	RCALL _i2c_init
; 0000 00B1 rtc_init(0,1,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _rtc_init
; 0000 00B2 
; 0000 00B3 w1_init();
	RCALL _w1_init
; 0000 00B4 DS=1; ds18b20_init(0,-30,80,DS18B20_9BIT_RES);  DS=0;
	SBI  0x12,5
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(226)
	ST   -Y,R30
	LDI  R30,LOW(80)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _ds18b20_init
	CBI  0x12,5
; 0000 00B5 FAD(3);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 00B6  read_alerts();
	RCALL _read_alerts
; 0000 00B7 #asm("sei")
	sei
; 0000 00B8 
; 0000 00B9 sec_led=1;
	SET
	BLD  R2,2
; 0000 00BA d[0]=d[1]=d[2]=d[3]=8;
	LDI  R30,LOW(8)
	__PUTB1MN _d,3
	__PUTB1MN _d,2
	__PUTB1MN _d,1
	STS  _d,R30
; 0000 00BB fade(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _fade
; 0000 00BC 
; 0000 00BD while (1)
_0xFF:
; 0000 00BE       {
; 0000 00BF gettime();
	RCALL _gettime
; 0000 00C0 count=0;
	LDI  R19,LOW(0)
; 0000 00C1 DS=1;while(  (temper=(int)ds18b20_temperature(0)) && (temper<-30 || temper>80) && count++<200 ) delay_ms(50);  DS=0;
	SBI  0x12,5
_0x104:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_temperature
	RCALL __CFD1
	MOVW R16,R30
	SBIW R30,0
	BRNE PC+2
	RJMP _0x107
	__CPWRN 16,17,-30
	BRGE PC+2
	RJMP _0x108
	__CPWRN 16,17,81
	BRLT PC+2
	RJMP _0x108
	RJMP _0x107
_0x108:
	MOV  R26,R19
	SUBI R19,-1
	CPI  R26,LOW(0xC8)
	BRLO PC+2
	RJMP _0x107
	RJMP _0x10A
_0x107:
	RJMP _0x106
_0x10A:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	RJMP _0x104
_0x106:
	CBI  0x12,5
; 0000 00C2 d[2]=12;
	LDI  R30,LOW(12)
	__PUTB1MN _d,2
; 0000 00C3 d[3]=10;
	LDI  R30,LOW(10)
	__PUTB1MN _d,3
; 0000 00C4 d[0]=temper/10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	STS  _d,R30
; 0000 00C5 d[1]=temper%10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTB1MN _d,1
; 0000 00C6 fade(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _fade
; 0000 00C7 
; 0000 00C8 sec_en=1;
	SET
	BLD  R2,5
; 0000 00C9 
; 0000 00CA paste_time(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _paste_time
; 0000 00CB fade(t_delay);
	LDS  R30,_t_delay
	ST   -Y,R30
	RCALL _fade
; 0000 00CC sec_en=sec_led=0;
	CLT
	BLD  R2,2
	BLD  R2,5
; 0000 00CD 
; 0000 00CE insert_weeks(t.dow);
	__GETB1MN _t,3
	ST   -Y,R30
	RCALL _insert_weeks
; 0000 00CF alph=0;
	CLT
	BLD  R2,4
; 0000 00D0 fade(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _fade
; 0000 00D1 alph=1;
	SET
	BLD  R2,4
; 0000 00D2 
; 0000 00D3 paste_date();
	RCALL _paste_date
; 0000 00D4 fade(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _fade
; 0000 00D5 
; 0000 00D6 paste_year();
	RCALL _paste_year
; 0000 00D7 fade(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _fade
; 0000 00D8 
; 0000 00D9 if(( ( a.dow[t.dow-1]  && (a.hour>=t.hour  && a.min>=t.min  ) )
; 0000 00DA  ||  a.dow[ (t.dow>7)?0:t.dow ] ) && a.ae )
	__POINTW2MN _a,3
	__GETB1MN _t,3
	LDI  R31,0
	SBIW R30,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BRNE PC+2
	RJMP _0x10E
	__GETB2MN _a,1
	__GETB1MN _t,2
	CP   R26,R30
	BRSH PC+2
	RJMP _0x10F
	__GETB1MN _t,1
	LDS  R26,_a
	CP   R26,R30
	BRSH PC+2
	RJMP _0x10F
	RJMP _0x110
_0x10F:
	RJMP _0x10E
_0x110:
	RJMP _0x112
_0x10E:
	__GETB2MN _t,3
	CLR  R27
	SBIW R26,8
	BRGE PC+2
	RJMP _0x113
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x114
_0x113:
	__GETB1MN _t,3
	LDI  R31,0
_0x114:
_0x115:
	__ADDW1MN _a,3
	LD   R30,Z
	CPI  R30,0
	BREQ PC+2
	RJMP _0x112
	RJMP _0x117
_0x112:
	__GETB1MN _a,2
	CPI  R30,0
	BRNE PC+2
	RJMP _0x117
	RJMP _0x118
_0x117:
	RJMP _0x10D
_0x118:
; 0000 00DB {
; 0000 00DC  d[0]=0;
	LDI  R30,LOW(0)
	STS  _d,R30
; 0000 00DD  d[1]=13;
	LDI  R30,LOW(13)
	__PUTB1MN _d,1
; 0000 00DE  d[2]=10;
	LDI  R30,LOW(10)
	__PUTB1MN _d,2
; 0000 00DF  d[3]=10;
	__PUTB1MN _d,3
; 0000 00E0  fade(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _fade
; 0000 00E1 paste_time(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _paste_time
; 0000 00E2 fade(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _fade
; 0000 00E3 
; 0000 00E4 }
; 0000 00E5 
; 0000 00E6      }
_0x10D:
	RJMP _0xFF
_0x101:
; 0000 00E7 }
_0x119:
	RJMP _0x119
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_abs:
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret

	.DSEG

	.CSEG

	.CSEG
_ds18b20_select:
	ST   -Y,R17
	RCALL _w1_init
	CPI  R30,0
	BREQ PC+2
	RJMP _0x2040003
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	ADIW R28,3
	RET
_0x2040003:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BRNE PC+2
	RJMP _0x2040004
	LDI  R30,LOW(85)
	ST   -Y,R30
	RCALL _w1_write
	LDI  R17,LOW(0)
_0x2040006:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	ST   -Y,R30
	RCALL _w1_write
_0x2040005:
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO PC+2
	RJMP _0x2040007
	RJMP _0x2040006
_0x2040007:
	RJMP _0x2040008
_0x2040004:
	LDI  R30,LOW(204)
	ST   -Y,R30
	RCALL _w1_write
_0x2040008:
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	ADIW R28,3
	RET
_ds18b20_read_spd:
	RCALL __SAVELOCR4
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BREQ PC+2
	RJMP _0x2040009
	LDI  R30,LOW(0)
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
_0x2040009:
	LDI  R30,LOW(190)
	ST   -Y,R30
	RCALL _w1_write
	LDI  R17,LOW(0)
	__POINTWRM 18,19,___ds18b20_scratch_pad
_0x204000B:
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	RCALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
_0x204000A:
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO PC+2
	RJMP _0x204000C
	RJMP _0x204000B
_0x204000C:
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	RCALL _w1_dow_crc8
	RCALL __LNEGB1
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
_ds18b20_temperature:
	ST   -Y,R17
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BREQ PC+2
	RJMP _0x204000D
	__GETD1N 0xC61C3C00
	LDD  R17,Y+0
	ADIW R28,3
	RET
_0x204000D:
	__GETB2MN ___ds18b20_scratch_pad,4
	LDI  R27,0
	LDI  R30,LOW(5)
	RCALL __ASRW12
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BREQ PC+2
	RJMP _0x204000E
	__GETD1N 0xC61C3C00
	LDD  R17,Y+0
	ADIW R28,3
	RET
_0x204000E:
	LDI  R30,LOW(68)
	ST   -Y,R30
	RCALL _w1_write
	MOV  R30,R17
	LDI  R26,LOW(_conv_delay_G102*2)
	LDI  R27,HIGH(_conv_delay_G102*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETW1PF
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BREQ PC+2
	RJMP _0x204000F
	__GETD1N 0xC61C3C00
	LDD  R17,Y+0
	ADIW R28,3
	RET
_0x204000F:
	RCALL _w1_init
	MOV  R30,R17
	LDI  R26,LOW(_bit_mask_G102*2)
	LDI  R27,HIGH(_bit_mask_G102*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETW1PF
	LDS  R26,___ds18b20_scratch_pad
	LDS  R27,___ds18b20_scratch_pad+1
	AND  R30,R26
	AND  R31,R27
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3D800000
	RCALL __MULF12
	LDD  R17,Y+0
	ADIW R28,3
	RET
_ds18b20_init:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BREQ PC+2
	RJMP _0x2040010
	LDI  R30,LOW(0)
	ADIW R28,5
	RET
_0x2040010:
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
	LDI  R30,LOW(78)
	ST   -Y,R30
	RCALL _w1_write
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _w1_write
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _w1_write
	LD   R30,Y
	ST   -Y,R30
	RCALL _w1_write
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BREQ PC+2
	RJMP _0x2040011
	LDI  R30,LOW(0)
	ADIW R28,5
	RET
_0x2040011:
	__GETB2MN ___ds18b20_scratch_pad,3
	LDD  R30,Y+2
	CP   R30,R26
	BREQ PC+2
	RJMP _0x2040013
	__GETB2MN ___ds18b20_scratch_pad,2
	LDD  R30,Y+1
	CP   R30,R26
	BREQ PC+2
	RJMP _0x2040013
	__GETB2MN ___ds18b20_scratch_pad,4
	LD   R30,Y
	CP   R30,R26
	BREQ PC+2
	RJMP _0x2040013
	RJMP _0x2040012
_0x2040013:
	LDI  R30,LOW(0)
	ADIW R28,5
	RET
_0x2040012:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BREQ PC+2
	RJMP _0x2040015
	LDI  R30,LOW(0)
	ADIW R28,5
	RET
_0x2040015:
	LDI  R30,LOW(72)
	ST   -Y,R30
	RCALL _w1_write
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	RCALL _w1_init
	ADIW R28,5
	RET

	.CSEG
_rtc_init:
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2060003:
	LD   R30,Y
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2060004:
	RCALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _i2c_write
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _i2c_write
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _i2c_write
	RCALL _i2c_stop
	ADIW R28,3
	RET
_rtc_get_time:
	RCALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _i2c_write
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _i2c_write
	RCALL _i2c_start
	LDI  R30,LOW(209)
	ST   -Y,R30
	RCALL _i2c_write
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,6
	RET
_rtc_set_time:
	RCALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _i2c_write
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _i2c_write
	LD   R30,Y
	ST   -Y,R30
	RCALL _bin2bcd
	ST   -Y,R30
	RCALL _i2c_write
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _bin2bcd
	ST   -Y,R30
	RCALL _i2c_write
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _bin2bcd
	ST   -Y,R30
	RCALL _i2c_write
	RCALL _i2c_stop
	ADIW R28,3
	RET
_rtc_get_date:
	RCALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _i2c_write
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _i2c_write
	RCALL _i2c_start
	LDI  R30,LOW(209)
	ST   -Y,R30
	RCALL _i2c_write
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,8
	RET
_rtc_set_date:
	RCALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _i2c_write
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _i2c_write
	LDD  R30,Y+3
	ST   -Y,R30
	RCALL _bin2bcd
	ST   -Y,R30
	RCALL _i2c_write
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _bin2bcd
	ST   -Y,R30
	RCALL _i2c_write
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _bin2bcd
	ST   -Y,R30
	RCALL _i2c_write
	LD   R30,Y
	ST   -Y,R30
	RCALL _bin2bcd
	ST   -Y,R30
	RCALL _i2c_write
	RCALL _i2c_stop
	ADIW R28,4
	RET

	.CSEG

	.CSEG

	.CSEG

	.CSEG
_bcd2bin:
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
_bin2bcd:
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9
_d:
	.BYTE 0x4
_t_delay:
	.BYTE 0x1
_step:
	.BYTE 0x1
_light_var:
	.BYTE 0x2
_t:
	.BYTE 0x7
_a:
	.BYTE 0xA
__seed_G101:
	.BYTE 0x4

	.CSEG

	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,7
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,13
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x3E8
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x1E0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x13
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0x65
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x186
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x3
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xF
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0x6B
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x3
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x11
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0x64
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x7
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	ldi  r22,8
	ld   r23,y+
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_dow_crc8:
	clr  r30
	ld   r24,y
	tst  r24
	breq __w1_dow_crc83
	ldi  r22,0x18
	ldd  r26,y+1
	ldd  r27,y+2
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,3
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
