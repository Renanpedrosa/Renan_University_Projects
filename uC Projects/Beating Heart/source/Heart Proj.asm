
_Delay1000ms:

;Heart Proj.c,31 :: 		void Delay1000ms()
;Heart Proj.c,33 :: 		Delay_ms(1000);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_Delay1000ms0:
	DECFSZ     R13+0, 1
	GOTO       L_Delay1000ms0
	DECFSZ     R12+0, 1
	GOTO       L_Delay1000ms0
	DECFSZ     R11+0, 1
	GOTO       L_Delay1000ms0
	NOP
	NOP
;Heart Proj.c,34 :: 		}
L_end_Delay1000ms:
	RETURN
; end of _Delay1000ms

_main:

;Heart Proj.c,43 :: 		void main() {
;Heart Proj.c,45 :: 		GPIO   = 0;
	CLRF       GPIO+0
;Heart Proj.c,46 :: 		TRISIO = 0x01;              // Configura GPIO 0 para entrada
	MOVLW      1
	MOVWF      TRISIO+0
;Heart Proj.c,47 :: 		ANSEL  = 0x01;              // Configure AN0 pin as analog
	MOVLW      1
	MOVWF      ANSEL+0
;Heart Proj.c,48 :: 		CMCON  = 0x07;              // Disable comparators
	MOVLW      7
	MOVWF      CMCON+0
;Heart Proj.c,58 :: 		delay_on = 50;
	MOVLW      50
	MOVWF      _delay_on+0
	MOVLW      0
	MOVWF      _delay_on+1
;Heart Proj.c,59 :: 		delay_1  = 10;
	MOVLW      10
	MOVWF      _delay_1+0
	MOVLW      0
	MOVWF      _delay_1+1
;Heart Proj.c,60 :: 		delay_2  = 3000;
	MOVLW      184
	MOVWF      _delay_2+0
	MOVLW      11
	MOVWF      _delay_2+1
;Heart Proj.c,62 :: 		Delay1000ms();
	CALL       _Delay1000ms+0
;Heart Proj.c,63 :: 		LED_1 = 1;
	BSF        GP1_bit+0, 1
;Heart Proj.c,64 :: 		Delay1000ms();
	CALL       _Delay1000ms+0
;Heart Proj.c,65 :: 		LED_2 = 1;
	BSF        GP2_bit+0, 2
;Heart Proj.c,66 :: 		Delay1000ms();
	CALL       _Delay1000ms+0
;Heart Proj.c,67 :: 		LED_3 = 1;
	BSF        GP4_bit+0, 4
;Heart Proj.c,68 :: 		Delay1000ms();
	CALL       _Delay1000ms+0
;Heart Proj.c,69 :: 		LED_4 = 1;
	BSF        GP5_bit+0, 5
;Heart Proj.c,70 :: 		Delay1000ms();
	CALL       _Delay1000ms+0
;Heart Proj.c,71 :: 		Delay1000ms();
	CALL       _Delay1000ms+0
;Heart Proj.c,72 :: 		LED_1 = 0;
	BCF        GP1_bit+0, 1
;Heart Proj.c,73 :: 		LED_2 = 0;
	BCF        GP2_bit+0, 2
;Heart Proj.c,74 :: 		LED_3 = 0;
	BCF        GP4_bit+0, 4
;Heart Proj.c,75 :: 		LED_4 = 0;
	BCF        GP5_bit+0, 5
;Heart Proj.c,76 :: 		Delay1000ms();
	CALL       _Delay1000ms+0
;Heart Proj.c,77 :: 		LED_1 = 1;
	BSF        GP1_bit+0, 1
;Heart Proj.c,78 :: 		LED_2 = 1;
	BSF        GP2_bit+0, 2
;Heart Proj.c,79 :: 		LED_3 = 1;
	BSF        GP4_bit+0, 4
;Heart Proj.c,80 :: 		LED_4 = 1;
	BSF        GP5_bit+0, 5
;Heart Proj.c,82 :: 		while(1)
L_main1:
;Heart Proj.c,84 :: 		NTC_Val = ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _NTC_Val+0
	MOVF       R0+1, 0
	MOVWF      _NTC_Val+1
;Heart Proj.c,85 :: 		if(NTC_Val >= Low_Low)
	MOVLW      1
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main19
	MOVLW      166
	SUBWF      R0+0, 0
L__main19:
	BTFSS      STATUS+0, 0
	GOTO       L_main3
;Heart Proj.c,87 :: 		delay_on = 50;
	MOVLW      50
	MOVWF      _delay_on+0
	MOVLW      0
	MOVWF      _delay_on+1
;Heart Proj.c,88 :: 		delay_1 = 200;
	MOVLW      200
	MOVWF      _delay_1+0
	CLRF       _delay_1+1
;Heart Proj.c,89 :: 		delay_2 = 3000;
	MOVLW      184
	MOVWF      _delay_2+0
	MOVLW      11
	MOVWF      _delay_2+1
;Heart Proj.c,90 :: 		normSt = 1;
	MOVLW      1
	MOVWF      _normSt+0
;Heart Proj.c,91 :: 		pulseSt = 0;
	CLRF       _pulseSt+0
;Heart Proj.c,92 :: 		}
	GOTO       L_main4
