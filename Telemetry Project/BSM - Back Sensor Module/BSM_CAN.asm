
_InitCan:

;BSM_CAN.c,130 :: 		void InitCan()
;BSM_CAN.c,134 :: 		IFS0=0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	IFS0
;BSM_CAN.c,135 :: 		IFS1=0;
	CLR	IFS1
;BSM_CAN.c,136 :: 		IFS2=0;
	CLR	IFS2
;BSM_CAN.c,137 :: 		IFS3=0;
	CLR	IFS3
;BSM_CAN.c,138 :: 		IFS4=0;
	CLR	IFS4
;BSM_CAN.c,142 :: 		IEC2bits.C1IE   = 1;                       // enable ECAN1 interrupt
	BSET	IEC2bits, #3
;BSM_CAN.c,143 :: 		C1INTEbits.TBIE = 1;                       // enable ECAN1 tx interrupt
	BSET.B	C1INTEbits, #0
;BSM_CAN.c,144 :: 		C1INTEbits.RBIE = 1;                       // enable ECAN1 rx interrupt
	BSET.B	C1INTEbits, #1
;BSM_CAN.c,146 :: 		Can_Init_Flags = 0;                              //
	CLR	W0
	MOV	W0, _Can_Init_Flags
;BSM_CAN.c,147 :: 		Can_Send_Flags = 0;                              // clear flags
	CLR	W0
	MOV	W0, _Can_Send_Flags
;BSM_CAN.c,148 :: 		Can_Rcv_Flags  = 0;                              //
	CLR	W0
	MOV	W0, _Can_Rcv_Flags
;BSM_CAN.c,152 :: 		_ECAN_TX_NO_RTR_FRAME;
	MOV	#245, W0
	MOV	W0, _Can_Send_Flags
;BSM_CAN.c,158 :: 		_ECAN_CONFIG_LINE_FILTER_OFF;
	MOV	#241, W0
	MOV	W0, _Can_Init_Flags
;BSM_CAN.c,160 :: 		ECAN1DmaChannelInit(0, 1, &ECAN1RxTxRAMBuffer);  // init dma channel 0 for
	MOV	#16384, W12
	MOV	#1, W11
	CLR	W10
	CALL	_ECAN1DmaChannelInit
;BSM_CAN.c,162 :: 		ECAN1DmaChannelInit(2, 0, &ECAN1RxTxRAMBuffer);  // init dma channel 2 for
	MOV	#16384, W12
	CLR	W11
	MOV	#2, W10
	CALL	_ECAN1DmaChannelInit
;BSM_CAN.c,164 :: 		ECAN1Initialize(SJW, BRP, PHSEG1, PHSEG2, PROPSEG, Can_Init_Flags);  // initialize ECAN 1Mbps
	MOV	#3, W13
	MOV	#3, W12
	MOV	#4, W11
	MOV	#1, W10
	PUSH	_Can_Init_Flags
	MOV	#1, W0
	PUSH	W0
	CALL	_ECAN1Initialize
	SUB	#4, W15
;BSM_CAN.c,165 :: 		ECAN1SetBufferSize(ECAN1RAMBUFFERSIZE);          // set number of rx+tx buffers in DMA RAM
	MOV	#16, W10
	CALL	_ECAN1SetBufferSize
;BSM_CAN.c,167 :: 		ECAN1SelectTxBuffers(0x00FF);                    // select transmit buffers
	MOV	#255, W10
	CALL	_ECAN1SelectTxBuffers
;BSM_CAN.c,169 :: 		ECAN1SetOperationMode(_ECAN_MODE_CONFIG,0xFF);   // set CONFIGURATION mode
	MOV	#255, W11
	MOV	#4, W10
	CALL	_ECAN1SetOperationMode
