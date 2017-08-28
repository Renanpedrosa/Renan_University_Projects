
_InitCAN:

;CT02_III.c,199 :: 		void InitCAN()
;CT02_III.c,207 :: 		IFS0=0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	IFS0
;CT02_III.c,208 :: 		IFS1=0;
	CLR	IFS1
;CT02_III.c,209 :: 		IFS2=0;
	CLR	IFS2
;CT02_III.c,210 :: 		IFS3=0;
	CLR	IFS3
;CT02_III.c,211 :: 		IFS4=0;
	CLR	IFS4
;CT02_III.c,215 :: 		IEC2bits.C1IE   = 1;                       // enable ECAN1 interrupts
	BSET	IEC2bits, #3
;CT02_III.c,217 :: 		C1INTEbits.TBIE = 1;                       // enable ECAN1 tx interrupt
	BSET.B	C1INTEbits, #0
;CT02_III.c,218 :: 		C1INTEbits.RBIE = 1;                       // enable ECAN1 rx interrupt
	BSET.B	C1INTEbits, #1
;CT02_III.c,220 :: 		Can_Init_Flags = 0;                              //
	CLR	W0
	MOV	W0, _Can_Init_Flags
;CT02_III.c,221 :: 		Can_Send_Flags = 0;                              // clear flags
	CLR	W0
	MOV	W0, _Can_Send_Flags
;CT02_III.c,222 :: 		Can_Rcv_Flags  = 0;                              //
	CLR	W0
	MOV	W0, _Can_Rcv_Flags
;CT02_III.c,226 :: 		_ECAN_TX_NO_RTR_FRAME;
	MOV	#244, W0
	MOV	W0, _Can_Send_Flags
;CT02_III.c,232 :: 		_ECAN_CONFIG_LINE_FILTER_OFF;
	MOV	#241, W0
	MOV	W0, _Can_Init_Flags
;CT02_III.c,235 :: 		ECAN1DmaChannelInit(0, 1, &ECAN1RxTxRAMBuffer);  // init dma channel 0 for
	MOV	#16384, W12
	MOV	#1, W11
	CLR	W10
	CALL	_ECAN1DmaChannelInit
;CT02_III.c,237 :: 		ECAN1DmaChannelInit(2, 0, &ECAN1RxTxRAMBuffer);  // init dma channel 2 for
	MOV	#16384, W12
	CLR	W11
	MOV	#2, W10
	CALL	_ECAN1DmaChannelInit
;CT02_III.c,240 :: 		ECAN1Initialize(SJW, BRP, PHSEG1, PHSEG2, PROPSEG, Can_Init_Flags);  // initialize ECAN 1Mbps
	MOV	#3, W13
	MOV	#3, W12
	MOV	#4, W11
	MOV	#1, W10
	PUSH	_Can_Init_Flags
	MOV	#1, W0
	PUSH	W0
	CALL	_ECAN1Initialize
	SUB	#4, W15
;CT02_III.c,241 :: 		ECAN1SetBufferSize(ECAN1RAMBUFFERSIZE);          // set number of rx+tx buffers in DMA RAM
	MOV	#16, W10
	CALL	_ECAN1SetBufferSize
;CT02_III.c,243 :: 		ECAN1SelectTxBuffers(0x0003);                    // select transmit buffers
	MOV	#3, W10
	CALL	_ECAN1SelectTxBuffers
;CT02_III.c,245 :: 		ECAN1SetOperationMode(_ECAN_MODE_CONFIG,0xFF);   // set CONFIGURATION mode
	MOV	#255, W11
	MOV	#4, W10
	CALL	_ECAN1SetOperationMode
;CT02_III.c,247 :: 		ECAN1SetMask(_ECAN_MASK_0, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);         // set all mask1 bits to ones
	MOV	#247, W13
	MOV	#65535, W11
	MOV	#65535, W12
	CLR	W10
	CALL	_ECAN1SetMask
;CT02_III.c,248 :: 		ECAN1SetMask(_ECAN_MASK_1, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);         // set all mask2 bits to ones
	MOV	#247, W13
	MOV	#65535, W11
	MOV	#65535, W12
	MOV	#1, W10
	CALL	_ECAN1SetMask
;CT02_III.c,249 :: 		ECAN1SetMask(_ECAN_MASK_2, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);         // set all mask3 bits to ones
	MOV	#247, W13
	MOV	#65535, W11
	MOV	#65535, W12
	MOV	#2, W10
	CALL	_ECAN1SetMask