L_main3:
;Heart Proj.c,93 :: 		else if(NTC_Val >= Low)
	MOVLW      1
	SUBWF      _NTC_Val+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main20
	MOVLW      159
	SUBWF      _NTC_Val+0, 0
L__main20:
	BTFSS      STATUS+0, 0
	GOTO       L_main5
;Heart Proj.c,95 :: 		delay_on = 50;
	MOVLW      50
	MOVWF      _delay_on+0
	MOVLW      0
	MOVWF      _delay_on+1
;Heart Proj.c,96 :: 		delay_1 = 150;
	MOVLW      150
	MOVWF      _delay_1+0
	CLRF       _delay_1+1
;Heart Proj.c,97 :: 		delay_2 = 1500;
	MOVLW      220
	MOVWF      _delay_2+0
	MOVLW      5
	MOVWF      _delay_2+1
;Heart Proj.c,98 :: 		normSt = 1;
	MOVLW      1
	MOVWF      _normSt+0
;Heart Proj.c,99 :: 		pulseSt = 0;
	CLRF       _pulseSt+0
;Heart Proj.c,100 :: 		}
	GOTO       L_main6
L_main5:
;Heart Proj.c,101 :: 		else if(NTC_Val >= Med_Low)
	MOVLW      1
	SUBWF      _NTC_Val+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main21
	MOVLW      156
	SUBWF      _NTC_Val+0, 0
L__main21:
	BTFSS      STATUS+0, 0
	GOTO       L_main7
;Heart Proj.c,103 :: 		delay_on = 50;
	MOVLW      50
	MOVWF      _delay_on+0
	MOVLW      0
	MOVWF      _delay_on+1
;Heart Proj.c,104 :: 		delay_1 = 125;
	MOVLW      125
	MOVWF      _delay_1+0
	MOVLW      0
	MOVWF      _delay_1+1
;Heart Proj.c,105 :: 		delay_2 = 1000;
	MOVLW      232
	MOVWF      _delay_2+0
	MOVLW      3
	MOVWF      _delay_2+1
;Heart Proj.c,106 :: 		normSt = 0;
	CLRF       _normSt+0
;Heart Proj.c,107 :: 		pulseSt = 1;
	MOVLW      1
	MOVWF      _pulseSt+0
;Heart Proj.c,108 :: 		}
	GOTO       L_main8
L_main7:
;Heart Proj.c,109 :: 		else if(NTC_Val >= Medium)
	MOVLW      1
	SUBWF      _NTC_Val+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main22
	MOVLW      152
	SUBWF      _NTC_Val+0, 0
L__main22:
	BTFSS      STATUS+0, 0
	GOTO       L_main9
;Heart Proj.c,111 :: 		delay_on = 50;
	MOVLW      50
	MOVWF      _delay_on+0
	MOVLW      0
	MOVWF      _delay_on+1
;Heart Proj.c,112 :: 		delay_1 = 100;
	MOVLW      100
	MOVWF      _delay_1+0
	MOVLW      0
	MOVWF      _delay_1+1
;Heart Proj.c,113 :: 		delay_2 = 850;
	MOVLW      82
	MOVWF      _delay_2+0
	MOVLW      3
	MOVWF      _delay_2+1
;Heart Proj.c,114 :: 		normSt = 0;
	CLRF       _normSt+0
;Heart Proj.c,115 :: 		pulseSt = 1;
	MOVLW      1
	MOVWF      _pulseSt+0
;Heart Proj.c,116 :: 		}
	GOTO       L_main10
L_main9:
;Heart Proj.c,117 :: 		else if(NTC_Val >= Medium_Max)
	MOVLW      1
	SUBWF      _NTC_Val+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main23
	MOVLW      149
	SUBWF      _NTC_Val+0, 0
L__main23:
	BTFSS      STATUS+0, 0
	GOTO       L_main11
;Heart Proj.c,119 :: 		delay_on = 50;
	MOVLW      50
	MOVWF      _delay_on+0
	MOVLW      0
	MOVWF      _delay_on+1
