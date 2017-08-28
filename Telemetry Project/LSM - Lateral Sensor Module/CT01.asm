
_InputCapture1Int:
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;CT01.c,77 :: 		void InputCapture1Int() iv IVT_ADDR_IC1INTERRUPT //Roda transmissão ou outra roda
;CT01.c,79 :: 		t1=IC1BUF;
	MOV	IC1BUF, WREG
	MOV	W0, _t1
;CT01.c,80 :: 		t2=IC1BUF;
	MOV	IC1BUF, WREG
	MOV	W0, _t2
;CT01.c,81 :: 		IC1IF_bit=0;
	BCLR	IC1IF_bit, #1
;CT01.c,82 :: 		if(t2>t1)
	MOV	_t2, W1
	MOV	#lo_addr(_t1), W0
	CP	W1, [W0]
	BRA GTU	L__InputCapture1Int14
	GOTO	L_InputCapture1Int0
L__InputCapture1Int14:
;CT01.c,83 :: 		DIG1 = t2-t1;
	MOV	_t2, W2
	MOV	#lo_addr(_t1), W1
	MOV	#lo_addr(_DIG1), W0
	SUB	W2, [W1], [W0]
	GOTO	L_InputCapture1Int1
L_InputCapture1Int0:
;CT01.c,85 :: 		DIG1 = (PR2 - t1) + t2;
	MOV	PR2, W1
	MOV	#lo_addr(_t1), W0
	SUB	W1, [W0], W2
	MOV	#lo_addr(_t2), W1
	MOV	#lo_addr(_DIG1), W0
	ADD	W2, [W1], [W0]
L_InputCapture1Int1:
;CT01.c,86 :: 		}
L_end_InputCapture1Int:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	RETFIE
; end of _InputCapture1Int

_C1Interrupt:
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;CT01.c,88 :: 		void C1Interrupt(void) org 0x005A                            // ECAN event iterrupt
;CT01.c,91 :: 		IFS2bits.C1IF = 0;                                   // clear ECAN interrupt flag
	BCLR	IFS2bits, #3
;CT01.c,92 :: 		if(C1INTFbits.TBIF) {                                // was it tx interrupt?
	BTSS	C1INTFbits, #0
	GOTO	L_C1Interrupt2
;CT01.c,93 :: 		C1INTFbits.TBIF = 0;                             // if yes clear tx interrupt flag
	BCLR	C1INTFbits, #0
;CT01.c,94 :: 		LED = 1;
	BSET	LATA8_bit, #8
;CT01.c,95 :: 		}
L_C1Interrupt2:
;CT01.c,97 :: 		if(C1INTFbits.RBIF) {                                      // was it rx interrupt?
	BTSS	C1INTFbits, #1
	GOTO	L_C1Interrupt3
;CT01.c,98 :: 		C1INTFbits.RBIF = 0;                         // if yes clear rx interrupt flag
	BCLR	C1INTFbits, #1
;CT01.c,99 :: 		}
L_C1Interrupt3:
;CT01.c,100 :: 		}
L_end_C1Interrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	RETFIE
; end of _C1Interrupt

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;CT01.c,102 :: 		void main()
;CT01.c,104 :: 		LED = 1;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BSET	LATA8_bit, #8
;CT01.c,105 :: 		InitClock();
	CALL	_InitClock
;CT01.c,106 :: 		InitPorts();
	CALL	_InitPorts
;CT01.c,107 :: 		InitTimersCapture();
	CALL	_InitTimersCapture
;CT01.c,108 :: 		InitCAN();
	CALL	_InitCAN
;CT01.c,109 :: 		InitMain();
	CALL	_InitMain
;CT01.c,110 :: 		LED = 0;   //Se terminar de inicializar apaga o LED
	BCLR	LATA8_bit, #8
;CT01.c,112 :: 		Delay_ms(100);
	MOV	#21, W8
	MOV	#22619, W7
L_main4:
	DEC	W7
	BRA NZ	L_main4
	DEC	W8
	BRA NZ	L_main4
;CT01.c,113 :: 		LED = 1;
	BSET	LATA8_bit, #8
;CT01.c,114 :: 		Delay_ms(1000);
	MOV	#204, W8
	MOV	#29592, W7
L_main6:
	DEC	W7
	BRA NZ	L_main6
	DEC	W8
	BRA NZ	L_main6
;CT01.c,115 :: 		LED = 0;
	BCLR	LATA8_bit, #8
;CT01.c,119 :: 		_ECAN_TX_NO_RTR_FRAME;
	MOV	#244, W0
	MOV	W0, _Can_Send_Flags
;CT01.c,120 :: 		Delay_ms(100);
	MOV	#21, W8
	MOV	#22619, W7