;CT02_III.c,250 :: 		ECAN1SetFilter(_ECAN_FILTER_0, LSM_ELET_1, _ECAN_MASK_0, _ECAN_RX_BUFFER_2, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
	CLR	W13
	MOV	#2000, W11
	MOV	#0, W12
	CLR	W10
	MOV	#247, W0
	PUSH	W0
	MOV	#2, W0
	PUSH	W0
	CALL	_ECAN1SetFilter
	SUB	#4, W15
;CT02_III.c,251 :: 		ECAN1SetFilter(_ECAN_FILTER_1, LSM_ELET_2, _ECAN_MASK_0, _ECAN_RX_BUFFER_3, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
	CLR	W13
	MOV	#2010, W11
	MOV	#0, W12
	MOV	#1, W10
	MOV	#247, W0
	PUSH	W0
	MOV	#3, W0
	PUSH	W0
	CALL	_ECAN1SetFilter
	SUB	#4, W15
;CT02_III.c,252 :: 		ECAN1SetFilter(_ECAN_FILTER_2, LSM_PGA_1, _ECAN_MASK_0, _ECAN_RX_BUFFER_4, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
	CLR	W13
	MOV	#2020, W11
	MOV	#0, W12
	MOV	#2, W10
	MOV	#247, W0
	PUSH	W0
	MOV	#4, W0
	PUSH	W0
	CALL	_ECAN1SetFilter
	SUB	#4, W15
;CT02_III.c,253 :: 		ECAN1SetFilter(_ECAN_FILTER_3, LSM_PGA_2, _ECAN_MASK_0, _ECAN_RX_BUFFER_5, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
	CLR	W13
	MOV	#2030, W11
	MOV	#0, W12
	MOV	#3, W10
	MOV	#247, W0
	PUSH	W0
	MOV	#5, W0
	PUSH	W0
	CALL	_ECAN1SetFilter
	SUB	#4, W15
;CT02_III.c,254 :: 		ECAN1SetFilter(_ECAN_FILTER_4, BSM_ANA_1, _ECAN_MASK_0, _ECAN_RX_BUFFER_6, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
	CLR	W13
	MOV	#3000, W11
	MOV	#0, W12
	MOV	#4, W10
	MOV	#247, W0
	PUSH	W0
	MOV	#6, W0
	PUSH	W0
	CALL	_ECAN1SetFilter
	SUB	#4, W15
;CT02_III.c,255 :: 		ECAN1SetFilter(_ECAN_FILTER_5, BSM_ANA_2, _ECAN_MASK_0, _ECAN_RX_BUFFER_7, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
	CLR	W13
	MOV	#3010, W11
	MOV	#0, W12
	MOV	#5, W10
	MOV	#247, W0
	PUSH	W0
	MOV	#7, W0
	PUSH	W0
	CALL	_ECAN1SetFilter
	SUB	#4, W15
;CT02_III.c,256 :: 		ECAN1SetFilter(_ECAN_FILTER_6, BSM_ANA_3, _ECAN_MASK_0, _ECAN_RX_BUFFER_8, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
	CLR	W13
	MOV	#3030, W11
	MOV	#0, W12
	MOV	#6, W10
	MOV	#247, W0
	PUSH	W0
	MOV	#8, W0
	PUSH	W0
	CALL	_ECAN1SetFilter
	SUB	#4, W15
;CT02_III.c,257 :: 		ECAN1SetFilter(_ECAN_FILTER_7, BSM_DIG_1, _ECAN_MASK_0, _ECAN_RX_BUFFER_9, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
	CLR	W13
	MOV	#3040, W11
	MOV	#0, W12
	MOV	#7, W10
	MOV	#247, W0
	PUSH	W0
	MOV	#9, W0
	PUSH	W0
	CALL	_ECAN1SetFilter
	SUB	#4, W15
;CT02_III.c,258 :: 		ECAN1SetFilter(_ECAN_FILTER_8, BSM_DIG_2, _ECAN_MASK_1, _ECAN_RX_BUFFER_10, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
	MOV	#1, W13
	MOV	#3050, W11
	MOV	#0, W12
	MOV	#8, W10
	MOV	#247, W0
	PUSH	W0
	MOV	#10, W0
	PUSH	W0
	CALL	_ECAN1SetFilter
	SUB	#4, W15
;CT02_III.c,272 :: 		ECAN1SetOperationMode(_ECAN_MODE_NORMAL, 0xFF);  // set NORMAL mode
	MOV	#255, W11
	CLR	W10
	CALL	_ECAN1SetOperationMode
;CT02_III.c,273 :: 		}
L_end_InitCAN:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _InitCAN

_C1Interrupt:
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;CT02_III.c,277 :: 		void C1Interrupt(void) org 0x005A                            // ECAN event iterrupt
;CT02_III.c,279 :: 		IFS2bits.C1IF = 0;                                   // clear ECAN interrupt flag
	BCLR	IFS2bits, #3
;CT02_III.c,280 :: 		if(C1INTFbits.TBIF) {                                // was it tx interrupt?
	BTSS	C1INTFbits, #0
	GOTO	L_C1Interrupt0
;CT02_III.c,281 :: 		C1INTFbits.TBIF = 0;                             // if yes clear tx interrupt flag
	BCLR	C1INTFbits, #0
;CT02_III.c,282 :: 		}
L_C1Interrupt0:
;CT02_III.c,283 :: 		if(C1INTFbits.RBIF)
	BTSS	C1INTFbits, #1
	GOTO	L_C1Interrupt1
;CT02_III.c,286 :: 		C1INTFbits.RBIF = 0;                         // if yes clear rx interrupt flag
	BCLR	C1INTFbits, #1
;CT02_III.c,287 :: 		LED = 1;
	BSET	LATA10_bit, #10
;CT02_III.c,288 :: 		}
L_C1Interrupt1:
;CT02_III.c,289 :: 		}
L_end_C1Interrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	RETFIE
; end of _C1Interrupt

_interrupt_timer1:
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;CT02_III.c,291 :: 		void interrupt_timer1() iv IVT_ADDR_T1INTERRUPT {   // interrupt is generated by Timer1
;CT02_III.c,292 :: 		T1CON.F15 = 0;                     // Stop Timer 1
	BCLR	T1CON, #15
;CT02_III.c,293 :: 		ready = 1;                         // Colocar o flag para enviar os dados pela porta serial
	MOV	#1, W0
	MOV	W0, _ready
;CT02_III.c,294 :: 		TMR1 = 0xE795;                      //Valor anterior 0xE795
	MOV	#59285, W0
	MOV	WREG, TMR1
;CT02_III.c,296 :: 		IFS0.F3 = 0;                       // Clear Timer1 interrupt flag
	BCLR	IFS0, #3
;CT02_III.c,297 :: 		T1CON.F15 = 1;                     //Começar novamente o Timer1
	BSET	T1CON, #15
;CT02_III.c,298 :: 		}
L_end_interrupt_timer1:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	RETFIE
; end of _interrupt_timer1

_interrupt_timer5:
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;CT02_III.c,300 :: 		void interrupt_timer5() iv IVT_ADDR_T5INTERRUPT {   // interrupt is generated by Timer5 - GPS
;CT02_III.c,302 :: 		T5CONbits.TON = 0;                     // Stop Timer 5
	BCLR	T5CONbits, #15
;CT02_III.c,303 :: 		TMR5 = 0xF447;
	MOV	#62535, W0
	MOV	WREG, TMR5
;CT02_III.c,304 :: 		tempo_msg++;
	MOV	#1, W1
	MOV	#lo_addr(_tempo_msg), W0
	ADD	W1, [W0], [W0]
;CT02_III.c,305 :: 		while(U2STAbits.URXDA == 1)
L_interrupt_timer52:
	BTSS	U2STAbits, #0
	GOTO	L_interrupt_timer53
;CT02_III.c,307 :: 		LED = 1;
	BSET	LATA10_bit, #10
;CT02_III.c,308 :: 		txt[t++] = U2RXREG;
	MOV	#lo_addr(_txt), W1
	MOV	#lo_addr(_t), W0
	ADD	W1, [W0], W1
	MOV.B	U2RXREG, WREG
	MOV.B	W0, [W1]
	MOV	#1, W1
	MOV	#lo_addr(_t), W0
	ADD	W1, [W0], [W0]
;CT02_III.c,309 :: 		if (txt[t-1] == 0)
	MOV	_t, W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_txt), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interrupt_timer584
	GOTO	L_interrupt_timer54
L__interrupt_timer584:
;CT02_III.c,311 :: 		t = 0;
	CLR	W0
	MOV	W0, _t
;CT02_III.c,312 :: 		}
L_interrupt_timer54:
;CT02_III.c,313 :: 		if (t == 768)
	MOV	_t, W1
	MOV	#768, W0
	CP	W1, W0
	BRA Z	L__interrupt_timer585
	GOTO	L_interrupt_timer55
L__interrupt_timer585:
;CT02_III.c,315 :: 		t = 0;
	CLR	W0
	MOV	W0, _t
;CT02_III.c,317 :: 		}
L_interrupt_timer55:
;CT02_III.c,318 :: 		}
	GOTO	L_interrupt_timer52
L_interrupt_timer53:
;CT02_III.c,320 :: 		if(tempo_msg == 5)
	MOV	_tempo_msg, W0
	CP	W0, #5
	BRA Z	L__interrupt_timer586
	GOTO	L_interrupt_timer56
L__interrupt_timer586:
;CT02_III.c,322 :: 		gps_ready = 1;
	MOV	#1, W0
	MOV	W0, _gps_ready
;CT02_III.c,323 :: 		tempo_msg = 0;
	CLR	W0
	MOV	W0, _tempo_msg
;CT02_III.c,325 :: 		}
L_interrupt_timer56:
;CT02_III.c,326 :: 		T5CONbits.TON = 1;                     // Start Timer 5
	BSET	T5CONbits, #15
;CT02_III.c,327 :: 		T5IF_bit = 0;                       // Clear Timer5 interrupt flag
	BCLR	T5IF_bit, #12
;CT02_III.c,328 :: 		}
L_end_interrupt_timer5:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	RETFIE
; end of _interrupt_timer5

_U2RXInterrupt:
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;CT02_III.c,330 :: 		void U2RXInterrupt(void) iv 0x0050   { // interrupt is generated by UART receive
;CT02_III.c,332 :: 		LED = 1;
	BSET	LATA10_bit, #10
;CT02_III.c,362 :: 		U2RXIF_bit = 0;                       // Clear UART receive interrupt flag
	BCLR	U2RXIF_bit, #14
;CT02_III.c,364 :: 		}
L_end_U2RXInterrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	RETFIE
; end of _U2RXInterrupt

_InputCapture1Int:
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;CT02_III.c,366 :: 		void InputCapture1Int() iv IVT_ADDR_IC1INTERRUPT //RPM
;CT02_III.c,368 :: 		t1=IC1BUF;
	MOV	IC1BUF, WREG
	MOV	W0, _t1
;CT02_III.c,369 :: 		t2=IC1BUF;
	MOV	IC1BUF, WREG
	MOV	W0, _t2
;CT02_III.c,370 :: 		IC1IF_bit=0;
	BCLR	IC1IF_bit, #1
;CT02_III.c,371 :: 		if(t2>t1)
	MOV	_t2, W1
	MOV	#lo_addr(_t1), W0
	CP	W1, [W0]
	BRA GTU	L__InputCapture1Int89
	GOTO	L_InputCapture1Int7
L__InputCapture1Int89:
;CT02_III.c,372 :: 		GPIN1_FSM = t2-t1;
	MOV	_t2, W2
	MOV	#lo_addr(_t1), W1
	MOV	#lo_addr(_GPIN1_FSM), W0
	SUB	W2, [W1], [W0]
	GOTO	L_InputCapture1Int8
L_InputCapture1Int7:
;CT02_III.c,374 :: 		GPIN1_FSM = (PR2 - t1) + t2;
	MOV	PR2, W1
	MOV	#lo_addr(_t1), W0
	SUB	W1, [W0], W2
	MOV	#lo_addr(_t2), W1
	MOV	#lo_addr(_GPIN1_FSM), W0
	ADD	W2, [W1], [W0]
L_InputCapture1Int8:
;CT02_III.c,375 :: 		}
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

;CT02_III.c,377 :: 		void InputCapture2Int() iv IVT_ADDR_IC2INTERRUPT //(Velocidade)
;CT02_III.c,379 :: 		t1=IC2BUF;
	MOV	IC2BUF, WREG
	MOV	W0, _t1
;CT02_III.c,380 :: 		t2=IC2BUF;
	MOV	IC2BUF, WREG
	MOV	W0, _t2
;CT02_III.c,381 :: 		IC2IF_bit=0;
	BCLR	IC2IF_bit, #5
;CT02_III.c,382 :: 		if(t2>t1)
	MOV	_t2, W1
	MOV	#lo_addr(_t1), W0
	CP	W1, [W0]
	BRA GTU	L__InputCapture2Int91
	GOTO	L_InputCapture2Int9
L__InputCapture2Int91:
;CT02_III.c,383 :: 		GPIN2_FSM = t2-t1;
	MOV	_t2, W2
	MOV	#lo_addr(_t1), W1
	MOV	#lo_addr(_GPIN2_FSM), W0
	SUB	W2, [W1], [W0]
	GOTO	L_InputCapture2Int10
L_InputCapture2Int9:
;CT02_III.c,385 :: 		GPIN2_FSM = (PR2 - t1) + t2;
	MOV	PR2, W1
	MOV	#lo_addr(_t1), W0
	SUB	W1, [W0], W2
	MOV	#lo_addr(_t2), W1
	MOV	#lo_addr(_GPIN2_FSM), W0
	ADD	W2, [W1], [W0]
L_InputCapture2Int10:
;CT02_III.c,386 :: 		}
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

;CT02_III.c,388 :: 		void InputCapture7Int() iv IVT_ADDR_IC7INTERRUPT //RPM
;CT02_III.c,390 :: 		t1=IC7BUF;
	MOV	IC7BUF, WREG
	MOV	W0, _t1
;CT02_III.c,391 :: 		t2=IC7BUF;
	MOV	IC7BUF, WREG
	MOV	W0, _t2
;CT02_III.c,392 :: 		IC7IF_bit=0;
	BCLR	IC7IF_bit, #6
;CT02_III.c,393 :: 		if(t2>t1)
	MOV	_t2, W1
	MOV	#lo_addr(_t1), W0
	CP	W1, [W0]
	BRA GTU	L__InputCapture7Int93
	GOTO	L_InputCapture7Int11
L__InputCapture7Int93:
;CT02_III.c,394 :: 		GPIN3_FSM = t2-t1;
	MOV	_t2, W2
	MOV	#lo_addr(_t1), W1
	MOV	#lo_addr(_GPIN3_FSM), W0
	SUB	W2, [W1], [W0]
	GOTO	L_InputCapture7Int12
L_InputCapture7Int11:
;CT02_III.c,396 :: 		GPIN3_FSM = (PR3 - t1) + t2;
	MOV	PR3, W1
	MOV	#lo_addr(_t1), W0
	SUB	W1, [W0], W2
	MOV	#lo_addr(_t2), W1
	MOV	#lo_addr(_GPIN3_FSM), W0
	ADD	W2, [W1], [W0]