;Heart Proj.c,120 :: 		delay_1 = 100;
	MOVLW      100
	MOVWF      _delay_1+0
	MOVLW      0
	MOVWF      _delay_1+1
;Heart Proj.c,121 :: 		delay_2 = 700;
	MOVLW      188
	MOVWF      _delay_2+0
	MOVLW      2
	MOVWF      _delay_2+1
;Heart Proj.c,122 :: 		normSt = 0;
	CLRF       _normSt+0
;Heart Proj.c,123 :: 		pulseSt = 1;
	MOVLW      1
	MOVWF      _pulseSt+0
;Heart Proj.c,124 :: 		}
	GOTO       L_main12
L_main11:
;Heart Proj.c,125 :: 		else if(NTC_Val >= Max)
	MOVLW      1
	SUBWF      _NTC_Val+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main24
	MOVLW      146
	SUBWF      _NTC_Val+0, 0
L__main24:
	BTFSS      STATUS+0, 0
	GOTO       L_main13
;Heart Proj.c,127 :: 		delay_on = 50;
	MOVLW      50
	MOVWF      _delay_on+0
	MOVLW      0
	MOVWF      _delay_on+1
;Heart Proj.c,128 :: 		delay_1 = 100;
	MOVLW      100
	MOVWF      _delay_1+0
	MOVLW      0
	MOVWF      _delay_1+1
;Heart Proj.c,129 :: 		delay_2 = 650;
	MOVLW      138
	MOVWF      _delay_2+0
	MOVLW      2
	MOVWF      _delay_2+1
;Heart Proj.c,130 :: 		normSt = 0;
	CLRF       _normSt+0
;Heart Proj.c,131 :: 		pulseSt = 1;
	MOVLW      1
	MOVWF      _pulseSt+0
;Heart Proj.c,132 :: 		}
	GOTO       L_main14
L_main13:
;Heart Proj.c,133 :: 		else if(NTC_Val >= Max_Max)
	MOVLW      1
	SUBWF      _NTC_Val+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main25
	MOVLW      142
	SUBWF      _NTC_Val+0, 0
L__main25:
	BTFSS      STATUS+0, 0
	GOTO       L_main15
;Heart Proj.c,135 :: 		delay_on = 50;
	MOVLW      50
	MOVWF      _delay_on+0
	MOVLW      0
	MOVWF      _delay_on+1
;Heart Proj.c,136 :: 		delay_1 = 100;
	MOVLW      100
	MOVWF      _delay_1+0
	MOVLW      0
	MOVWF      _delay_1+1
;Heart Proj.c,137 :: 		delay_2 = 500;
	MOVLW      244
	MOVWF      _delay_2+0
	MOVLW      1
	MOVWF      _delay_2+1
;Heart Proj.c,138 :: 		normSt = 0;
	CLRF       _normSt+0
;Heart Proj.c,139 :: 		pulseSt = 1;
	MOVLW      1
	MOVWF      _pulseSt+0
;Heart Proj.c,140 :: 		}
	GOTO       L_main16
L_main15:
;Heart Proj.c,143 :: 		delay_on = 50;
	MOVLW      50
	MOVWF      _delay_on+0
	MOVLW      0
	MOVWF      _delay_on+1
;Heart Proj.c,144 :: 		delay_1 = 100;
	MOVLW      100
	MOVWF      _delay_1+0
	MOVLW      0
	MOVWF      _delay_1+1
;Heart Proj.c,145 :: 		delay_2 = 100;
	MOVLW      100
	MOVWF      _delay_2+0
	MOVLW      0
	MOVWF      _delay_2+1
;Heart Proj.c,146 :: 		normSt = 0;
	CLRF       _normSt+0
;Heart Proj.c,147 :: 		pulseSt = 1;
	MOVLW      1
	MOVWF      _pulseSt+0
;Heart Proj.c,148 :: 		}
L_main16:
L_main14:
L_main12:
L_main10:
L_main8:
L_main6:
L_main4:
;Heart Proj.c,150 :: 		LED_1 = pulseSt;
	BTFSC      _pulseSt+0, 0
	GOTO       L__main26
	BCF        GP1_bit+0, 1
	GOTO       L__main27
L__main26:
	BSF        GP1_bit+0, 1
L__main27:
;Heart Proj.c,151 :: 		LED_2 = pulseSt;
	BTFSC      _pulseSt+0, 0
	GOTO       L__main28
	BCF        GP2_bit+0, 2
	GOTO       L__main29
L__main28:
	BSF        GP2_bit+0, 2