;BSM_CAN.c,171 :: 		ECAN1SetMask(_ECAN_MASK_0, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask1 bits to ones
	MOV	#247, W13
	MOV	#65535, W11
	MOV	#65535, W12
	CLR	W10
	CALL	_ECAN1SetMask
;BSM_CAN.c,172 :: 		ECAN1SetMask(_ECAN_MASK_1, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask2 bits to ones
	MOV	#247, W13
	MOV	#65535, W11
	MOV	#65535, W12
	MOV	#1, W10
	CALL	_ECAN1SetMask
;BSM_CAN.c,173 :: 		ECAN1SetMask(_ECAN_MASK_2, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask3 bits to ones
	MOV	#247, W13
	MOV	#65535, W11
	MOV	#65535, W12
	MOV	#2, W10
	CALL	_ECAN1SetMask
;BSM_CAN.c,178 :: 		ECAN1SetOperationMode(_ECAN_MODE_NORMAL,0xFF);   // set NORMAL mode
	MOV	#255, W11
	CLR	W10
	CALL	_ECAN1SetOperationMode
;BSM_CAN.c,179 :: 		}
L_end_InitCan:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _InitCan

_InputCapture1Int:
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;BSM_CAN.c,195 :: 		void InputCapture1Int() iv IVT_ADDR_IC1INTERRUPT //RPM
;BSM_CAN.c,197 :: 		t1=IC1BUF;
	MOV	IC1BUF, WREG
	MOV	W0, _t1
;BSM_CAN.c,198 :: 		t2=IC1BUF;
	MOV	IC1BUF, WREG
	MOV	W0, _t2
;BSM_CAN.c,199 :: 		IC1IF_bit=0;
	BCLR	IC1IF_bit, #1
;BSM_CAN.c,200 :: 		if(t2>t1)
	MOV	_t2, W1
	MOV	#lo_addr(_t1), W0
	CP	W1, [W0]
	BRA GTU	L__InputCapture1Int15
	GOTO	L_InputCapture1Int0
L__InputCapture1Int15:
;BSM_CAN.c,201 :: 		DIG2_BSM = t2-t1;
	MOV	_t2, W2
	MOV	#lo_addr(_t1), W1
	MOV	#lo_addr(_DIG2_BSM), W0
	SUB	W2, [W1], [W0]
	GOTO	L_InputCapture1Int1
L_InputCapture1Int0:
;BSM_CAN.c,203 :: 		DIG2_BSM = (PR3 - t1) + t2;
	MOV	PR3, W1
	MOV	#lo_addr(_t1), W0
	SUB	W1, [W0], W2
	MOV	#lo_addr(_t2), W1
	MOV	#lo_addr(_DIG2_BSM), W0
	ADD	W2, [W1], [W0]
L_InputCapture1Int1:
;BSM_CAN.c,204 :: 		}
L_end_InputCapture1Int:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	RETFIE
; end of _InputCapture1Int

_InputCapture2Int:
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;BSM_CAN.c,206 :: 		void InputCapture2Int() iv IVT_ADDR_IC2INTERRUPT //(Velocidade)
;BSM_CAN.c,208 :: 		t1=IC2BUF;
	MOV	IC2BUF, WREG
	MOV	W0, _t1
;BSM_CAN.c,209 :: 		t2=IC2BUF;
	MOV	IC2BUF, WREG
	MOV	W0, _t2
;BSM_CAN.c,210 :: 		IC2IF_bit=0;
	BCLR	IC2IF_bit, #5
;BSM_CAN.c,211 :: 		if(t2>t1)
	MOV	_t2, W1
	MOV	#lo_addr(_t1), W0
	CP	W1, [W0]
	BRA GTU	L__InputCapture2Int17
	GOTO	L_InputCapture2Int2
L__InputCapture2Int17:
;BSM_CAN.c,212 :: 		DIG3_BSM = t2-t1;
	MOV	_t2, W2
	MOV	#lo_addr(_t1), W1
	MOV	#lo_addr(_DIG3_BSM), W0
	SUB	W2, [W1], [W0]
	GOTO	L_InputCapture2Int3
L_InputCapture2Int2:
;BSM_CAN.c,214 :: 		DIG3_BSM = (PR2 - t1) + t2;
	MOV	PR2, W1
	MOV	#lo_addr(_t1), W0
	SUB	W1, [W0], W2
	MOV	#lo_addr(_t2), W1
	MOV	#lo_addr(_DIG3_BSM), W0
	ADD	W2, [W1], [W0]
L_InputCapture2Int3:
;BSM_CAN.c,215 :: 		}
L_end_InputCapture2Int:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	RETFIE
; end of _InputCapture2Int

_InputCapture7Int:
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;BSM_CAN.c,217 :: 		void InputCapture7Int() iv IVT_ADDR_IC7INTERRUPT //RPM
;BSM_CAN.c,219 :: 		t1=IC7BUF;
	MOV	IC7BUF, WREG
	MOV	W0, _t1
;BSM_CAN.c,220 :: 		t2=IC7BUF;
	MOV	IC7BUF, WREG
	MOV	W0, _t2
;BSM_CAN.c,221 :: 		IC7IF_bit=0;
	BCLR	IC7IF_bit, #6
;BSM_CAN.c,222 :: 		if(t2>t1)
	MOV	_t2, W1
	MOV	#lo_addr(_t1), W0
	CP	W1, [W0]
	BRA GTU	L__InputCapture7Int19
	GOTO	L_InputCapture7Int4