L_InputCapture7Int12:
;CT02_III.c,397 :: 		}
L_end_InputCapture7Int:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	RETFIE
; end of _InputCapture7Int

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;CT02_III.c,399 :: 		void main()
;CT02_III.c,401 :: 		LED = 1;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BSET	LATA10_bit, #10
;CT02_III.c,402 :: 		InitClock();
	CALL	_InitClock
;CT02_III.c,403 :: 		InitPorts();
	CALL	_InitPorts
;CT02_III.c,404 :: 		InitTimersCapture();
	CALL	_InitTimersCapture
;CT02_III.c,405 :: 		InitCAN();
	CALL	_InitCAN
;CT02_III.c,406 :: 		InitMain();
	CALL	_InitMain
;CT02_III.c,407 :: 		ready = 0;
	CLR	W0
	MOV	W0, _ready
;CT02_III.c,408 :: 		Delay_ms(1000);
	MOV	#204, W8
	MOV	#29592, W7
L_main13:
	DEC	W7
	BRA NZ	L_main13
	DEC	W8
	BRA NZ	L_main13
;CT02_III.c,409 :: 		LED = 0;
	BCLR	LATA10_bit, #10
;CT02_III.c,411 :: 		tempo_msg = 0;
	CLR	W0
	MOV	W0, _tempo_msg
;CT02_III.c,412 :: 		t = 0;
	CLR	W0
	MOV	W0, _t
;CT02_III.c,414 :: 		while(1)
L_main15:
;CT02_III.c,416 :: 		U2STA.F1 = 0;                  // Set OERR to 0
	BCLR	U2STA, #1
;CT02_III.c,417 :: 		U2STA.F2 = 0;                  // Set FERR to 0
	BCLR	U2STA, #2
;CT02_III.c,424 :: 		for( i = 0; i<=3; i++)
	CLR	W0
	MOV	W0, _i
L_main17:
	MOV	_i, W0
	CP	W0, #3
	BRA LEU	L__main95
	GOTO	L_main18
L__main95:
;CT02_III.c,426 :: 		Msg_Rcvd = ECAN1Read(&Rx_ID , RxTx_Data , &Rx_Data_Len, &Can_Rcv_Flags);  // receive message
	MOV	#lo_addr(_Can_Rcv_Flags), W13
	MOV	#lo_addr(_Rx_Data_Len), W12
	MOV	#lo_addr(_RxTx_Data), W11
	MOV	#lo_addr(_Rx_ID), W10
	CALL	_ECAN1Read
	MOV	W0, _Msg_Rcvd
;CT02_III.c,427 :: 		if(Msg_Rcvd)
	CP0	W0
	BRA NZ	L__main96
	GOTO	L_main20
L__main96:
;CT02_III.c,429 :: 		LED = 1;
	BSET	LATA10_bit, #10
;CT02_III.c,430 :: 		switch(Rx_ID)
	GOTO	L_main21
;CT02_III.c,432 :: 		case LSM_ELET_1:
L_main23:
;CT02_III.c,434 :: 		Hi(ICAN_BUS_LSM) = RxTx_Data[0];
	MOV	#lo_addr(_ICAN_BUS_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data), W0
	MOV.B	[W0], [W1]
;CT02_III.c,435 :: 		Lo(ICAN_BUS_LSM) = RxTx_Data[1];
	MOV	#lo_addr(_ICAN_BUS_LSM), W1
	MOV	#lo_addr(_RxTx_Data+1), W0
	MOV.B	[W0], [W1]
;CT02_III.c,436 :: 		Hi(GPIN0_LSM) = RxTx_Data[2];
	MOV	#lo_addr(_GPIN0_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data+2), W0
	MOV.B	[W0], [W1]
;CT02_III.c,437 :: 		Lo(GPIN0_LSM) = RxTx_Data[3];
	MOV	#lo_addr(_GPIN0_LSM), W1
	MOV	#lo_addr(_RxTx_Data+3), W0
	MOV.B	[W0], [W1]
;CT02_III.c,438 :: 		Hi(GPIN1_LSM) = RxTx_Data[4];
	MOV	#lo_addr(_GPIN1_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data+4), W0
	MOV.B	[W0], [W1]
;CT02_III.c,439 :: 		Lo(GPIN1_LSM) = RxTx_Data[5];
	MOV	#lo_addr(_GPIN1_LSM), W1
	MOV	#lo_addr(_RxTx_Data+5), W0
	MOV.B	[W0], [W1]
;CT02_III.c,440 :: 		Hi(GPIN2_LSM) = RxTx_Data[6];
	MOV	#lo_addr(_GPIN2_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data+6), W0
	MOV.B	[W0], [W1]
;CT02_III.c,441 :: 		Lo(GPIN2_LSM) = RxTx_Data[7];
	MOV	#lo_addr(_GPIN2_LSM), W1
	MOV	#lo_addr(_RxTx_Data+7), W0
	MOV.B	[W0], [W1]
;CT02_III.c,442 :: 		LED = 1;
	BSET	LATA10_bit, #10
;CT02_III.c,443 :: 		break;
	GOTO	L_main22
;CT02_III.c,445 :: 		case LSM_ELET_2:
L_main24:
;CT02_III.c,447 :: 		Hi(GPIN3_LSM) = RxTx_Data[0];
	MOV	#lo_addr(_GPIN3_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data), W0
	MOV.B	[W0], [W1]
;CT02_III.c,448 :: 		Lo(GPIN3_LSM) = RxTx_Data[1];
	MOV	#lo_addr(_GPIN3_LSM), W1
	MOV	#lo_addr(_RxTx_Data+1), W0
	MOV.B	[W0], [W1]
;CT02_III.c,449 :: 		Hi(GPIN4_LSM) = RxTx_Data[2];
	MOV	#lo_addr(_GPIN4_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data+2), W0
	MOV.B	[W0], [W1]
;CT02_III.c,450 :: 		Lo(GPIN4_LSM) = RxTx_Data[3];
	MOV	#lo_addr(_GPIN4_LSM), W1
	MOV	#lo_addr(_RxTx_Data+3), W0
	MOV.B	[W0], [W1]
;CT02_III.c,451 :: 		Hi(GPIN5_LSM) = RxTx_Data[4];
	MOV	#lo_addr(_GPIN5_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data+4), W0
	MOV.B	[W0], [W1]
;CT02_III.c,452 :: 		Lo(GPIN5_LSM) = RxTx_Data[5];
	MOV	#lo_addr(_GPIN5_LSM), W1
	MOV	#lo_addr(_RxTx_Data+5), W0
	MOV.B	[W0], [W1]
;CT02_III.c,453 :: 		Hi(DIG1_LSM) = RxTx_Data[6];
	MOV	#lo_addr(_DIG1_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data+6), W0
	MOV.B	[W0], [W1]
;CT02_III.c,454 :: 		Lo(DIG1_LSM) = RxTx_Data[7];
	MOV	#lo_addr(_DIG1_LSM), W1
	MOV	#lo_addr(_RxTx_Data+7), W0
	MOV.B	[W0], [W1]
;CT02_III.c,455 :: 		break;
	GOTO	L_main22
;CT02_III.c,457 :: 		case LSM_PGA_1:
L_main25:
;CT02_III.c,459 :: 		Hi(PGA0_LSM) = RxTx_Data[0];
	MOV	#lo_addr(_PGA0_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data), W0
	MOV.B	[W0], [W1]
;CT02_III.c,460 :: 		Lo(PGA0_LSM) = RxTx_Data[1];
	MOV	#lo_addr(_PGA0_LSM), W1
	MOV	#lo_addr(_RxTx_Data+1), W0
	MOV.B	[W0], [W1]
;CT02_III.c,461 :: 		Hi(PGA1_LSM) = RxTx_Data[2];
	MOV	#lo_addr(_PGA1_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data+2), W0
	MOV.B	[W0], [W1]
;CT02_III.c,462 :: 		Lo(PGA1_LSM) = RxTx_Data[3];
	MOV	#lo_addr(_PGA1_LSM), W1
	MOV	#lo_addr(_RxTx_Data+3), W0
	MOV.B	[W0], [W1]
;CT02_III.c,463 :: 		Hi(PGA2_LSM) = RxTx_Data[4];
	MOV	#lo_addr(_PGA2_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data+4), W0
	MOV.B	[W0], [W1]
;CT02_III.c,464 :: 		Lo(PGA2_LSM) = RxTx_Data[5];
	MOV	#lo_addr(_PGA2_LSM), W1
	MOV	#lo_addr(_RxTx_Data+5), W0
	MOV.B	[W0], [W1]
;CT02_III.c,465 :: 		Hi(PGA3_LSM) = RxTx_Data[6];
	MOV	#lo_addr(_PGA3_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data+6), W0
	MOV.B	[W0], [W1]
;CT02_III.c,466 :: 		Lo(PGA3_LSM) = RxTx_Data[7];
	MOV	#lo_addr(_PGA3_LSM), W1
	MOV	#lo_addr(_RxTx_Data+7), W0
	MOV.B	[W0], [W1]
;CT02_III.c,467 :: 		break;
	GOTO	L_main22
;CT02_III.c,469 :: 		case LSM_PGA_2:
L_main26:
;CT02_III.c,471 :: 		Hi(PGA4_LSM) = RxTx_Data[0];
	MOV	#lo_addr(_PGA4_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data), W0
	MOV.B	[W0], [W1]
;CT02_III.c,472 :: 		Lo(PGA4_LSM) = RxTx_Data[1];
	MOV	#lo_addr(_PGA4_LSM), W1
	MOV	#lo_addr(_RxTx_Data+1), W0
	MOV.B	[W0], [W1]
;CT02_III.c,473 :: 		Hi(PGA5_LSM) = RxTx_Data[2];
	MOV	#lo_addr(_PGA5_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data+2), W0
	MOV.B	[W0], [W1]
