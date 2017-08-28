
_Numero:
;LED Dice.c,49 :: 		unsigned char Numero(int Lim, int Y)
;LED Dice.c,54 :: 		Y = (Y * 32718 + 3) % 32749;
	MOVF       Numero_Y_L0+0, 0
	MOVWF      R0+0
	MOVF       Numero_Y_L0+1, 0
	MOVWF      R0+1
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
	MOVF       R0+0, 0
	MOVWF      Numero_Y_L0+0
	MOVF       R0+1, 0
	MOVWF      Numero_Y_L0+1
;LED Dice.c,55 :: 		Result = ((Y % Lim) + 1);
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
;LED Dice.c,56 :: 		return Result;
;LED Dice.c,57 :: 		}
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
;LED Dice.c,59 :: 		interrupt()
;LED Dice.c,61 :: 		GPIF_bit = 0;
	BCF        GPIF_bit+0, 0
;LED Dice.c,62 :: 		bot1 = Botao1;
	MOVLW      0
	BTFSC      GPIO+0, 4
	MOVLW      1
	MOVWF      _bot1+0
;LED Dice.c,63 :: 		bot2 = Botao2;
	MOVLW      0
	BTFSC      GPIO+0, 3
	MOVLW      1
	MOVWF      _bot2+0
;LED Dice.c,64 :: 		}
L__interrupt11:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:
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
	MOVLW      1
	MOVWF      main_min_L0+0
;LED Dice.c,66 :: 		void main ()
;LED Dice.c,76 :: 		GPIO   = 0;                          //Desligar todos os LEDs
	CLRF       GPIO+0
;LED Dice.c,77 :: 		TRISIO = 0b011000;                   //Portas GP4 e GP3 são entrada
	MOVLW      24
	MOVWF      TRISIO+0
;LED Dice.c,78 :: 		OSCCAL = 0x38;
	MOVLW      56
	MOVWF      OSCCAL+0
;LED Dice.c,79 :: 		IOC = 0x18;
	MOVLW      24
	MOVWF      IOC+0
;LED Dice.c,80 :: 		INTCON = 0xC8;
	MOVLW      200
	MOVWF      INTCON+0
;LED Dice.c,83 :: 		for (;;)                             //Loop infinito
L_main0:
;LED Dice.c,86 :: 		if (bot1 == 0)
	MOVF       _bot1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;LED Dice.c,88 :: 		for(i = 0; i<4; i++)
	CLRF       main_i_L0+0
L_main4:
	MOVLW      4
	SUBWF      main_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main5
;LED Dice.c,90 :: 		J = Numero(6,min);
	MOVLW      6
	MOVWF      FARG_Numero_Lim+0
	MOVLW      0
	MOVWF      FARG_Numero_Lim+1
	MOVF       main_min_L0+0, 0
	MOVWF      FARG_Numero_Y+0
	CLRF       FARG_Numero_Y+1
	CALL       _Numero+0
;LED Dice.c,91 :: 		Pattern = DADO[J];          //Pegar padrao dos LEDs
	MOVF       R0+0, 0
	ADDLW      main_DADO_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      main_Pattern_L0+0
;LED Dice.c,92 :: 		GPIO = Pattern;             //Ligar LEDs correspondentes
	MOVF       R0+0, 0
	MOVWF      GPIO+0
;LED Dice.c,93 :: 		Delay_ms(400);              //Atraso de 400ms
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
;LED Dice.c,94 :: 		GPIO = 0;                   //Desligar todos os LEDs
	CLRF       GPIO+0
;LED Dice.c,88 :: 		for(i = 0; i<4; i++)
	INCF       main_i_L0+0, 1
;LED Dice.c,95 :: 		}
	GOTO       L_main4
L_main5:
;LED Dice.c,96 :: 		J = Numero(6,min);
	MOVLW      6
	MOVWF      FARG_Numero_Lim+0
	MOVLW      0
	MOVWF      FARG_Numero_Lim+1
	MOVF       main_min_L0+0, 0
	MOVWF      FARG_Numero_Y+0
	CLRF       FARG_Numero_Y+1
	CALL       _Numero+0
;LED Dice.c,97 :: 		Pattern = DADO[J];          //Pegar padrao dos LEDs
	MOVF       R0+0, 0
	ADDLW      main_DADO_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      main_Pattern_L0+0
;LED Dice.c,98 :: 		GPIO = Pattern;             //Ligar LEDs correspondentes
	MOVF       R0+0, 0
	MOVWF      GPIO+0
;LED Dice.c,99 :: 		Delay_ms(2500);             //Atraso de 2 segundos
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
	NOP
;LED Dice.c,100 :: 		GPIO = 0;                   //Desligar todos os LEDs
	CLRF       GPIO+0
;LED Dice.c,102 :: 		}
L_main3:
;LED Dice.c,105 :: 		if (bot2 == 0)
	MOVF       _bot2+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main9
;LED Dice.c,107 :: 		GPIO = Pattern;             //Ligar LEDs correspondentes
	MOVF       main_Pattern_L0+0, 0
	MOVWF      GPIO+0
;LED Dice.c,108 :: 		Delay_ms(2000);             //Atraso de 3 segundos
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main10:
	DECFSZ     R13+0, 1
	GOTO       L_main10
	DECFSZ     R12+0, 1
	GOTO       L_main10
	DECFSZ     R11+0, 1
	GOTO       L_main10
	NOP
	NOP
;LED Dice.c,109 :: 		GPIO = 0;                   //Desligar todos os LEDs
	CLRF       GPIO+0
;LED Dice.c,110 :: 		}
L_main9:
;LED Dice.c,113 :: 		asm SLEEP;
	SLEEP
;LED Dice.c,118 :: 		}
	GOTO       L_main0
;LED Dice.c,120 :: 		}
	GOTO       $+0
; end of _main