L__InputCapture7Int19:
;BSM_CAN.c,223 :: 		DIG4_BSM = t2-t1;
	MOV	_t2, W2
	MOV	#lo_addr(_t1), W1
	MOV	#lo_addr(_DIG4_BSM), W0
	SUB	W2, [W1], [W0]
	GOTO	L_InputCapture7Int5
L_InputCapture7Int4:
;BSM_CAN.c,225 :: 		DIG4_BSM = (PR3 - t1) + t2;
	MOV	PR3, W1
	MOV	#lo_addr(_t1), W0
	SUB	W1, [W0], W2
	MOV	#lo_addr(_t2), W1
	MOV	#lo_addr(_DIG4_BSM), W0
	ADD	W2, [W1], [W0]
L_InputCapture7Int5:
;BSM_CAN.c,226 :: 		}
L_end_InputCapture7Int:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	RETFIE
; end of _InputCapture7Int

_C1Interrupt:
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;BSM_CAN.c,228 :: 		void C1Interrupt(void) org 0x005A                            // ECAN event iterrupt
;BSM_CAN.c,231 :: 		IFS2bits.C1IF = 0;                                   // clear ECAN interrupt flag
	BCLR	IFS2bits, #3
;BSM_CAN.c,232 :: 		if(C1INTFbits.TBIF) {                                // was it tx interrupt?
	BTSS	C1INTFbits, #0
	GOTO	L_C1Interrupt6
;BSM_CAN.c,233 :: 		C1INTFbits.TBIF = 0;                             // if yes clear tx interrupt flag
	BCLR	C1INTFbits, #0
;BSM_CAN.c,234 :: 		LED1 = 1;
	BSET	LATA8_bit, #8
;BSM_CAN.c,235 :: 		}
L_C1Interrupt6:
;BSM_CAN.c,237 :: 		if(C1INTFbits.RBIF) {                                      // was it rx interrupt?
	BTSS	C1INTFbits, #1
	GOTO	L_C1Interrupt7
;BSM_CAN.c,238 :: 		C1INTFbits.RBIF = 0;                         // if yes clear rx interrupt flag
	BCLR	C1INTFbits, #1
;BSM_CAN.c,239 :: 		}
L_C1Interrupt7:
;BSM_CAN.c,240 :: 		}
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

;BSM_CAN.c,242 :: 		void main()
;BSM_CAN.c,246 :: 		InitPorts();
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CALL	_InitPorts
;BSM_CAN.c,247 :: 		InitClock();
	CALL	_InitClock
;BSM_CAN.c,249 :: 		InitTimersCapture();
	CALL	_InitTimersCapture
;BSM_CAN.c,250 :: 		InitCAN();
	CALL	_InitCan
;BSM_CAN.c,251 :: 		LED1 = 1;
	BSET	LATA8_bit, #8
;BSM_CAN.c,255 :: 		Delay_ms(1000);
	MOV	#204, W8
	MOV	#29592, W7
L_main8:
	DEC	W7
	BRA NZ	L_main8
	DEC	W8
	BRA NZ	L_main8
;BSM_CAN.c,256 :: 		LED1 = 0;
	BCLR	LATA8_bit, #8
;BSM_CAN.c,257 :: 		contagem = 14;
	MOV	#14, W0
	MOV	W0, _contagem
;BSM_CAN.c,259 :: 		while(1)
L_main10:
;BSM_CAN.c,264 :: 		contagem --;
	MOV	#1, W1
	MOV	#lo_addr(_contagem), W0
	SUBR	W1, [W0], [W0]
;BSM_CAN.c,265 :: 		if (contagem == 1)
	MOV	_contagem, W0
	CP	W0, #1
	BRA Z	L__main22
	GOTO	L_main12
L__main22:
;BSM_CAN.c,267 :: 		contagem = 14;
	MOV	#14, W0
	MOV	W0, _contagem
;BSM_CAN.c,268 :: 		}
L_main12:
;BSM_CAN.c,269 :: 		VDelay_ms(contagem);
	MOV	_contagem, W10
	CALL	_VDelay_ms
;BSM_CAN.c,271 :: 		LED1 = 0;
	BCLR	LATA8_bit, #8
;BSM_CAN.c,273 :: 		ANA4_BSM =  ADC1_Read(ANA_4);
	MOV	#4, W10
	CALL	_ADC1_Read
	MOV	W0, _ANA4_BSM
;BSM_CAN.c,274 :: 		ANA5_BSM =  ADC1_Read(ANA_5);
	MOV	#3, W10
	CALL	_ADC1_Read
	MOV	W0, _ANA5_BSM
