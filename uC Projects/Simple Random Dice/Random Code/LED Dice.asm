
_Numero:

;LED Dice.c,50 :: 		unsigned char Numero(int Lim, int Y)
;LED Dice.c,54 :: 		Y = X + TMR0;
	MOVF       TMR0+0, 0
	ADDWF      _X+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
;LED Dice.c,55 :: 		Y = (Y * 32718 + 3) % 32749;
	MOVLW      206
	MOVWF      R4+0
	MOVLW      127
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVLW      3
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      237
	MOVWF      R4+0
	MOVLW      127
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
;LED Dice.c,56 :: 		Result = ((Y % Lim) + 1);
	MOVF       FARG_Numero_Lim+0, 0
	MOVWF      R4+0
	MOVF       FARG_Numero_Lim+1, 0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	INCF       R0+0, 1
;LED Dice.c,57 :: 		return Result;
;LED Dice.c,58 :: 		}
	RETURN
; end of _Numero

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;LED Dice.c,60 :: 		void interrupt()
;LED Dice.c,62 :: 		if (T0IF_bit) {
	BTFSS      T0IF_bit+0, 2
	GOTO       L_interrupt0
;LED Dice.c,63 :: 		T0IF_bit = 0;        // clear TMR0IF
	BCF        T0IF_bit+0, 2
;LED Dice.c,65 :: 		}
L_interrupt0:
;LED Dice.c,66 :: 		if (GPIF_bit) {
	BTFSS      GPIF_bit+0, 0
	GOTO       L_interrupt1
;LED Dice.c,67 :: 		GPIF_bit = 0;
	BCF        GPIF_bit+0, 0
;LED Dice.c,68 :: 		bot1 = Botao1;
	MOVLW      0
	BTFSC      GPIO+0, 4
	MOVLW      1
	MOVWF      _bot1+0
;LED Dice.c,69 :: 		bot2 = Botao2;
	MOVLW      0
	BTFSC      GPIO+0, 3
	MOVLW      1
	MOVWF      _bot2+0
;LED Dice.c,70 :: 		}
L_interrupt1:
;LED Dice.c,71 :: 		}
L__interrupt14:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;LED Dice.c,73 :: 		void main ()
;LED Dice.c,78 :: 		unsigned char min = 1;
	MOVLW      1
	MOVWF      main_min_L0+0
	CLRF       main_DADO_L0+0
	MOVLW      1
	MOVWF      main_DADO_L0+1
	MOVLW      4
	MOVWF      main_DADO_L0+2
	MOVLW      5
	MOVWF      main_DADO_L0+3
	MOVLW      34
	MOVWF      main_DADO_L0+4
	MOVLW      35
	MOVWF      main_DADO_L0+5
	MOVLW      38
	MOVWF      main_DADO_L0+6
;LED Dice.c,83 :: 		GPIO   = 0;                          //Desligar todos os LEDs
	CLRF       GPIO+0
;LED Dice.c,84 :: 		TRISIO = 0b011000;                   //Portas GP4 e GP3 são entrada
	MOVLW      24
	MOVWF      TRISIO+0
;LED Dice.c,85 :: 		OSCCAL = 0x38;
	MOVLW      56
	MOVWF      OSCCAL+0
;LED Dice.c,86 :: 		IOC = 0x18;
	MOVLW      24
	MOVWF      IOC+0
;LED Dice.c,87 :: 		INTCON = 0xE8;
	MOVLW      232
	MOVWF      INTCON+0
;LED Dice.c,89 :: 		T0CS_bit = 0;
	BCF        T0CS_bit+0, 5
;LED Dice.c,90 :: 		T0SE_bit = 0;
	BCF        T0SE_bit+0, 4
;LED Dice.c,91 :: 		PSA_bit = 0;
	BCF        PSA_bit+0, 3
;LED Dice.c,92 :: 		PS2_bit = 0;
	BCF        PS2_bit+0, 2
;LED Dice.c,93 :: 		PS1_bit = 0;
	BCF        PS1_bit+0, 1
;LED Dice.c,94 :: 		PS0_bit = 0;
	BCF        PS0_bit+0, 0