L_main8:
	DEC	W7
	BRA NZ	L_main8
	DEC	W8
	BRA NZ	L_main8
;CT01.c,122 :: 		while(1)
L_main10:
;CT01.c,128 :: 		contagem ++;
	MOV	#1, W1
	MOV	#lo_addr(_contagem), W0
	ADD	W1, [W0], [W0]
;CT01.c,129 :: 		if (contagem >=14)
	MOV	_contagem, W0
	CP	W0, #14
	BRA GEU	L__main17
	GOTO	L_main12
L__main17:
;CT01.c,131 :: 		contagem = 8;
	MOV	#8, W0
	MOV	W0, _contagem
;CT01.c,132 :: 		}
L_main12:
;CT01.c,133 :: 		VDelay_ms(contagem);
	MOV	_contagem, W10
	CALL	_VDelay_ms
;CT01.c,136 :: 		ICAN_BUS = ADC1_Get_Sample(AN_ICAN_BUS);
	MOV	#6, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _ICAN_BUS
;CT01.c,137 :: 		GPIN0 = ADC1_Get_Sample(AN_GPIN0);
	CLR	W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _GPIN0
;CT01.c,138 :: 		GPIN1 = ADC1_Get_Sample(AN_GPIN1);
	MOV	#1, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _GPIN1
;CT01.c,139 :: 		GPIN2 = ADC1_Get_Sample(AN_GPIN2);
	MOV	#2, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _GPIN2
;CT01.c,140 :: 		GPIN3 = ADC1_Get_Sample(AN_GPIN3);
	MOV	#3, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _GPIN3
;CT01.c,141 :: 		GPIN4 = ADC1_Get_Sample(AN_GPIN4);
	MOV	#4, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _GPIN4
;CT01.c,142 :: 		GPIN5 = ADC1_Get_Sample(AN_GPIN5);
	MOV	#5, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _GPIN5
;CT01.c,145 :: 		PGA_Set_Channel(PGA_CH0);                //Canal 0
	CLR	W10
	CALL	_PGA_Set_Channel
;CT01.c,146 :: 		PGA0 = ADC1_Get_Sample(AN_PGA);
	MOV	#9, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _PGA0
;CT01.c,147 :: 		PGA0_Gain = 0;
	MOV	#lo_addr(_PGA0_Gain), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT01.c,149 :: 		PGA_Set_Channel(PGA_CH1);                //Canal 1
	MOV.B	#1, W10
	CALL	_PGA_Set_Channel
;CT01.c,150 :: 		PGA1 = ADC1_Get_Sample(AN_PGA);
	MOV	#9, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _PGA1
;CT01.c,151 :: 		PGA1_Gain = 0;
	MOV	#lo_addr(_PGA1_Gain), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT01.c,153 :: 		PGA_Set_Channel(PGA_CH2);                //Canal 2
	MOV.B	#2, W10
	CALL	_PGA_Set_Channel
;CT01.c,154 :: 		PGA2 = ADC1_Get_Sample(AN_PGA);
	MOV	#9, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _PGA2
;CT01.c,155 :: 		PGA2_Gain = 0;
	MOV	#lo_addr(_PGA2_Gain), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT01.c,157 :: 		PGA_Set_Channel(PGA_CH3);                //Canal 3
	MOV.B	#3, W10
	CALL	_PGA_Set_Channel
;CT01.c,158 :: 		PGA3 = ADC1_Get_Sample(AN_PGA);
	MOV	#9, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _PGA3
;CT01.c,159 :: 		PGA3_Gain = 0;
	MOV	#lo_addr(_PGA3_Gain), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT01.c,161 :: 		PGA_Set_Channel(PGA_CH4);                //Canal 4
	MOV.B	#4, W10
	CALL	_PGA_Set_Channel
;CT01.c,162 :: 		PGA4 = ADC1_Get_Sample(AN_PGA);
	MOV	#9, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _PGA4
;CT01.c,163 :: 		PGA4_Gain = 0;
	MOV	#lo_addr(_PGA4_Gain), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT01.c,165 :: 		PGA_Set_Channel(PGA_CH5);                //Canal 5
	MOV.B	#5, W10
	CALL	_PGA_Set_Channel
;CT01.c,166 :: 		PGA5 = ADC1_Get_Sample(AN_PGA);
	MOV	#9, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _PGA5
;CT01.c,167 :: 		PGA5_Gain = 0;
	MOV	#lo_addr(_PGA5_Gain), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT01.c,176 :: 		PGA_01_Gain = 1;
	MOV	#lo_addr(_PGA_01_Gain), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;CT01.c,177 :: 		PGA_23_Gain = 1;
	MOV	#lo_addr(_PGA_23_Gain), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;CT01.c,178 :: 		PGA_45_Gain = 1;
	MOV	#lo_addr(_PGA_45_Gain), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;CT01.c,181 :: 		LED = 0;
	BCLR	LATA8_bit, #8