;BSM_CAN.c,275 :: 		ANA6_BSM =  ADC1_Read(ANA_6);
	MOV	#2, W10
	CALL	_ADC1_Read
	MOV	W0, _ANA6_BSM
;BSM_CAN.c,276 :: 		ANA7_BSM =  ADC1_Read(ANA_7);
	MOV	#1, W10
	CALL	_ADC1_Read
	MOV	W0, _ANA7_BSM
;BSM_CAN.c,278 :: 		ANA0_BSM =  ADC1_Read(ANA_0);
	MOV	#8, W10
	CALL	_ADC1_Read
	MOV	W0, _ANA0_BSM
;BSM_CAN.c,279 :: 		ANA1_BSM =  ADC1_Read(ANA_1);
	MOV	#7, W10
	CALL	_ADC1_Read
	MOV	W0, _ANA1_BSM
;BSM_CAN.c,280 :: 		ANA2_BSM =  ADC1_Read(ANA_2);
	MOV	#6, W10
	CALL	_ADC1_Read
	MOV	W0, _ANA2_BSM
;BSM_CAN.c,281 :: 		ANA3_BSM =  ADC1_Read(ANA_3);
	MOV	#5, W10
	CALL	_ADC1_Read
	MOV	W0, _ANA3_BSM
;BSM_CAN.c,284 :: 		ANA8_BSM =  ADC1_Read(ANA_8);
	CLR	W10
	CALL	_ADC1_Read
	MOV	W0, _ANA8_BSM
;BSM_CAN.c,285 :: 		ANA9_BSM =  ADC1_Read(ANA_9);
	MOV	#9, W10
	CALL	_ADC1_Read
	MOV	W0, _ANA9_BSM
;BSM_CAN.c,286 :: 		ANA10_BSM =  ADC1_Read(ANA_10);
	MOV	#11, W10
	CALL	_ADC1_Read
	MOV	W0, _ANA10_BSM
;BSM_CAN.c,287 :: 		ANA11_BSM =  ADC1_Read(ANA_11);
	MOV	#10, W10
	CALL	_ADC1_Read
	MOV	W0, _ANA11_BSM
;BSM_CAN.c,289 :: 		DIG1_BSM = DIG_1;
	MOV	#lo_addr(_DIG1_BSM), W0
	CLR	[W0]
	BTSC	RB11_bit, #11
	INC	[W0], [W0]
;BSM_CAN.c,290 :: 		DIG5_BSM = DIG_5;
	MOV	#lo_addr(_DIG5_BSM), W0
	CLR	[W0]
	BTSC	RB4_bit, #4
	INC	[W0], [W0]
;BSM_CAN.c,291 :: 		DIG6_BSM = DIG_6;
	MOV	#lo_addr(_DIG6_BSM), W0
	CLR	[W0]
	BTSC	RA10_bit, #10
	INC	[W0], [W0]
;BSM_CAN.c,292 :: 		DIG8_BSM = DIG_8;
	MOV	#lo_addr(_DIG8_BSM), W0
	CLR	[W0]
	BTSC	RA7_bit, #7
	INC	[W0], [W0]
;BSM_CAN.c,293 :: 		DIG7_BSM = DIG_7;
	MOV	#lo_addr(_DIG7_BSM), W0
	CLR	[W0]
	BTSC	RB7_bit, #7
	INC	[W0], [W0]
;BSM_CAN.c,296 :: 		LATITUDE_INT_BSM = 0;
	CLR	W0
	MOV	W0, _LATITUDE_INT_BSM
;BSM_CAN.c,297 :: 		LATITUDE_FRAC_BSM = 0;
	CLR	W0
	MOV	W0, _LATITUDE_FRAC_BSM
;BSM_CAN.c,298 :: 		LONGITUDE_INT_BSM = 0;
	CLR	W0
	MOV	W0, _LONGITUDE_INT_BSM
;BSM_CAN.c,299 :: 		LONGITUDE_FRAC_BSM = 0;
	CLR	W0
	MOV	W0, _LONGITUDE_FRAC_BSM
;BSM_CAN.c,300 :: 		NORTH_SOUTH_BSM = 0;
	CLR	W0
	MOV	W0, _NORTH_SOUTH_BSM
;BSM_CAN.c,301 :: 		EAST_WEST_BSM = 0;
	CLR	W0
	MOV	W0, _EAST_WEST_BSM
;BSM_CAN.c,302 :: 		VEL_X100_BSM = 0;
	CLR	W0
	MOV	W0, _VEL_X100_BSM