;CT02_III.c,474 :: 		Lo(PGA5_LSM) = RxTx_Data[3];
	MOV	#lo_addr(_PGA5_LSM), W1
	MOV	#lo_addr(_RxTx_Data+3), W0
	MOV.B	[W0], [W1]
;CT02_III.c,475 :: 		Hi(PGA_0123_GAIN_LSM) = RxTx_Data[4];
	MOV	#lo_addr(_PGA_0123_GAIN_LSM+1), W1
	MOV	#lo_addr(_RxTx_Data+4), W0
	MOV.B	[W0], [W1]
;CT02_III.c,476 :: 		Lo(PGA_0123_GAIN_LSM) = RxTx_Data[5];
	MOV	#lo_addr(_PGA_0123_GAIN_LSM), W1
	MOV	#lo_addr(_RxTx_Data+5), W0
	MOV.B	[W0], [W1]
;CT02_III.c,477 :: 		PGA_45_GAIN_LSM = RxTx_Data[6];
	MOV	#lo_addr(_PGA_45_Gain_LSM), W1
	MOV	#lo_addr(_RxTx_Data+6), W0
	MOV.B	[W0], [W1]
;CT02_III.c,478 :: 		break;
	GOTO	L_main22
;CT02_III.c,578 :: 		}
L_main21:
	MOV	_Rx_ID, W2
	MOV	_Rx_ID+2, W3
	MOV	#2000, W0
	MOV	#0, W1
	CP	W2, W0
	CPB	W3, W1
	BRA NZ	L__main97
	GOTO	L_main23
L__main97:
	MOV	_Rx_ID, W2
	MOV	_Rx_ID+2, W3
	MOV	#2010, W0
	MOV	#0, W1
	CP	W2, W0
	CPB	W3, W1
	BRA NZ	L__main98
	GOTO	L_main24
L__main98:
	MOV	_Rx_ID, W2
	MOV	_Rx_ID+2, W3
	MOV	#2020, W0
	MOV	#0, W1
	CP	W2, W0
	CPB	W3, W1
	BRA NZ	L__main99
	GOTO	L_main25
L__main99:
	MOV	_Rx_ID, W2
	MOV	_Rx_ID+2, W3
	MOV	#2030, W0
	MOV	#0, W1
	CP	W2, W0
	CPB	W3, W1
	BRA NZ	L__main100
	GOTO	L_main26
L__main100:
L_main22:
;CT02_III.c,580 :: 		}
L_main20:
;CT02_III.c,424 :: 		for( i = 0; i<=3; i++)
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;CT02_III.c,581 :: 		}
	GOTO	L_main17
L_main18:
;CT02_III.c,603 :: 		if(gps_ready == 1)                 // if the data in txt array is ready do
	MOV	_gps_ready, W0
	CP	W0, #1
	BRA Z	L__main101
	GOTO	L_main27
L__main101:
;CT02_III.c,605 :: 		gps_ready = 0;
	CLR	W0
	MOV	W0, _gps_ready
;CT02_III.c,606 :: 		res = GPS_Parse(&txt);
	MOV	#lo_addr(_txt), W10
	CALL	_GPS_Parse
	MOV	W0, _res
;CT02_III.c,607 :: 		}
L_main27:
;CT02_III.c,611 :: 		if(ready == 1){
	MOV	_ready, W0
	CP	W0, #1
	BRA Z	L__main102
	GOTO	L_main28
L__main102:
;CT02_III.c,613 :: 		GPIN0_FSM = ADC1_Get_Sample(GPIN_0);    // 0 a 5V  (mistura rica/pobre)
	MOV	#6, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _GPIN0_FSM
;CT02_III.c,614 :: 		GPIN4_FSM = ADC1_Get_Sample(GPIN_4);    // 0 a 3,3V
	MOV	#9, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _GPIN4_FSM
;CT02_III.c,615 :: 		GPIN5_FSM = RC9_bit;                    // 0/12V Digital
	MOV	#lo_addr(_GPIN5_FSM), W0
	CLR	[W0]
	BTSC	RC9_bit, #9
	INC	[W0], [W0]
;CT02_III.c,616 :: 		GPIN6_FSM = ADC1_Get_Sample(GPIN_6);   // 0 a 3,3V
	CLR	W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _GPIN6_FSM
;CT02_III.c,618 :: 		BOTAO_1_2_FSM =  0;
	CLR	W0
	MOV	W0, _BOTAO_1_2_FSM
;CT02_III.c,620 :: 		INT_ACCEL_X_FSM = ADC1_Get_Sample(ACCEL_X);
	MOV	#10, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _INT_ACCEL_X_FSM
;CT02_III.c,621 :: 		INT_ACCEL_Y_FSM = ADC1_Get_Sample(ACCEL_Y);
	MOV	#12, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _INT_ACCEL_Y_FSM
;CT02_III.c,622 :: 		INT_ACCEL_Z_FSM = ADC1_Get_Sample(ACCEL_Z);
	MOV	#11, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _INT_ACCEL_Z_FSM
;CT02_III.c,624 :: 		ADXL_POS_NEG_FSM = 0;
	CLR	W0
	MOV	W0, _ADXL_POS_NEG_FSM
;CT02_III.c,626 :: 		ADXL345_Read_XYZ(&values);
	MOV	#lo_addr(_values), W10
	CALL	_ADXL345_Read_XYZ
;CT02_III.c,628 :: 		AdxlX = ((int)values[1]<<8)|(int)values[0];
	MOV	#lo_addr(_values+1), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_values), W0
	ZE	[W0], W0
	IOR	W1, W0, W3
	MOV	W3, _AdxlX
;CT02_III.c,630 :: 		AdxlY = ((int)values[3]<<8)|(int)values[2];
	MOV	#lo_addr(_values+3), W0
	ZE	[W0], W0
	SL	W0, #8, W2
	MOV	#lo_addr(_values+2), W0
	ZE	[W0], W1
	MOV	#lo_addr(_AdxlY), W0
	IOR	W2, W1, [W0]
;CT02_III.c,632 :: 		AdxlZ = ((int)values[5]<<8)|(int)values[4];
	MOV	#lo_addr(_values+5), W0
	ZE	[W0], W0
	SL	W0, #8, W2
	MOV	#lo_addr(_values+4), W0
	ZE	[W0], W1
	MOV	#lo_addr(_AdxlZ), W0
	IOR	W2, W1, [W0]
;CT02_III.c,634 :: 		if((AdxlX==0)&&(AdxlY==0)&&(AdxlZ==0))
	CP	W3, #0
	BRA Z	L__main103
	GOTO	L__main79
L__main103:
	MOV	_AdxlY, W0
	CP	W0, #0
	BRA Z	L__main104
	GOTO	L__main78
L__main104:
	MOV	_AdxlZ, W0
	CP	W0, #0
	BRA Z	L__main105
	GOTO	L__main77
L__main105:
L__main76:
;CT02_III.c,637 :: 		ADXL345_Init();
	CALL	_ADXL345_Init
;CT02_III.c,639 :: 		ADXL345_Read_XYZ(&values);
	MOV	#lo_addr(_values), W10
	CALL	_ADXL345_Read_XYZ
;CT02_III.c,643 :: 		AdxlX = ((int)values[1]<<8)|(int)values[0];
	MOV	#lo_addr(_values+1), W0
	ZE	[W0], W0
	SL	W0, #8, W2
	MOV	#lo_addr(_values), W0
	ZE	[W0], W1
	MOV	#lo_addr(_AdxlX), W0
	IOR	W2, W1, [W0]
;CT02_III.c,645 :: 		AdxlY = ((int)values[3]<<8)|(int)values[2];
	MOV	#lo_addr(_values+3), W0
	ZE	[W0], W0
	SL	W0, #8, W2
	MOV	#lo_addr(_values+2), W0
	ZE	[W0], W1
	MOV	#lo_addr(_AdxlY), W0
	IOR	W2, W1, [W0]
;CT02_III.c,647 :: 		AdxlZ = ((int)values[5]<<8)|(int)values[4];
	MOV	#lo_addr(_values+5), W0
	ZE	[W0], W0
	SL	W0, #8, W2
	MOV	#lo_addr(_values+4), W0
	ZE	[W0], W1
	MOV	#lo_addr(_AdxlZ), W0
	IOR	W2, W1, [W0]
;CT02_III.c,649 :: 		STATUS_ACCEL_FSM = 0;
	CLR	W0
	MOV	W0, _STATUS_ACCEL_FSM
;CT02_III.c,650 :: 		}
	GOTO	L_main32
;CT02_III.c,634 :: 		if((AdxlX==0)&&(AdxlY==0)&&(AdxlZ==0))
L__main79:
L__main78:
L__main77:
;CT02_III.c,653 :: 		STATUS_ACCEL_FSM = 1;
	MOV	#1, W0
	MOV	W0, _STATUS_ACCEL_FSM
;CT02_III.c,654 :: 		}
L_main32:
;CT02_III.c,656 :: 		if(AdxlX < 0)
	MOV	_AdxlX, W0
	CP	W0, #0
	BRA LT	L__main106
	GOTO	L_main33
L__main106:
;CT02_III.c,658 :: 		ADXL_X_FSM = abs(AdxlX);
	MOV	_AdxlX, W10
	CALL	_abs
	MOV	W0, _ADXL_X_FSM
;CT02_III.c,659 :: 		ADXL_POS_NEG_FSM |= 0b001;
	MOV	#1, W1
	MOV	#lo_addr(_ADXL_POS_NEG_FSM), W0
	IOR	W1, [W0], [W0]
;CT02_III.c,660 :: 		}
	GOTO	L_main34
L_main33:
;CT02_III.c,663 :: 		ADXL_X_FSM = AdxlX;
	MOV	_AdxlX, W0
	MOV	W0, _ADXL_X_FSM
;CT02_III.c,664 :: 		}
L_main34:
;CT02_III.c,666 :: 		if(AdxlY < 0)
	MOV	_AdxlY, W0
	CP	W0, #0
	BRA LT	L__main107
	GOTO	L_main35