;CT01.c,183 :: 		RxTx_Data[0] = Hi(ICAN_BUS);
	MOV	#lo_addr(_RxTx_Data), W1
	MOV	#lo_addr(_ICAN_BUS+1), W0
	MOV.B	[W0], [W1]
;CT01.c,184 :: 		RxTx_Data[1] = Lo(ICAN_BUS);
	MOV	#lo_addr(_RxTx_Data+1), W1
	MOV	#lo_addr(_ICAN_BUS), W0
	MOV.B	[W0], [W1]
;CT01.c,185 :: 		RxTx_Data[2] = Hi(GPIN0);
	MOV	#lo_addr(_RxTx_Data+2), W1
	MOV	#lo_addr(_GPIN0+1), W0
	MOV.B	[W0], [W1]
;CT01.c,186 :: 		RxTx_Data[3] = Lo(GPIN0);
	MOV	#lo_addr(_RxTx_Data+3), W1
	MOV	#lo_addr(_GPIN0), W0
	MOV.B	[W0], [W1]
;CT01.c,187 :: 		RxTx_Data[4] = Hi(GPIN1);
	MOV	#lo_addr(_RxTx_Data+4), W1
	MOV	#lo_addr(_GPIN1+1), W0
	MOV.B	[W0], [W1]
;CT01.c,188 :: 		RxTx_Data[5] = Lo(GPIN1);
	MOV	#lo_addr(_RxTx_Data+5), W1
	MOV	#lo_addr(_GPIN1), W0
	MOV.B	[W0], [W1]
;CT01.c,189 :: 		RxTx_Data[6] = Hi(GPIN2);
	MOV	#lo_addr(_RxTx_Data+6), W1
	MOV	#lo_addr(_GPIN2+1), W0
	MOV.B	[W0], [W1]
;CT01.c,190 :: 		RxTx_Data[7] = Lo(GPIN2);
	MOV	#lo_addr(_RxTx_Data+7), W1
	MOV	#lo_addr(_GPIN2), W0
	MOV.B	[W0], [W1]