;BSM_CAN.c,303 :: 		DIRECAO_X100_BSM = 0;
	CLR	W0
	MOV	W0, _DIRECAO_X100_BSM
;BSM_CAN.c,304 :: 		STATUS_GPS_A_V_BSM = 0;
	CLR	W0
	MOV	W0, _STATUS_GPS_A_V_BSM
;BSM_CAN.c,305 :: 		CHECKSUM_BSM = 0;
	CLR	W0
	MOV	W0, _CHECKSUM_BSM
;BSM_CAN.c,307 :: 		HORA_BSM = 0;
	CLR	W0
	MOV	W0, _HORA_BSM
;BSM_CAN.c,308 :: 		MINUTO_BSM = 0;
	CLR	W0
	MOV	W0, _MINUTO_BSM
;BSM_CAN.c,309 :: 		SEGUNDO_BSM = 0;
	CLR	W0
	MOV	W0, _SEGUNDO_BSM
;BSM_CAN.c,310 :: 		MILISEGUNDO_BSM = 0;
	CLR	W0
	MOV	W0, _MILISEGUNDO_BSM
;BSM_CAN.c,311 :: 		DIA_BSM = 0;
	CLR	W0
	MOV	W0, _DIA_BSM
;BSM_CAN.c,312 :: 		MES_BSM = 0;
	CLR	W0
	MOV	W0, _MES_BSM
;BSM_CAN.c,313 :: 		ANO_BSM = 0;
	CLR	W0
	MOV	W0, _ANO_BSM
;BSM_CAN.c,315 :: 		HDOP_X100_BSM = 0;
	CLR	W0
	MOV	W0, _HDOP_X100_BSM
;BSM_CAN.c,316 :: 		GPS_FIX_BSM = 0;
	CLR	W0
	MOV	W0, _GPS_FIX_BSM
;BSM_CAN.c,317 :: 		ALTITUDE_BSM = 0;
	CLR	W0
	MOV	W0, _ALTITUDE_BSM
;BSM_CAN.c,320 :: 		RxTx_Data[0] = Hi(ANA0_BSM);
	MOV	#lo_addr(_RxTx_Data), W1
	MOV	#lo_addr(_ANA0_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,321 :: 		RxTx_Data[1] = Lo(ANA0_BSM);
	MOV	#lo_addr(_RxTx_Data+1), W1
	MOV	#lo_addr(_ANA0_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,322 :: 		RxTx_Data[2] = Hi(ANA1_BSM);
	MOV	#lo_addr(_RxTx_Data+2), W1
	MOV	#lo_addr(_ANA1_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,323 :: 		RxTx_Data[3] = Lo(ANA1_BSM);
	MOV	#lo_addr(_RxTx_Data+3), W1
	MOV	#lo_addr(_ANA1_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,324 :: 		RxTx_Data[4] = Hi(ANA2_BSM);
	MOV	#lo_addr(_RxTx_Data+4), W1
	MOV	#lo_addr(_ANA2_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,325 :: 		RxTx_Data[5] = Lo(ANA2_BSM);
	MOV	#lo_addr(_RxTx_Data+5), W1
	MOV	#lo_addr(_ANA2_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,326 :: 		RxTx_Data[6] = Hi(ANA3_BSM);
	MOV	#lo_addr(_RxTx_Data+6), W1
	MOV	#lo_addr(_ANA3_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,327 :: 		RxTx_Data[7] = Lo(ANA3_BSM);
	MOV	#lo_addr(_RxTx_Data+7), W1
	MOV	#lo_addr(_ANA3_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,328 :: 		ECAN1Write(BSM_ANA_1, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
	MOV	#8, W13
	MOV	#lo_addr(_RxTx_Data), W12
	MOV	#3000, W10
	MOV	#0, W11
	PUSH	_Can_Send_Flags
	CALL	_ECAN1Write
	SUB	#2, W15