;LED Dice.c,97 :: 		for (;;)                             //Loop infinito
L_main2:
;LED Dice.c,100 :: 		if (bot1 == 0)
	MOVF       _bot1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;LED Dice.c,102 :: 		for(i = 0; i<2; i++)
	CLRF       main_i_L0+0
L_main6:
	MOVLW      2
	SUBWF      main_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main7
;LED Dice.c,104 :: 		J = Numero(6,min);
	MOVLW      6
	MOVWF      FARG_Numero_Lim+0
	MOVLW      0
	MOVWF      FARG_Numero_Lim+1
	MOVF       main_min_L0+0, 0
	MOVWF      FARG_Numero_Y+0
	CLRF       FARG_Numero_Y+1
	CALL       _Numero+0
;LED Dice.c,105 :: 		Pattern = DADO[J];          //Pegar padrao dos LEDs
	MOVF       R0+0, 0
	ADDLW      main_DADO_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      main_Pattern_L0+0
;LED Dice.c,106 :: 		GPIO = Pattern;             //Ligar LEDs correspondentes
	MOVF       R0+0, 0
	MOVWF      GPIO+0
;LED Dice.c,107 :: 		Delay_ms(400);              //Atraso de 400ms
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
;LED Dice.c,108 :: 		GPIO = 0;                   //Desligar todos os LEDs
	CLRF       GPIO+0
;LED Dice.c,102 :: 		for(i = 0; i<2; i++)
	INCF       main_i_L0+0, 1
;LED Dice.c,109 :: 		}
	GOTO       L_main6
L_main7:
;LED Dice.c,110 :: 		J = Numero(6,min);
	MOVLW      6
	MOVWF      FARG_Numero_Lim+0
	MOVLW      0
	MOVWF      FARG_Numero_Lim+1
	MOVF       main_min_L0+0, 0
	MOVWF      FARG_Numero_Y+0
	CLRF       FARG_Numero_Y+1
	CALL       _Numero+0
;LED Dice.c,111 :: 		Pattern = DADO[J];          //Pegar padrao dos LEDs
	MOVF       R0+0, 0
	ADDLW      main_DADO_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      main_Pattern_L0+0
;LED Dice.c,112 :: 		GPIO = Pattern;             //Ligar LEDs correspondentes
	MOVF       R0+0, 0
	MOVWF      GPIO+0
;LED Dice.c,113 :: 		Delay_ms(2500);             //Atraso de 2 segundos
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main10:
	DECFSZ     R13+0, 1
	GOTO       L_main10
	DECFSZ     R12+0, 1
	GOTO       L_main10
	DECFSZ     R11+0, 1
	GOTO       L_main10
	NOP
;LED Dice.c,114 :: 		GPIO = 0;                   //Desligar todos os LEDs
	CLRF       GPIO+0
;LED Dice.c,116 :: 		}
L_main5:
;LED Dice.c,119 :: 		if (bot2 == 0)
	MOVF       _bot2+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main11
;LED Dice.c,121 :: 		GPIO = Pattern;             //Ligar LEDs correspondentes
	MOVF       main_Pattern_L0+0, 0
	MOVWF      GPIO+0
;LED Dice.c,122 :: 		Delay_ms(1000);             //Atraso de 3 segundos
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main12:
	DECFSZ     R13+0, 1
	GOTO       L_main12
	DECFSZ     R12+0, 1
	GOTO       L_main12
	DECFSZ     R11+0, 1
	GOTO       L_main12
	NOP
	NOP
;LED Dice.c,123 :: 		GPIO = 0;                   //Desligar todos os LEDs
	CLRF       GPIO+0
;LED Dice.c,124 :: 		}
L_main11:
;LED Dice.c,129 :: 		X++;                          //Soma o contador
	INCF       _X+0, 1
;LED Dice.c,130 :: 		if(X == 7) X = 1;             //Mantem a contagem de 1 a 6
	MOVF       _X+0, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L_main13
	MOVLW      1
	MOVWF      _X+0
L_main13:
;LED Dice.c,132 :: 		}
	GOTO       L_main2
;LED Dice.c,134 :: 		}
	GOTO       $+0
; end of _main