L__main107:
;CT02_III.c,668 :: 		ADXL_Y_FSM = abs(AdxlY);
	MOV	_AdxlY, W10
	CALL	_abs
	MOV	W0, _ADXL_Y_FSM
;CT02_III.c,669 :: 		ADXL_POS_NEG_FSM |= 0b010;
	MOV	#2, W1
	MOV	#lo_addr(_ADXL_POS_NEG_FSM), W0
	IOR	W1, [W0], [W0]
;CT02_III.c,670 :: 		}
	GOTO	L_main36
L_main35:
;CT02_III.c,673 :: 		ADXL_Y_FSM = AdxlY;
	MOV	_AdxlY, W0
	MOV	W0, _ADXL_Y_FSM
;CT02_III.c,674 :: 		}
L_main36:
;CT02_III.c,676 :: 		if(AdxlZ < 0)
	MOV	_AdxlZ, W0
	CP	W0, #0
	BRA LT	L__main108
	GOTO	L_main37
L__main108:
;CT02_III.c,678 :: 		ADXL_Z_FSM = abs(AdxlZ);
	MOV	_AdxlZ, W10
	CALL	_abs
	MOV	W0, _ADXL_Z_FSM
;CT02_III.c,679 :: 		ADXL_POS_NEG_FSM |= 0b100;
	MOV	#4, W1
	MOV	#lo_addr(_ADXL_POS_NEG_FSM), W0
	IOR	W1, [W0], [W0]
;CT02_III.c,680 :: 		}
	GOTO	L_main38
L_main37:
;CT02_III.c,683 :: 		ADXL_Z_FSM = AdxlZ;
	MOV	_AdxlZ, W0
	MOV	W0, _ADXL_Z_FSM
;CT02_III.c,684 :: 		}
L_main38:
;CT02_III.c,688 :: 		LED = 0;
	BCLR	LATA10_bit, #10
;CT02_III.c,689 :: 		Write_UART_UDATA(ID_FSM_ACCEL1, ADXL_X_FSM, ADXL_Y_FSM, ADXL_Z_FSM, ADXL_POS_NEG_FSM);
	MOV	_ADXL_Z_FSM, W13
	MOV	_ADXL_Y_FSM, W12
	MOV	_ADXL_X_FSM, W11
	MOV	#lo_addr(_ID_FSM_ACCEL1), W10
	PUSH	_ADXL_POS_NEG_FSM
	CALL	_Write_UART_UDATA
	SUB	#2, W15
;CT02_III.c,690 :: 		Write_UART_UDATA(ID_FSM_ACCEL2, INT_ACCEL_X_FSM, INT_ACCEL_Y_FSM, INT_ACCEL_Z_FSM, STATUS_ACCEL_FSM);
	MOV	_INT_ACCEL_Z_FSM, W13
	MOV	_INT_ACCEL_Y_FSM, W12
	MOV	_INT_ACCEL_X_FSM, W11
	MOV	#lo_addr(_ID_FSM_ACCEL2), W10
	PUSH	_STATUS_ACCEL_FSM
	CALL	_Write_UART_UDATA
	SUB	#2, W15
;CT02_III.c,691 :: 		Write_UART_UDATA(ID_FSM_GPIO1, GPIN0_FSM, GPIN1_FSM, GPIN2_FSM, GPIN3_FSM);
	MOV	_GPIN2_FSM, W13
	MOV	_GPIN1_FSM, W12
	MOV	_GPIN0_FSM, W11
	MOV	#lo_addr(_ID_FSM_GPIO1), W10
	PUSH	_GPIN3_FSM
	CALL	_Write_UART_UDATA
	SUB	#2, W15
;CT02_III.c,692 :: 		Write_UART_UDATA(ID_FSM_GPIO2, GPIN4_FSM, GPIN5_FSM, GPIN6_FSM, BOTAO_1_2_FSM);
	MOV	_GPIN6_FSM, W13
	MOV	_GPIN5_FSM, W12
	MOV	_GPIN4_FSM, W11
	MOV	#lo_addr(_ID_FSM_GPIO2), W10
	PUSH	_BOTAO_1_2_FSM
	CALL	_Write_UART_UDATA
	SUB	#2, W15
;CT02_III.c,693 :: 		Write_UART_UDATA(ID_LSM_ELET_1, ICAN_BUS_LSM, GPIN0_LSM, GPIN1_LSM, GPIN2_LSM);
	MOV	_GPIN1_LSM, W13
	MOV	_GPIN0_LSM, W12
	MOV	_ICAN_BUS_LSM, W11
	MOV	#lo_addr(_ID_LSM_ELET_1), W10
	PUSH	_GPIN2_LSM
	CALL	_Write_UART_UDATA
	SUB	#2, W15
;CT02_III.c,694 :: 		Write_UART_UDATA(ID_LSM_ELET_2, GPIN3_LSM, GPIN4_LSM, GPIN5_LSM, DIG1_LSM);
	MOV	_GPIN5_LSM, W13
	MOV	_GPIN4_LSM, W12
	MOV	_GPIN3_LSM, W11
	MOV	#lo_addr(_ID_LSM_ELET_2), W10
	PUSH	_DIG1_LSM
	CALL	_Write_UART_UDATA
	SUB	#2, W15
;CT02_III.c,695 :: 		Write_UART_UDATA(ID_LSM_PGA_1, PGA0_LSM, PGA1_LSM, PGA2_LSM, PGA3_LSM);
	MOV	_PGA2_LSM, W13
	MOV	_PGA1_LSM, W12
	MOV	_PGA0_LSM, W11
	MOV	#lo_addr(_ID_LSM_PGA_1), W10
	PUSH	_PGA3_LSM
	CALL	_Write_UART_UDATA
	SUB	#2, W15
;CT02_III.c,696 :: 		Write_UART_UDATA(ID_LSM_PGA_2, PGA5_LSM, PGA6_LSM, PGA_0123_GAIN_LSM, PGA_45_GAIN_LSM);
	MOV	_PGA_0123_GAIN_LSM, W13
	MOV	_PGA6_LSM, W12
	MOV	_PGA5_LSM, W11
	MOV	#lo_addr(_ID_LSM_PGA_2), W10
	MOV	#lo_addr(_PGA_45_Gain_LSM), W0
	ZE	[W0], W0
	PUSH	W0
	CALL	_Write_UART_UDATA
	SUB	#2, W15
;CT02_III.c,702 :: 		if(res == 1)
	MOV	_res, W0
	CP	W0, #1
	BRA Z	L__main109
	GOTO	L_main39
L__main109:
;CT02_III.c,704 :: 		UART1_Write_Text(ID_GPS_1);
	MOV	#lo_addr(_ID_GPS_1), W10
	CALL	_UART1_Write_Text
;CT02_III.c,705 :: 		UART1_Write_Text(LATITUDE_INT_GPS);
	MOV	#lo_addr(_LATITUDE_INT_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,706 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;CT02_III.c,707 :: 		UART1_Write_Text(LATITUDE_FRAC_GPS);
	MOV	#lo_addr(_LATITUDE_FRAC_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,708 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;CT02_III.c,709 :: 		UART1_Write_Text(LONGITUDE_INT_GPS);
	MOV	#lo_addr(_LONGITUDE_INT_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,710 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;CT02_III.c,711 :: 		UART1_Write_Text(LONGITUDE_FRAC_GPS);
	MOV	#lo_addr(_LONGITUDE_FRAC_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,712 :: 		UART1_Write(';');
	MOV	#59, W10
	CALL	_UART1_Write
;CT02_III.c,713 :: 		UART1_Write(0X0D);
	MOV	#13, W10
	CALL	_UART1_Write
;CT02_III.c,714 :: 		UART1_Write(0X0A);
	MOV	#10, W10
	CALL	_UART1_Write
;CT02_III.c,716 :: 		UART1_Write_Text(ID_GPS_2);
	MOV	#lo_addr(_ID_GPS_2), W10
	CALL	_UART1_Write_Text
;CT02_III.c,717 :: 		UART1_Write_Text(N_S_E_W_GPS);
	MOV	#lo_addr(_N_S_E_W_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,718 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;CT02_III.c,719 :: 		UART1_Write_Text(VEL_X100_GPS);
	MOV	#lo_addr(_VEL_X100_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,720 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;CT02_III.c,721 :: 		UART1_Write_Text(DIRECAO_X100_GPS);
	MOV	#lo_addr(_DIRECAO_X100_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,722 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;CT02_III.c,723 :: 		UART1_Write_Text(STATUS_CHECKSUM_GPS);
	MOV	#lo_addr(_STATUS_CHECKSUM_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,724 :: 		UART1_Write(';');
	MOV	#59, W10
	CALL	_UART1_Write
;CT02_III.c,725 :: 		UART1_Write(0X0D);
	MOV	#13, W10
	CALL	_UART1_Write
;CT02_III.c,726 :: 		UART1_Write(0X0A);
	MOV	#10, W10
	CALL	_UART1_Write
;CT02_III.c,740 :: 		UART1_Write_Text(ID_GPS_TIME_1);
	MOV	#lo_addr(_ID_GPS_TIME_1), W10
	CALL	_UART1_Write_Text
;CT02_III.c,741 :: 		UART1_Write_Text(DIA_GPS);
	MOV	#lo_addr(_DIA_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,742 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;CT02_III.c,743 :: 		UART1_Write_Text(MES_GPS);
	MOV	#lo_addr(_MES_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,744 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;CT02_III.c,745 :: 		UART1_Write_Text(ANO_GPS);
	MOV	#lo_addr(_ANO_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,746 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;CT02_III.c,747 :: 		UART1_Write_Text(HORA_GPS);
	MOV	#lo_addr(_HORA_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,748 :: 		UART1_Write(';');
	MOV	#59, W10
	CALL	_UART1_Write
;CT02_III.c,749 :: 		UART1_Write(0X0D);
	MOV	#13, W10
	CALL	_UART1_Write