;BSM_CAN.c,332 :: 		RxTx_Data[0] = Hi(ANA4_BSM);
	MOV	#lo_addr(_RxTx_Data), W1
	MOV	#lo_addr(_ANA4_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,333 :: 		RxTx_Data[1] = Lo(ANA4_BSM);
	MOV	#lo_addr(_RxTx_Data+1), W1
	MOV	#lo_addr(_ANA4_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,334 :: 		RxTx_Data[2] = Hi(ANA5_BSM);
	MOV	#lo_addr(_RxTx_Data+2), W1
	MOV	#lo_addr(_ANA5_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,335 :: 		RxTx_Data[3] = Lo(ANA5_BSM);
	MOV	#lo_addr(_RxTx_Data+3), W1
	MOV	#lo_addr(_ANA5_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,336 :: 		RxTx_Data[4] = Hi(ANA6_BSM);
	MOV	#lo_addr(_RxTx_Data+4), W1
	MOV	#lo_addr(_ANA6_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,337 :: 		RxTx_Data[5] = Lo(ANA6_BSM);
	MOV	#lo_addr(_RxTx_Data+5), W1
	MOV	#lo_addr(_ANA6_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,338 :: 		RxTx_Data[6] = Hi(ANA7_BSM);
	MOV	#lo_addr(_RxTx_Data+6), W1
	MOV	#lo_addr(_ANA7_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,339 :: 		RxTx_Data[7] = Lo(ANA7_BSM);
	MOV	#lo_addr(_RxTx_Data+7), W1
	MOV	#lo_addr(_ANA7_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,340 :: 		ECAN1Write(BSM_ANA_2, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
	MOV	#8, W13
	MOV	#lo_addr(_RxTx_Data), W12
	MOV	#3010, W10
	MOV	#0, W11
	PUSH	_Can_Send_Flags
	CALL	_ECAN1Write
	SUB	#2, W15
;BSM_CAN.c,343 :: 		RxTx_Data[0] = Hi(ANA8_BSM);
	MOV	#lo_addr(_RxTx_Data), W1
	MOV	#lo_addr(_ANA8_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,344 :: 		RxTx_Data[1] = Lo(ANA8_BSM);
	MOV	#lo_addr(_RxTx_Data+1), W1
	MOV	#lo_addr(_ANA8_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,345 :: 		RxTx_Data[2] = Hi(ANA9_BSM);
	MOV	#lo_addr(_RxTx_Data+2), W1
	MOV	#lo_addr(_ANA9_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,346 :: 		RxTx_Data[3] = Lo(ANA9_BSM);
	MOV	#lo_addr(_RxTx_Data+3), W1
	MOV	#lo_addr(_ANA9_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,347 :: 		RxTx_Data[4] = Hi(ANA10_BSM);
	MOV	#lo_addr(_RxTx_Data+4), W1
	MOV	#lo_addr(_ANA10_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,348 :: 		RxTx_Data[5] = Lo(ANA10_BSM);
	MOV	#lo_addr(_RxTx_Data+5), W1
	MOV	#lo_addr(_ANA10_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,349 :: 		RxTx_Data[6] = Hi(ANA11_BSM);
	MOV	#lo_addr(_RxTx_Data+6), W1
	MOV	#lo_addr(_ANA11_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,350 :: 		RxTx_Data[7] = Lo(ANA11_BSM);
	MOV	#lo_addr(_RxTx_Data+7), W1
	MOV	#lo_addr(_ANA11_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,351 :: 		ECAN1Write(BSM_ANA_3, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
	MOV	#8, W13
	MOV	#lo_addr(_RxTx_Data), W12
	MOV	#3030, W10
	MOV	#0, W11
	PUSH	_Can_Send_Flags
	CALL	_ECAN1Write
	SUB	#2, W15
;BSM_CAN.c,355 :: 		RxTx_Data[0] = Hi(DIG1_BSM);
	MOV	#lo_addr(_RxTx_Data), W1
	MOV	#lo_addr(_DIG1_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,356 :: 		RxTx_Data[1] = Lo(DIG1_BSM);
	MOV	#lo_addr(_RxTx_Data+1), W1
	MOV	#lo_addr(_DIG1_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,357 :: 		RxTx_Data[2] = Hi(DIG2_BSM);
	MOV	#lo_addr(_RxTx_Data+2), W1
	MOV	#lo_addr(_DIG2_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,358 :: 		RxTx_Data[3] = Lo(DIG2_BSM);
	MOV	#lo_addr(_RxTx_Data+3), W1
	MOV	#lo_addr(_DIG2_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,359 :: 		RxTx_Data[4] = Hi(DIG3_BSM);
	MOV	#lo_addr(_RxTx_Data+4), W1
	MOV	#lo_addr(_DIG3_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,360 :: 		RxTx_Data[5] = Lo(DIG3_BSM);
	MOV	#lo_addr(_RxTx_Data+5), W1
	MOV	#lo_addr(_DIG3_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,361 :: 		RxTx_Data[6] = Hi(DIG4_BSM);
	MOV	#lo_addr(_RxTx_Data+6), W1
	MOV	#lo_addr(_DIG4_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,362 :: 		RxTx_Data[7] = Lo(DIG4_BSM);
	MOV	#lo_addr(_RxTx_Data+7), W1
	MOV	#lo_addr(_DIG4_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,363 :: 		ECAN1Write(BSM_DIG_1, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
	MOV	#8, W13
	MOV	#lo_addr(_RxTx_Data), W12
	MOV	#3040, W10
	MOV	#0, W11
	PUSH	_Can_Send_Flags
	CALL	_ECAN1Write
	SUB	#2, W15