;CT01.c,191 :: 		ECAN1Write(LSM_ELET_1, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
	MOV	#8, W13
	MOV	#lo_addr(_RxTx_Data), W12
	MOV	#2000, W10
	MOV	#0, W11
	PUSH	_Can_Send_Flags
	CALL	_ECAN1Write
	SUB	#2, W15
;CT01.c,194 :: 		RxTx_Data[0] = Hi(GPIN3);
	MOV	#lo_addr(_RxTx_Data), W1
	MOV	#lo_addr(_GPIN3+1), W0
	MOV.B	[W0], [W1]
;CT01.c,195 :: 		RxTx_Data[1] = Lo(GPIN3);
	MOV	#lo_addr(_RxTx_Data+1), W1
	MOV	#lo_addr(_GPIN3), W0
	MOV.B	[W0], [W1]
;CT01.c,196 :: 		RxTx_Data[2] = Hi(GPIN4);
	MOV	#lo_addr(_RxTx_Data+2), W1
	MOV	#lo_addr(_GPIN4+1), W0
	MOV.B	[W0], [W1]
;CT01.c,197 :: 		RxTx_Data[3] = Lo(GPIN4);
	MOV	#lo_addr(_RxTx_Data+3), W1
	MOV	#lo_addr(_GPIN4), W0
	MOV.B	[W0], [W1]
;CT01.c,198 :: 		RxTx_Data[4] = Hi(GPIN5);
	MOV	#lo_addr(_RxTx_Data+4), W1
	MOV	#lo_addr(_GPIN5+1), W0
	MOV.B	[W0], [W1]
;CT01.c,199 :: 		RxTx_Data[5] = Lo(GPIN5);
	MOV	#lo_addr(_RxTx_Data+5), W1
	MOV	#lo_addr(_GPIN5), W0
	MOV.B	[W0], [W1]
;CT01.c,200 :: 		RxTx_Data[6] = Hi(DIG1);
	MOV	#lo_addr(_RxTx_Data+6), W1
	MOV	#lo_addr(_DIG1+1), W0
	MOV.B	[W0], [W1]
;CT01.c,201 :: 		RxTx_Data[7] = Lo(DIG1);
	MOV	#lo_addr(_RxTx_Data+7), W1
	MOV	#lo_addr(_DIG1), W0
	MOV.B	[W0], [W1]
;CT01.c,202 :: 		ECAN1Write(LSM_ELET_2, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
	MOV	#8, W13
	MOV	#lo_addr(_RxTx_Data), W12
	MOV	#2010, W10
	MOV	#0, W11
	PUSH	_Can_Send_Flags
	CALL	_ECAN1Write
	SUB	#2, W15
;CT01.c,205 :: 		RxTx_Data[0] = Hi(PGA0);
	MOV	#lo_addr(_RxTx_Data), W1
	MOV	#lo_addr(_PGA0+1), W0
	MOV.B	[W0], [W1]
;CT01.c,206 :: 		RxTx_Data[1] = Lo(PGA0);
	MOV	#lo_addr(_RxTx_Data+1), W1
	MOV	#lo_addr(_PGA0), W0
	MOV.B	[W0], [W1]
;CT01.c,207 :: 		RxTx_Data[2] = Hi(PGA1);
	MOV	#lo_addr(_RxTx_Data+2), W1
	MOV	#lo_addr(_PGA1+1), W0
	MOV.B	[W0], [W1]
;CT01.c,208 :: 		RxTx_Data[3] = Lo(PGA1);
	MOV	#lo_addr(_RxTx_Data+3), W1
	MOV	#lo_addr(_PGA1), W0
	MOV.B	[W0], [W1]
;CT01.c,209 :: 		RxTx_Data[4] = Hi(PGA2);
	MOV	#lo_addr(_RxTx_Data+4), W1
	MOV	#lo_addr(_PGA2+1), W0
	MOV.B	[W0], [W1]
;CT01.c,210 :: 		RxTx_Data[5] = Lo(PGA2);
	MOV	#lo_addr(_RxTx_Data+5), W1
	MOV	#lo_addr(_PGA2), W0
	MOV.B	[W0], [W1]
;CT01.c,211 :: 		RxTx_Data[6] = Hi(PGA3);
	MOV	#lo_addr(_RxTx_Data+6), W1
	MOV	#lo_addr(_PGA3+1), W0
	MOV.B	[W0], [W1]
;CT01.c,212 :: 		RxTx_Data[7] = Lo(PGA3);
	MOV	#lo_addr(_RxTx_Data+7), W1
	MOV	#lo_addr(_PGA3), W0
	MOV.B	[W0], [W1]
;CT01.c,213 :: 		ECAN1Write(LSM_PGA_1, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
	MOV	#8, W13
	MOV	#lo_addr(_RxTx_Data), W12
	MOV	#2020, W10
	MOV	#0, W11
	PUSH	_Can_Send_Flags
	CALL	_ECAN1Write
	SUB	#2, W15
;CT01.c,217 :: 		RxTx_Data[0] = Hi(PGA4);
	MOV	#lo_addr(_RxTx_Data), W1
	MOV	#lo_addr(_PGA4+1), W0
	MOV.B	[W0], [W1]
;CT01.c,218 :: 		RxTx_Data[1] = Lo(PGA4);
	MOV	#lo_addr(_RxTx_Data+1), W1
	MOV	#lo_addr(_PGA4), W0
	MOV.B	[W0], [W1]
;CT01.c,219 :: 		RxTx_Data[2] = Hi(PGA5);
	MOV	#lo_addr(_RxTx_Data+2), W1
	MOV	#lo_addr(_PGA5+1), W0
	MOV.B	[W0], [W1]
;CT01.c,220 :: 		RxTx_Data[3] = Lo(PGA5);
	MOV	#lo_addr(_RxTx_Data+3), W1
	MOV	#lo_addr(_PGA5), W0
	MOV.B	[W0], [W1]
;CT01.c,221 :: 		RxTx_Data[4] = PGA_01_Gain;
	MOV	#lo_addr(_RxTx_Data+4), W1
	MOV	#lo_addr(_PGA_01_Gain), W0
	MOV.B	[W0], [W1]
;CT01.c,222 :: 		RxTx_Data[5] = PGA_23_Gain;
	MOV	#lo_addr(_RxTx_Data+5), W1
	MOV	#lo_addr(_PGA_23_Gain), W0
	MOV.B	[W0], [W1]
;CT01.c,223 :: 		RxTx_Data[6] = PGA_45_Gain;
	MOV	#lo_addr(_RxTx_Data+6), W1
	MOV	#lo_addr(_PGA_45_Gain), W0
	MOV.B	[W0], [W1]
;CT01.c,224 :: 		ECAN1Write(LSM_PGA_2, RxTx_Data, 7, Can_Send_Flags);    // Enviar dados capturados
	MOV	#7, W13
	MOV	#lo_addr(_RxTx_Data), W12
	MOV	#2030, W10
	MOV	#0, W11
	PUSH	_Can_Send_Flags
	CALL	_ECAN1Write
	SUB	#2, W15
;CT01.c,232 :: 		}
	GOTO	L_main10
;CT01.c,233 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