;CT02_III.c,750 :: 		UART1_Write(0X0A);
	MOV	#10, W10
	CALL	_UART1_Write
;CT02_III.c,752 :: 		UART1_Write_Text(ID_GPS_TIME_2);
	MOV	#lo_addr(_ID_GPS_TIME_2), W10
	CALL	_UART1_Write_Text
;CT02_III.c,753 :: 		UART1_Write_Text(MINUTO_GPS);
	MOV	#lo_addr(_MINUTO_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,754 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;CT02_III.c,755 :: 		UART1_Write_Text(SEGUNDO_GPS);
	MOV	#lo_addr(_SEGUNDO_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,756 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;CT02_III.c,757 :: 		UART1_Write_Text(MILISEGUNDO_GPS);
	MOV	#lo_addr(_MILISEGUNDO_GPS), W10
	CALL	_UART1_Write_Text
;CT02_III.c,758 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;CT02_III.c,759 :: 		UART1_Write_Text("00000");
	MOV	#lo_addr(?lstr1_CT02_III), W10
	CALL	_UART1_Write_Text
;CT02_III.c,760 :: 		UART1_Write(';');
	MOV	#59, W10
	CALL	_UART1_Write
;CT02_III.c,761 :: 		UART1_Write(0X0D);
	MOV	#13, W10
	CALL	_UART1_Write
;CT02_III.c,762 :: 		UART1_Write(0X0A);
	MOV	#10, W10
	CALL	_UART1_Write
;CT02_III.c,765 :: 		res = 0;
	CLR	W0
	MOV	W0, _res
;CT02_III.c,766 :: 		}
L_main39:
;CT02_III.c,767 :: 		ready = 0;
	CLR	W0
	MOV	W0, _ready
;CT02_III.c,769 :: 		}
L_main28:
;CT02_III.c,772 :: 		}
	GOTO	L_main15
;CT02_III.c,773 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_GPS_Parse:

;CT02_III.c,775 :: 		unsigned int GPS_Parse(char *text)
;CT02_III.c,777 :: 		if((t>120)&&(t<680))
	PUSH	W10
	PUSH	W11
	MOV	#120, W1
	MOV	#lo_addr(_t), W0
	CP	W1, [W0]
	BRA LT	L__GPS_Parse112
	GOTO	L__GPS_Parse73
L__GPS_Parse112:
	MOV	_t, W1
	MOV	#680, W0
	CP	W1, W0
	BRA LT	L__GPS_Parse113
	GOTO	L__GPS_Parse72
L__GPS_Parse113:
L__GPS_Parse71:
;CT02_III.c,779 :: 		string = strstr(text[t-80],"$GPRMC");
	MOV	#80, W1
	MOV	#lo_addr(_t), W0
	SUBR	W1, [W0], W0
	ADD	W10, W0, W0
	MOV	#lo_addr(?lstr2_CT02_III), W11
	ZE	[W0], W10
	CALL	_strstr
	MOV	W0, _string
;CT02_III.c,780 :: 		}
	GOTO	L_GPS_Parse43
;CT02_III.c,777 :: 		if((t>120)&&(t<680))
L__GPS_Parse73:
L__GPS_Parse72:
;CT02_III.c,783 :: 		string = strstr(text,"$GPRMC");
	PUSH	W10
	MOV	#lo_addr(?lstr3_CT02_III), W11
	CALL	_strstr
	POP	W10
	MOV	W0, _string
;CT02_III.c,784 :: 		}
L_GPS_Parse43:
;CT02_III.c,786 :: 		if(string != 0)                                   // If txt array contains "$GPRMC" string we proceed...
	MOV	_string, W0
	CP	W0, #0
	BRA NZ	L__GPS_Parse114
	GOTO	L_GPS_Parse44
L__GPS_Parse114:
;CT02_III.c,788 :: 		if((string[7] != ',')&&(string[18] == 'A'))     // if "$GPRMC" NMEA message does not have ',' sign in the 8-th
	MOV	_string, W0
	ADD	W0, #7, W0
	MOV.B	[W0], W1
	MOV.B	#44, W0
	CP.B	W1, W0
	BRA NZ	L__GPS_Parse115
	GOTO	L__GPS_Parse75
L__GPS_Parse115:
	MOV	_string, W0
	ADD	W0, #18, W0
	MOV.B	[W0], W1
	MOV.B	#65, W0
	CP.B	W1, W0
	BRA Z	L__GPS_Parse116
	GOTO	L__GPS_Parse74
L__GPS_Parse116:
L__GPS_Parse70:
;CT02_III.c,793 :: 		HORA_GPS[0] = '0';
	MOV	#lo_addr(_HORA_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,794 :: 		HORA_GPS[1] = '0';
	MOV	#lo_addr(_HORA_GPS+1), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,795 :: 		HORA_GPS[2] = '0';
	MOV	#lo_addr(_HORA_GPS+2), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,796 :: 		HORA_GPS[3] = string[7];
	MOV	_string, W0
	ADD	W0, #7, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_HORA_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,797 :: 		HORA_GPS[4] = string[8];
	MOV	_string, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_HORA_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,798 :: 		HORA_GPS[5] = '\0';
	MOV	#lo_addr(_HORA_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,800 :: 		MINUTO_GPS[0] = '0';
	MOV	#lo_addr(_MINUTO_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,801 :: 		MINUTO_GPS[1] = '0';
	MOV	#lo_addr(_MINUTO_GPS+1), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,802 :: 		MINUTO_GPS[2] = '0';
	MOV	#lo_addr(_MINUTO_GPS+2), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,803 :: 		MINUTO_GPS[3] = string[9];
	MOV	_string, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_MINUTO_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,804 :: 		MINUTO_GPS[4] = string[10];
	MOV	_string, W0
	ADD	W0, #10, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_MINUTO_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,805 :: 		MINUTO_GPS[5] = '\0';
	MOV	#lo_addr(_MINUTO_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,807 :: 		SEGUNDO_GPS[0] = '0';
	MOV	#lo_addr(_SEGUNDO_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,808 :: 		SEGUNDO_GPS[1] = '0';
	MOV	#lo_addr(_SEGUNDO_GPS+1), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,809 :: 		SEGUNDO_GPS[2] = '0';
	MOV	#lo_addr(_SEGUNDO_GPS+2), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,810 :: 		SEGUNDO_GPS[3] = string[11];
	MOV	_string, W0
	ADD	W0, #11, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_SEGUNDO_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,811 :: 		SEGUNDO_GPS[4] = string[12];
	MOV	_string, W0
	ADD	W0, #12, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_SEGUNDO_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,812 :: 		SEGUNDO_GPS[5] = '\0';
	MOV	#lo_addr(_SEGUNDO_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,814 :: 		MILISEGUNDO_GPS[0] = '0';
	MOV	#lo_addr(_MILISEGUNDO_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,815 :: 		MILISEGUNDO_GPS[1] = '0';
	MOV	#lo_addr(_MILISEGUNDO_GPS+1), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,816 :: 		MILISEGUNDO_GPS[2] = string[14];
	MOV	_string, W0
	ADD	W0, #14, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_MILISEGUNDO_GPS+2), W0
	MOV.B	W1, [W0]
;CT02_III.c,817 :: 		MILISEGUNDO_GPS[3] = string[15];
	MOV	_string, W0
	ADD	W0, #15, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_MILISEGUNDO_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,818 :: 		MILISEGUNDO_GPS[4] = string[16];
	MOV	_string, W0
	ADD	W0, #16, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_MILISEGUNDO_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,819 :: 		MILISEGUNDO_GPS[5] = '\0';
	MOV	#lo_addr(_MILISEGUNDO_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,821 :: 		LATITUDE_INT_GPS[0] = '0';
	MOV	#lo_addr(_LATITUDE_INT_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,822 :: 		LATITUDE_INT_GPS[1] = string[20];
	MOV	_string, W0
	ADD	W0, #20, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LATITUDE_INT_GPS+1), W0
	MOV.B	W1, [W0]
;CT02_III.c,823 :: 		LATITUDE_INT_GPS[2] = string[21];
	MOV	_string, W0
	ADD	W0, #21, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LATITUDE_INT_GPS+2), W0
	MOV.B	W1, [W0]
;CT02_III.c,824 :: 		LATITUDE_INT_GPS[3] = string[22];
	MOV	_string, W0
	ADD	W0, #22, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LATITUDE_INT_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,825 :: 		LATITUDE_INT_GPS[4] = string[23];
	MOV	_string, W0
	ADD	W0, #23, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LATITUDE_INT_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,826 :: 		LATITUDE_INT_GPS[5] = '\0';
	MOV	#lo_addr(_LATITUDE_INT_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,828 :: 		LATITUDE_FRAC_GPS[0] = string[25];
	MOV	_string, W0
	ADD	W0, #25, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LATITUDE_FRAC_GPS), W0
	MOV.B	W1, [W0]
;CT02_III.c,829 :: 		LATITUDE_FRAC_GPS[1] = string[26];
	MOV	_string, W0
	ADD	W0, #26, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LATITUDE_FRAC_GPS+1), W0
	MOV.B	W1, [W0]
;CT02_III.c,830 :: 		LATITUDE_FRAC_GPS[2] = string[27];
	MOV	_string, W0
	ADD	W0, #27, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LATITUDE_FRAC_GPS+2), W0
	MOV.B	W1, [W0]
;CT02_III.c,831 :: 		LATITUDE_FRAC_GPS[3] = string[28];
	MOV	_string, W0
	ADD	W0, #28, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LATITUDE_FRAC_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,832 :: 		LATITUDE_FRAC_GPS[4] = '0';
	MOV	#lo_addr(_LATITUDE_FRAC_GPS+4), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,833 :: 		LATITUDE_FRAC_GPS[5] = '\0';
	MOV	#lo_addr(_LATITUDE_FRAC_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,835 :: 		LONGITUDE_INT_GPS[0] = string[32];
	MOV	#32, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LONGITUDE_INT_GPS), W0
	MOV.B	W1, [W0]