;BSM_CAN.c,366 :: 		RxTx_Data[0] = Hi(DIG5_BSM);
	MOV	#lo_addr(_RxTx_Data), W1
	MOV	#lo_addr(_DIG5_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,367 :: 		RxTx_Data[1] = Lo(DIG5_BSM);
	MOV	#lo_addr(_RxTx_Data+1), W1
	MOV	#lo_addr(_DIG5_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,368 :: 		RxTx_Data[2] = Hi(DIG6_BSM);
	MOV	#lo_addr(_RxTx_Data+2), W1
	MOV	#lo_addr(_DIG6_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,369 :: 		RxTx_Data[3] = Lo(DIG6_BSM);
	MOV	#lo_addr(_RxTx_Data+3), W1
	MOV	#lo_addr(_DIG6_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,370 :: 		RxTx_Data[4] = HDOP_X100_BSM;
	MOV	#lo_addr(_RxTx_Data+4), W1
	MOV	_HDOP_X100_BSM, W0
	MOV.B	W0, [W1]
;BSM_CAN.c,371 :: 		RxTx_Data[5] = GPS_FIX_BSM;
	MOV	#lo_addr(_RxTx_Data+5), W1
	MOV	_GPS_FIX_BSM, W0
	MOV.B	W0, [W1]
;BSM_CAN.c,372 :: 		RxTx_Data[6] = Hi(ALTITUDE_BSM);
	MOV	#lo_addr(_RxTx_Data+6), W1
	MOV	#lo_addr(_ALTITUDE_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,373 :: 		RxTx_Data[7] = Lo(ALTITUDE_BSM);
	MOV	#lo_addr(_RxTx_Data+7), W1
	MOV	#lo_addr(_ALTITUDE_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,374 :: 		ECAN1Write(BSM_DIG_2, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
	MOV	#8, W13
	MOV	#lo_addr(_RxTx_Data), W12
	MOV	#3050, W10
	MOV	#0, W11
	PUSH	_Can_Send_Flags
	CALL	_ECAN1Write
	SUB	#2, W15
;BSM_CAN.c,377 :: 		RxTx_Data[0] = Hi(LATITUDE_INT_BSM);
	MOV	#lo_addr(_RxTx_Data), W1
	MOV	#lo_addr(_LATITUDE_INT_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,378 :: 		RxTx_Data[1] = Lo(LATITUDE_INT_BSM);
	MOV	#lo_addr(_RxTx_Data+1), W1
	MOV	#lo_addr(_LATITUDE_INT_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,379 :: 		RxTx_Data[2] = Hi(LATITUDE_FRAC_BSM);
	MOV	#lo_addr(_RxTx_Data+2), W1
	MOV	#lo_addr(_LATITUDE_FRAC_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,380 :: 		RxTx_Data[3] = Lo(LATITUDE_FRAC_BSM);
	MOV	#lo_addr(_RxTx_Data+3), W1
	MOV	#lo_addr(_LATITUDE_FRAC_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,381 :: 		RxTx_Data[4] = Hi(LONGITUDE_INT_BSM);
	MOV	#lo_addr(_RxTx_Data+4), W1
	MOV	#lo_addr(_LONGITUDE_INT_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,382 :: 		RxTx_Data[5] = Lo(LONGITUDE_INT_BSM);
	MOV	#lo_addr(_RxTx_Data+5), W1
	MOV	#lo_addr(_LONGITUDE_INT_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,383 :: 		RxTx_Data[6] = Hi(LONGITUDE_FRAC_BSM);
	MOV	#lo_addr(_RxTx_Data+6), W1
	MOV	#lo_addr(_LONGITUDE_FRAC_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,384 :: 		RxTx_Data[7] = Lo(LONGITUDE_FRAC_BSM);
	MOV	#lo_addr(_RxTx_Data+7), W1
	MOV	#lo_addr(_LONGITUDE_FRAC_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,385 :: 		ECAN1Write(BSM_GPS_1, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
	MOV	#8, W13
	MOV	#lo_addr(_RxTx_Data), W12
	MOV	#3060, W10
	MOV	#0, W11
	PUSH	_Can_Send_Flags
	CALL	_ECAN1Write
	SUB	#2, W15