L__main29:
;Heart Proj.c,152 :: 		LED_3 = pulseSt;
	BTFSC      _pulseSt+0, 0
	GOTO       L__main30
	BCF        GP4_bit+0, 4
	GOTO       L__main31
L__main30:
	BSF        GP4_bit+0, 4
L__main31:
;Heart Proj.c,153 :: 		LED_4 = pulseSt;
	BTFSC      _pulseSt+0, 0
	GOTO       L__main32
	BCF        GP5_bit+0, 5
	GOTO       L__main33
L__main32:
	BSF        GP5_bit+0, 5
L__main33:
;Heart Proj.c,154 :: 		Vdelay_ms(delay_on);
	MOVF       _delay_on+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _delay_on+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;Heart Proj.c,155 :: 		LED_1 = normSt;
	BTFSC      _normSt+0, 0
	GOTO       L__main34
	BCF        GP1_bit+0, 1
	GOTO       L__main35
L__main34:
	BSF        GP1_bit+0, 1
L__main35:
;Heart Proj.c,156 :: 		LED_2 = normSt;
	BTFSC      _normSt+0, 0
	GOTO       L__main36
	BCF        GP2_bit+0, 2
	GOTO       L__main37
L__main36:
	BSF        GP2_bit+0, 2
L__main37:
;Heart Proj.c,157 :: 		LED_3 = normSt;
	BTFSC      _normSt+0, 0
	GOTO       L__main38
	BCF        GP4_bit+0, 4
	GOTO       L__main39
L__main38:
	BSF        GP4_bit+0, 4
L__main39:
;Heart Proj.c,158 :: 		LED_4 = normSt;
	BTFSC      _normSt+0, 0
	GOTO       L__main40
	BCF        GP5_bit+0, 5
	GOTO       L__main41
L__main40:
	BSF        GP5_bit+0, 5
L__main41:
;Heart Proj.c,159 :: 		Vdelay_ms(delay_1);
	MOVF       _delay_1+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _delay_1+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;Heart Proj.c,160 :: 		LED_1 = pulseSt;
	BTFSC      _pulseSt+0, 0
	GOTO       L__main42
	BCF        GP1_bit+0, 1
	GOTO       L__main43
L__main42:
	BSF        GP1_bit+0, 1
L__main43:
;Heart Proj.c,161 :: 		LED_2 = pulseSt;
	BTFSC      _pulseSt+0, 0
	GOTO       L__main44
	BCF        GP2_bit+0, 2
	GOTO       L__main45
L__main44:
	BSF        GP2_bit+0, 2
L__main45:
;Heart Proj.c,162 :: 		LED_3 = pulseSt;
	BTFSC      _pulseSt+0, 0
	GOTO       L__main46
	BCF        GP4_bit+0, 4
	GOTO       L__main47
L__main46:
	BSF        GP4_bit+0, 4
L__main47:
;Heart Proj.c,163 :: 		LED_4 = pulseSt;
	BTFSC      _pulseSt+0, 0
	GOTO       L__main48
	BCF        GP5_bit+0, 5
	GOTO       L__main49
L__main48:
	BSF        GP5_bit+0, 5
L__main49:
;Heart Proj.c,164 :: 		Vdelay_ms(delay_on);
	MOVF       _delay_on+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _delay_on+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;Heart Proj.c,165 :: 		LED_1 = normSt;
	BTFSC      _normSt+0, 0
	GOTO       L__main50
	BCF        GP1_bit+0, 1
	GOTO       L__main51
L__main50:
	BSF        GP1_bit+0, 1
L__main51:
;Heart Proj.c,166 :: 		LED_2 = normSt;
	BTFSC      _normSt+0, 0
	GOTO       L__main52
	BCF        GP2_bit+0, 2
	GOTO       L__main53
L__main52:
	BSF        GP2_bit+0, 2
L__main53:
;Heart Proj.c,167 :: 		LED_3 = normSt;
	BTFSC      _normSt+0, 0
	GOTO       L__main54
	BCF        GP4_bit+0, 4
	GOTO       L__main55
L__main54:
	BSF        GP4_bit+0, 4
L__main55:
;Heart Proj.c,168 :: 		LED_4 = normSt;
	BTFSC      _normSt+0, 0
	GOTO       L__main56
	BCF        GP5_bit+0, 5
	GOTO       L__main57
L__main56:
	BSF        GP5_bit+0, 5
L__main57:
;Heart Proj.c,169 :: 		Vdelay_ms(delay_2);
	MOVF       _delay_2+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _delay_2+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;Heart Proj.c,171 :: 		}
	GOTO       L_main1
;Heart Proj.c,176 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