;CT02_III.c,836 :: 		LONGITUDE_INT_GPS[1] = string[33];
	MOV	#33, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LONGITUDE_INT_GPS+1), W0
	MOV.B	W1, [W0]
;CT02_III.c,837 :: 		LONGITUDE_INT_GPS[2] = string[34];
	MOV	#34, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LONGITUDE_INT_GPS+2), W0
	MOV.B	W1, [W0]
;CT02_III.c,838 :: 		LONGITUDE_INT_GPS[3] = string[35];
	MOV	#35, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LONGITUDE_INT_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,839 :: 		LONGITUDE_INT_GPS[4] = string[36];
	MOV	#36, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LONGITUDE_INT_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,840 :: 		LONGITUDE_INT_GPS[5] = '\0';
	MOV	#lo_addr(_LONGITUDE_INT_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,842 :: 		LONGITUDE_FRAC_GPS[0] = string[38];
	MOV	#38, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LONGITUDE_FRAC_GPS), W0
	MOV.B	W1, [W0]
;CT02_III.c,843 :: 		LONGITUDE_FRAC_GPS[1] = string[39];
	MOV	#39, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LONGITUDE_FRAC_GPS+1), W0
	MOV.B	W1, [W0]
;CT02_III.c,844 :: 		LONGITUDE_FRAC_GPS[2] = string[40];
	MOV	#40, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LONGITUDE_FRAC_GPS+2), W0
	MOV.B	W1, [W0]
;CT02_III.c,845 :: 		LONGITUDE_FRAC_GPS[3] = string[41];
	MOV	#41, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_LONGITUDE_FRAC_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,846 :: 		LONGITUDE_FRAC_GPS[4] = '0';
	MOV	#lo_addr(_LONGITUDE_FRAC_GPS+4), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,847 :: 		LONGITUDE_FRAC_GPS[5] = '\0';
	MOV	#lo_addr(_LONGITUDE_FRAC_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,849 :: 		N_S_E_W_GPS[0] = '0';
	MOV	#lo_addr(_N_S_E_W_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,850 :: 		N_S_E_W_GPS[1] = '0';
	MOV	#lo_addr(_N_S_E_W_GPS+1), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,851 :: 		N_S_E_W_GPS[2] = '0';
	MOV	#lo_addr(_N_S_E_W_GPS+2), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,852 :: 		if(string[30] == 'S')
	MOV	_string, W0
	ADD	W0, #30, W0
	MOV.B	[W0], W1
	MOV.B	#83, W0
	CP.B	W1, W0
	BRA Z	L__GPS_Parse117
	GOTO	L_GPS_Parse48
L__GPS_Parse117:
;CT02_III.c,854 :: 		N_S_E_W_GPS[3] = '0';
	MOV	#lo_addr(_N_S_E_W_GPS+3), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,855 :: 		}
	GOTO	L_GPS_Parse49
L_GPS_Parse48:
;CT02_III.c,856 :: 		else if(string[30] == 'N')
	MOV	_string, W0
	ADD	W0, #30, W0
	MOV.B	[W0], W1
	MOV.B	#78, W0
	CP.B	W1, W0
	BRA Z	L__GPS_Parse118
	GOTO	L_GPS_Parse50
L__GPS_Parse118:
;CT02_III.c,858 :: 		N_S_E_W_GPS[3] = '1';
	MOV	#lo_addr(_N_S_E_W_GPS+3), W1
	MOV.B	#49, W0
	MOV.B	W0, [W1]
;CT02_III.c,859 :: 		}
L_GPS_Parse50:
L_GPS_Parse49:
;CT02_III.c,860 :: 		if(string[43] == 'W')
	MOV	#43, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV.B	#87, W0
	CP.B	W1, W0
	BRA Z	L__GPS_Parse119
	GOTO	L_GPS_Parse51
L__GPS_Parse119:
;CT02_III.c,862 :: 		N_S_E_W_GPS[4] = '1';
	MOV	#lo_addr(_N_S_E_W_GPS+4), W1
	MOV.B	#49, W0
	MOV.B	W0, [W1]
;CT02_III.c,863 :: 		}
	GOTO	L_GPS_Parse52
L_GPS_Parse51:
;CT02_III.c,864 :: 		else if(string[43] == 'E')
	MOV	#43, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV.B	#69, W0
	CP.B	W1, W0
	BRA Z	L__GPS_Parse120
	GOTO	L_GPS_Parse53
L__GPS_Parse120:
;CT02_III.c,866 :: 		N_S_E_W_GPS[4] = '0';
	MOV	#lo_addr(_N_S_E_W_GPS+4), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,867 :: 		}
L_GPS_Parse53:
L_GPS_Parse52:
;CT02_III.c,868 :: 		N_S_E_W_GPS[5] = '\0';
	MOV	#lo_addr(_N_S_E_W_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,870 :: 		index_char = 45;
	MOV	#45, W0
	MOV	W0, _index_char
;CT02_III.c,871 :: 		cnt_gps = 0;
	CLR	W0
	MOV	W0, _cnt_gps
;CT02_III.c,872 :: 		while(string[index_char++] != ',')  //Contar quando algarismos tem a velocidade
L_GPS_Parse54:
	MOV	_index_char, W2
	MOV	#1, W1
	MOV	#lo_addr(_index_char), W0
	ADD	W1, [W0], [W0]
	MOV	#lo_addr(_string), W0
	ADD	W2, [W0], W0
	MOV.B	[W0], W1
	MOV.B	#44, W0
	CP.B	W1, W0
	BRA NZ	L__GPS_Parse121
	GOTO	L_GPS_Parse55
L__GPS_Parse121:
;CT02_III.c,874 :: 		cnt_gps++;
	MOV	#1, W1
	MOV	#lo_addr(_cnt_gps), W0
	ADD	W1, [W0], [W0]
;CT02_III.c,875 :: 		}
	GOTO	L_GPS_Parse54
L_GPS_Parse55:
;CT02_III.c,876 :: 		switch (cnt_gps)
	GOTO	L_GPS_Parse56
;CT02_III.c,878 :: 		case 4: VEL_X100_GPS[0] = '0';
L_GPS_Parse58:
	MOV	#lo_addr(_VEL_X100_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,879 :: 		VEL_X100_GPS[1] = '0';
	MOV	#lo_addr(_VEL_X100_GPS+1), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,880 :: 		VEL_X100_GPS[2] = string[45];
	MOV	#45, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_VEL_X100_GPS+2), W0
	MOV.B	W1, [W0]
;CT02_III.c,881 :: 		VEL_X100_GPS[3] = string[47];
	MOV	#47, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_VEL_X100_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,882 :: 		VEL_X100_GPS[4] = string[48];
	MOV	#48, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_VEL_X100_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,883 :: 		VEL_X100_GPS[5] = '\0';
	MOV	#lo_addr(_VEL_X100_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,884 :: 		break;
	GOTO	L_GPS_Parse57
;CT02_III.c,886 :: 		case 5: VEL_X100_GPS[0] = '0';
L_GPS_Parse59:
	MOV	#lo_addr(_VEL_X100_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,887 :: 		VEL_X100_GPS[1] = string[45];
	MOV	#45, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_VEL_X100_GPS+1), W0
	MOV.B	W1, [W0]
;CT02_III.c,888 :: 		VEL_X100_GPS[2] = string[46];
	MOV	#46, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_VEL_X100_GPS+2), W0
	MOV.B	W1, [W0]
;CT02_III.c,889 :: 		VEL_X100_GPS[3] = string[48];
	MOV	#48, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_VEL_X100_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,890 :: 		VEL_X100_GPS[4] = string[49];
	MOV	#49, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_VEL_X100_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,891 :: 		VEL_X100_GPS[5] = '\0';
	MOV	#lo_addr(_VEL_X100_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,892 :: 		break;
	GOTO	L_GPS_Parse57
;CT02_III.c,894 :: 		case 6: VEL_X100_GPS[0] = string[45];
L_GPS_Parse60:
	MOV	#45, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_VEL_X100_GPS), W0
	MOV.B	W1, [W0]
;CT02_III.c,895 :: 		VEL_X100_GPS[1] = string[46];
	MOV	#46, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_VEL_X100_GPS+1), W0
	MOV.B	W1, [W0]
;CT02_III.c,896 :: 		VEL_X100_GPS[2] = string[47];
	MOV	#47, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_VEL_X100_GPS+2), W0
	MOV.B	W1, [W0]
;CT02_III.c,897 :: 		VEL_X100_GPS[3] = string[49];
	MOV	#49, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_VEL_X100_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,898 :: 		VEL_X100_GPS[4] = string[50];
	MOV	#50, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_VEL_X100_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,899 :: 		VEL_X100_GPS[5] = '\0';
	MOV	#lo_addr(_VEL_X100_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,900 :: 		break;
	GOTO	L_GPS_Parse57
;CT02_III.c,901 :: 		}
L_GPS_Parse56:
	MOV	_cnt_gps, W0
	CP	W0, #4
	BRA NZ	L__GPS_Parse122
	GOTO	L_GPS_Parse58
L__GPS_Parse122:
	MOV	_cnt_gps, W0
	CP	W0, #5
	BRA NZ	L__GPS_Parse123
	GOTO	L_GPS_Parse59
L__GPS_Parse123:
	MOV	_cnt_gps, W0
	CP	W0, #6
	BRA NZ	L__GPS_Parse124
	GOTO	L_GPS_Parse60
L__GPS_Parse124:
L_GPS_Parse57:
;CT02_III.c,903 :: 		index_char2 = index_char;
	MOV	_index_char, W0
	MOV	W0, _index_char2
;CT02_III.c,904 :: 		cnt_gps2 = 0;
	CLR	W0
	MOV	W0, _cnt_gps2