;BSM_CAN.c,387 :: 		RxTx_Data[0] = NORTH_SOUTH_BSM;
	MOV	#lo_addr(_RxTx_Data), W1
	MOV	_NORTH_SOUTH_BSM, W0
	MOV.B	W0, [W1]
;BSM_CAN.c,388 :: 		RxTx_Data[1] = EAST_WEST_BSM;
	MOV	#lo_addr(_RxTx_Data+1), W1
	MOV	_EAST_WEST_BSM, W0
	MOV.B	W0, [W1]
;BSM_CAN.c,389 :: 		RxTx_Data[2] = Hi(VEL_X100_BSM);
	MOV	#lo_addr(_RxTx_Data+2), W1
	MOV	#lo_addr(_VEL_X100_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,390 :: 		RxTx_Data[3] = Lo(VEL_X100_BSM);
	MOV	#lo_addr(_RxTx_Data+3), W1
	MOV	#lo_addr(_VEL_X100_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,391 :: 		RxTx_Data[4] = Hi(DIRECAO_X100_BSM);
	MOV	#lo_addr(_RxTx_Data+4), W1
	MOV	#lo_addr(_DIRECAO_X100_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,392 :: 		RxTx_Data[5] = Lo(DIRECAO_X100_BSM);
	MOV	#lo_addr(_RxTx_Data+5), W1
	MOV	#lo_addr(_DIRECAO_X100_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,393 :: 		RxTx_Data[6] = STATUS_GPS_A_V_BSM;
	MOV	#lo_addr(_RxTx_Data+6), W1
	MOV	_STATUS_GPS_A_V_BSM, W0
	MOV.B	W0, [W1]
;BSM_CAN.c,394 :: 		RxTx_Data[7] = CHECKSUM_BSM;
	MOV	#lo_addr(_RxTx_Data+7), W1
	MOV	_CHECKSUM_BSM, W0
	MOV.B	W0, [W1]
;BSM_CAN.c,395 :: 		ECAN1Write(BSM_GPS_2, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
	MOV	#8, W13
	MOV	#lo_addr(_RxTx_Data), W12
	MOV	#3070, W10
	MOV	#0, W11
	PUSH	_Can_Send_Flags
	CALL	_ECAN1Write
	SUB	#2, W15
;BSM_CAN.c,397 :: 		RxTx_Data[0] = HORA_BSM;
	MOV	#lo_addr(_RxTx_Data), W1
	MOV	_HORA_BSM, W0
	MOV.B	W0, [W1]
;BSM_CAN.c,398 :: 		RxTx_Data[1] = MINUTO_BSM;
	MOV	#lo_addr(_RxTx_Data+1), W1
	MOV	_MINUTO_BSM, W0
	MOV.B	W0, [W1]
;BSM_CAN.c,399 :: 		RxTx_Data[2] = SEGUNDO_BSM;
	MOV	#lo_addr(_RxTx_Data+2), W1
	MOV	_SEGUNDO_BSM, W0
	MOV.B	W0, [W1]
;BSM_CAN.c,400 :: 		RxTx_Data[3] = Hi(MILISEGUNDO_BSM);
	MOV	#lo_addr(_RxTx_Data+3), W1
	MOV	#lo_addr(_MILISEGUNDO_BSM+1), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,401 :: 		RxTx_Data[4] = Lo(MILISEGUNDO_BSM);
	MOV	#lo_addr(_RxTx_Data+4), W1
	MOV	#lo_addr(_MILISEGUNDO_BSM), W0
	MOV.B	[W0], [W1]
;BSM_CAN.c,402 :: 		RxTx_Data[5] = DIA_BSM;
	MOV	#lo_addr(_RxTx_Data+5), W1
	MOV	_DIA_BSM, W0
	MOV.B	W0, [W1]
;BSM_CAN.c,403 :: 		RxTx_Data[6] = MES_BSM;
	MOV	#lo_addr(_RxTx_Data+6), W1
	MOV	_MES_BSM, W0
	MOV.B	W0, [W1]
;BSM_CAN.c,404 :: 		RxTx_Data[7] = ANO_BSM;
	MOV	#lo_addr(_RxTx_Data+7), W1
	MOV	_ANO_BSM, W0
	MOV.B	W0, [W1]
;BSM_CAN.c,405 :: 		ECAN1Write(BSM_GPS_3, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
	MOV	#8, W13
	MOV	#lo_addr(_RxTx_Data), W12
	MOV	#3080, W10
	MOV	#0, W11
	PUSH	_Can_Send_Flags
	CALL	_ECAN1Write
	SUB	#2, W15
;BSM_CAN.c,407 :: 		}
	GOTO	L_main10
;BSM_CAN.c,409 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