;CT02_III.c,905 :: 		while(string[index_char2++] != ',')  //Contar quando algarismos tem a direção
L_GPS_Parse61:
	MOV	_index_char2, W2
	MOV	#1, W1
	MOV	#lo_addr(_index_char2), W0
	ADD	W1, [W0], [W0]
	MOV	#lo_addr(_string), W0
	ADD	W2, [W0], W0
	MOV.B	[W0], W1
	MOV.B	#44, W0
	CP.B	W1, W0
	BRA NZ	L__GPS_Parse125
	GOTO	L_GPS_Parse62
L__GPS_Parse125:
;CT02_III.c,907 :: 		cnt_gps2++;
	MOV	#1, W1
	MOV	#lo_addr(_cnt_gps2), W0
	ADD	W1, [W0], [W0]
;CT02_III.c,908 :: 		}
	GOTO	L_GPS_Parse61
L_GPS_Parse62:
;CT02_III.c,909 :: 		switch(cnt_gps2)
	GOTO	L_GPS_Parse63
;CT02_III.c,911 :: 		case 4: DIRECAO_X100_GPS[0] = '0';
L_GPS_Parse65:
	MOV	#lo_addr(_DIRECAO_X100_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,912 :: 		DIRECAO_X100_GPS[1] = '0';
	MOV	#lo_addr(_DIRECAO_X100_GPS+1), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,913 :: 		DIRECAO_X100_GPS[2] = string[index_char];
	MOV	_string, W1
	MOV	#lo_addr(_index_char), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIRECAO_X100_GPS+2), W0
	MOV.B	W1, [W0]
;CT02_III.c,914 :: 		DIRECAO_X100_GPS[3] = string[index_char+2];
	MOV	_index_char, W0
	ADD	W0, #2, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIRECAO_X100_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,915 :: 		DIRECAO_X100_GPS[4] = string[index_char+3];
	MOV	_index_char, W0
	ADD	W0, #3, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIRECAO_X100_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,916 :: 		DIRECAO_X100_GPS[5] = '\0';
	MOV	#lo_addr(_DIRECAO_X100_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,917 :: 		break;
	GOTO	L_GPS_Parse64
;CT02_III.c,919 :: 		case 5: DIRECAO_X100_GPS[0] = '0';
L_GPS_Parse66:
	MOV	#lo_addr(_DIRECAO_X100_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,920 :: 		DIRECAO_X100_GPS[1] = string[index_char];
	MOV	_string, W1
	MOV	#lo_addr(_index_char), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIRECAO_X100_GPS+1), W0
	MOV.B	W1, [W0]
;CT02_III.c,921 :: 		DIRECAO_X100_GPS[2] = string[index_char+1];
	MOV	_index_char, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIRECAO_X100_GPS+2), W0
	MOV.B	W1, [W0]
;CT02_III.c,922 :: 		DIRECAO_X100_GPS[3] = string[index_char+3];
	MOV	_index_char, W0
	ADD	W0, #3, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIRECAO_X100_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,923 :: 		DIRECAO_X100_GPS[4] = string[index_char+4];
	MOV	_index_char, W0
	ADD	W0, #4, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIRECAO_X100_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,924 :: 		DIRECAO_X100_GPS[5] = '\0';
	MOV	#lo_addr(_DIRECAO_X100_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,925 :: 		break;
	GOTO	L_GPS_Parse64
;CT02_III.c,927 :: 		case 6: DIRECAO_X100_GPS[0] = string[index_char];
L_GPS_Parse67:
	MOV	_string, W1
	MOV	#lo_addr(_index_char), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIRECAO_X100_GPS), W0
	MOV.B	W1, [W0]
;CT02_III.c,928 :: 		DIRECAO_X100_GPS[1] = string[index_char+1];
	MOV	_index_char, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIRECAO_X100_GPS+1), W0
	MOV.B	W1, [W0]
;CT02_III.c,929 :: 		DIRECAO_X100_GPS[2] = string[index_char+2];
	MOV	_index_char, W0
	ADD	W0, #2, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIRECAO_X100_GPS+2), W0
	MOV.B	W1, [W0]
;CT02_III.c,930 :: 		DIRECAO_X100_GPS[3] = string[index_char+4];
	MOV	_index_char, W0
	ADD	W0, #4, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIRECAO_X100_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,931 :: 		DIRECAO_X100_GPS[4] = string[index_char+5];
	MOV	_index_char, W0
	ADD	W0, #5, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIRECAO_X100_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,932 :: 		DIRECAO_X100_GPS[5] = '\0';
	MOV	#lo_addr(_DIRECAO_X100_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,933 :: 		break;
	GOTO	L_GPS_Parse64
;CT02_III.c,934 :: 		}
L_GPS_Parse63:
	MOV	_cnt_gps2, W0
	CP	W0, #4
	BRA NZ	L__GPS_Parse126
	GOTO	L_GPS_Parse65
L__GPS_Parse126:
	MOV	_cnt_gps2, W0
	CP	W0, #5
	BRA NZ	L__GPS_Parse127
	GOTO	L_GPS_Parse66
L__GPS_Parse127:
	MOV	_cnt_gps2, W0
	CP	W0, #6
	BRA NZ	L__GPS_Parse128
	GOTO	L_GPS_Parse67
L__GPS_Parse128:
L_GPS_Parse64:
;CT02_III.c,935 :: 		index_char3 = index_char2;
	MOV	_index_char2, W0
	MOV	W0, _index_char3
;CT02_III.c,936 :: 		DIA_GPS[0] = '0';
	MOV	#lo_addr(_DIA_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,937 :: 		DIA_GPS[1] = '0';
	MOV	#lo_addr(_DIA_GPS+1), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,938 :: 		DIA_GPS[2] = '0';
	MOV	#lo_addr(_DIA_GPS+2), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,939 :: 		DIA_GPS[3] = string[index_char3];
	MOV	_string, W1
	MOV	#lo_addr(_index_char2), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIA_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,940 :: 		DIA_GPS[4] = string[index_char3+1];
	MOV	_index_char2, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DIA_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,941 :: 		DIA_GPS[5] = '\0';
	MOV	#lo_addr(_DIA_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,943 :: 		MES_GPS[0] = '0';
	MOV	#lo_addr(_MES_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,944 :: 		MES_GPS[1] = '0';
	MOV	#lo_addr(_MES_GPS+1), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,945 :: 		MES_GPS[2] = '0';
	MOV	#lo_addr(_MES_GPS+2), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,946 :: 		MES_GPS[3] = string[index_char3+2];
	MOV	_index_char2, W0
	ADD	W0, #2, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_MES_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,947 :: 		MES_GPS[4] = string[index_char3+3];
	MOV	_index_char2, W0
	ADD	W0, #3, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_MES_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,948 :: 		MES_GPS[5] = '\0';
	MOV	#lo_addr(_MES_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,950 :: 		ANO_GPS[0] = '0';
	MOV	#lo_addr(_ANO_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,951 :: 		ANO_GPS[1] = '0';
	MOV	#lo_addr(_ANO_GPS+1), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,952 :: 		ANO_GPS[2] = '0';
	MOV	#lo_addr(_ANO_GPS+2), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,953 :: 		ANO_GPS[3] = string[index_char3+4];
	MOV	_index_char2, W0
	ADD	W0, #4, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_ANO_GPS+3), W0
	MOV.B	W1, [W0]
;CT02_III.c,954 :: 		ANO_GPS[4] = string[index_char3+5];
	MOV	_index_char2, W0
	ADD	W0, #5, W1
	MOV	#lo_addr(_string), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_ANO_GPS+4), W0
	MOV.B	W1, [W0]
;CT02_III.c,955 :: 		ANO_GPS[5] = '\0';
	MOV	#lo_addr(_ANO_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,957 :: 		STATUS_CHECKSUM_GPS[0] = '0';
	MOV	#lo_addr(_STATUS_CHECKSUM_GPS), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,958 :: 		STATUS_CHECKSUM_GPS[1] = '1';
	MOV	#lo_addr(_STATUS_CHECKSUM_GPS+1), W1
	MOV.B	#49, W0
	MOV.B	W0, [W1]
;CT02_III.c,959 :: 		STATUS_CHECKSUM_GPS[2] = '0';
	MOV	#lo_addr(_STATUS_CHECKSUM_GPS+2), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,960 :: 		STATUS_CHECKSUM_GPS[3] = '0';        //string[index_char3+11];
	MOV	#lo_addr(_STATUS_CHECKSUM_GPS+3), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,961 :: 		STATUS_CHECKSUM_GPS[4] = '0';        //string[index_char3+12];
	MOV	#lo_addr(_STATUS_CHECKSUM_GPS+4), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
;CT02_III.c,962 :: 		STATUS_CHECKSUM_GPS[5] = '\0';
	MOV	#lo_addr(_STATUS_CHECKSUM_GPS+5), W1
	CLR	W0
	MOV.B	W0, [W1]
;CT02_III.c,964 :: 		res = 1;
	MOV	#1, W0
	MOV	W0, _res
;CT02_III.c,965 :: 		return res;
	MOV	#1, W0
	GOTO	L_end_GPS_Parse
;CT02_III.c,788 :: 		if((string[7] != ',')&&(string[18] == 'A'))     // if "$GPRMC" NMEA message does not have ',' sign in the 8-th
L__GPS_Parse75:
L__GPS_Parse74:
;CT02_III.c,969 :: 		res = 2;
	MOV	#2, W0
	MOV	W0, _res
;CT02_III.c,970 :: 		return res;
	MOV	#2, W0
	GOTO	L_end_GPS_Parse
;CT02_III.c,973 :: 		}
L_GPS_Parse44:
;CT02_III.c,976 :: 		res = 0;
	CLR	W0
	MOV	W0, _res
;CT02_III.c,977 :: 		return res;
	CLR	W0
;CT02_III.c,980 :: 		}
;CT02_III.c,977 :: 		return res;
;CT02_III.c,980 :: 		}
L_end_GPS_Parse:
	POP	W11
	POP	W10
	RETURN
; end of _GPS_Parse
