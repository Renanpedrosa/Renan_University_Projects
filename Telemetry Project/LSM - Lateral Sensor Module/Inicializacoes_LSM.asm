
_InitClock:

;Inicializacoes_LSM.c,20 :: 		void InitClock()
;Inicializacoes_LSM.c,24 :: 		CLKDIV &= 0xFFE0;   //Zera os bits do PLL prescaler que serão modificados
	MOV	#65504, W1
	MOV	#lo_addr(CLKDIV), W0
	AND	W1, [W0], [W0]
;Inicializacoes_LSM.c,25 :: 		CLKDIV |= 0x0003;   //PLL prescaler = N1 = 5
	MOV	#3, W1
	MOV	#lo_addr(CLKDIV), W0
	IOR	W1, [W0], [W0]
;Inicializacoes_LSM.c,26 :: 		PLLFBD = 38;        //PLL multiplier = M = 40
	MOV	#38, W0
	MOV	WREG, PLLFBD
;Inicializacoes_LSM.c,27 :: 		CLKDIV &= 0xFF3F;   //PLL postscaler = N2 = 2
	MOV	#65343, W1
	MOV	#lo_addr(CLKDIV), W0
	AND	W1, [W0], [W0]
;Inicializacoes_LSM.c,52 :: 		MOV #0x743, w1         ;note memory address of OSSCONH address
	MOV	#1859, W1
;Inicializacoes_LSM.c,53 :: 		MOV.B #0b011, w0
	MOV.B	#3, W0
;Inicializacoes_LSM.c,54 :: 		MOV #0x78, w2
	MOV	#120, W2
;Inicializacoes_LSM.c,55 :: 		MOV #0x9A, w3
	MOV	#154, W3
;Inicializacoes_LSM.c,56 :: 		MOV.B w2, [w1]
	MOV.B	W2, [W1]
;Inicializacoes_LSM.c,57 :: 		MOV.B w3, [w1]
	MOV.B	W3, [W1]
;Inicializacoes_LSM.c,58 :: 		MOV.B w0, [w1]
	MOV.B	W0, [W1]
;Inicializacoes_LSM.c,60 :: 		MOV #0x742, w1         ;note memory address of OSSCONL address
	MOV	#1858, W1
;Inicializacoes_LSM.c,61 :: 		MOV.B #0x03, w0
	MOV.B	#3, W0
;Inicializacoes_LSM.c,62 :: 		MOV #0x46, w2
	MOV	#70, W2
;Inicializacoes_LSM.c,63 :: 		MOV #0x57, w3
	MOV	#87, W3
;Inicializacoes_LSM.c,64 :: 		MOV.B w2, [w1]
	MOV.B	W2, [W1]
;Inicializacoes_LSM.c,65 :: 		MOV.B w3, [w1]
	MOV.B	W3, [W1]
;Inicializacoes_LSM.c,66 :: 		MOV.B w0, [w1]
	MOV.B	W0, [W1]
;Inicializacoes_LSM.c,67 :: 		NOP
	NOP
;Inicializacoes_LSM.c,68 :: 		NOP
	NOP
;Inicializacoes_LSM.c,76 :: 		}
L_end_InitClock:
	RETURN
; end of _InitClock

_InitPorts:

;Inicializacoes_LSM.c,79 :: 		void InitPorts()
;Inicializacoes_LSM.c,82 :: 		AD1PCFGL = 0x1800;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#6144, W0
	MOV	WREG, AD1PCFGL
;Inicializacoes_LSM.c,85 :: 		TRISA0_bit  = 1;        //AN0 - GPIN0
	BSET	TRISA0_bit, #0
;Inicializacoes_LSM.c,86 :: 		TRISA1_bit  = 1;        //AN1 - GPIN1
	BSET	TRISA1_bit, #1
;Inicializacoes_LSM.c,87 :: 		TRISB0_bit  = 1;        //AN2 - GPIN2
	BSET	TRISB0_bit, #0
;Inicializacoes_LSM.c,88 :: 		TRISB1_bit  = 1;        //AN3 - GPIN3
	BSET	TRISB1_bit, #1
;Inicializacoes_LSM.c,89 :: 		TRISB2_bit  = 1;        //AN4 - GPIN4
	BSET	TRISB2_bit, #2
;Inicializacoes_LSM.c,90 :: 		TRISB3_bit  = 1;        //AN5 - GPIN5
	BSET	TRISB3_bit, #3
;Inicializacoes_LSM.c,91 :: 		TRISC0_bit  = 1;        //AN6 - ITELEMETRIA
	BSET	TRISC0_bit, #0
;Inicializacoes_LSM.c,92 :: 		TRISB15_bit = 1;        //AN9 - PGA_OUT
	BSET	TRISB15_bit, #15
;Inicializacoes_LSM.c,95 :: 		TRISA8_bit  = 0;        //LED
	BCLR	TRISA8_bit, #8
;Inicializacoes_LSM.c,96 :: 		TRISA9_bit  = 1;        //Botão na caixa
	BSET	TRISA9_bit, #9
;Inicializacoes_LSM.c,97 :: 		TRISB7_bit  = 1;        //INT0 / RP7 / CN23 - Entrada de Rotação - DIG1
	BSET	TRISB7_bit, #7
;Inicializacoes_LSM.c,98 :: 		TRISB10_bit = 0;        //CS   - Cartão SD
	BCLR	TRISB10_bit, #10
;Inicializacoes_LSM.c,99 :: 		TRISB11_bit = 0;        //SDO2 - Cartão SD
	BCLR	TRISB11_bit, #11
;Inicializacoes_LSM.c,100 :: 		TRISB12_bit = 0;        //SCK2 - Cartão SD
	BCLR	TRISB12_bit, #12
;Inicializacoes_LSM.c,101 :: 		TRISB13_bit = 1;        //SDI2 - Cartão SD
	BSET	TRISB13_bit, #13
;Inicializacoes_LSM.c,102 :: 		TRISC3_bit  = 0;        //SCK  - PGA
	BCLR	TRISC3_bit, #3
;Inicializacoes_LSM.c,103 :: 		TRISC4_bit  = 0;        //SDO  - PGA
	BCLR	TRISC4_bit, #4
;Inicializacoes_LSM.c,104 :: 		TRISC5_bit  = 0;        //CS   - PGA
	BCLR	TRISC5_bit, #5
;Inicializacoes_LSM.c,105 :: 		TRISC8_bit  = 0;        //C1TX - CanBus
	BCLR	TRISC8_bit, #8
;Inicializacoes_LSM.c,106 :: 		TRISC9_bit  = 1;        //C1RX - CanBus
	BSET	TRISC9_bit, #9
;Inicializacoes_LSM.c,108 :: 		Unlock_IOLOCK();
	CALL	_Unlock_IOLOCK
;Inicializacoes_LSM.c,109 :: 		PPS_Mapping(19, _OUTPUT, _SCK1OUT); //Configura o pino 36 como saída do clock do SPI1 - PGA
	MOV.B	#8, W12
	CLR	W11
	MOV.B	#19, W10
	CALL	_PPS_Mapping
;Inicializacoes_LSM.c,110 :: 		PPS_Mapping(20, _OUTPUT, _SDO1);    //Configura o pino 37 como saída serial do SPI1 - PGA
	MOV.B	#7, W12
	CLR	W11
	MOV.B	#20, W10
	CALL	_PPS_Mapping
;Inicializacoes_LSM.c,111 :: 		PPS_Mapping(11, _OUTPUT, _SDO2);    //Configura o pino 9 como saída serial do SPI1 - PGA
	MOV.B	#10, W12
	CLR	W11
	MOV.B	#11, W10
	CALL	_PPS_Mapping
;Inicializacoes_LSM.c,112 :: 		PPS_Mapping(12, _OUTPUT, _SCK2OUT); //Configura o pino 10 como saída do clock do SPI2  - Cartão SD
	MOV.B	#11, W12
	CLR	W11
	MOV.B	#12, W10
	CALL	_PPS_Mapping
;Inicializacoes_LSM.c,113 :: 		PPS_Mapping(13, _INPUT, _SDI2);     //Configura o pino 9 como entrada serial do SPI2 - Cartão SD
	MOV.B	#18, W12
	MOV.B	#1, W11
	MOV.B	#13, W10
	CALL	_PPS_Mapping
;Inicializacoes_LSM.c,114 :: 		PPS_Mapping(7, _INPUT, _IC1);      //Configura o pino 43 como entrada do Input Capture 1 - Medir RotaçãO (DIG1)
	MOV.B	#6, W12
	MOV.B	#1, W11
	MOV.B	#7, W10
	CALL	_PPS_Mapping
;Inicializacoes_LSM.c,115 :: 		PPS_Mapping(24, _OUTPUT, _C1TX);     //Configura o pino 4 como TX do CAN
	MOV.B	#16, W12
	CLR	W11
	MOV.B	#24, W10
	CALL	_PPS_Mapping
;Inicializacoes_LSM.c,116 :: 		PPS_Mapping(25, _INPUT, _CIRX);      //Configura o pino 5 como RX da CAN
	MOV.B	#24, W12
	MOV.B	#1, W11
	MOV.B	#25, W10
	CALL	_PPS_Mapping
;Inicializacoes_LSM.c,117 :: 		Lock_IOLOCK();
	CALL	_Lock_IOLOCK
;Inicializacoes_LSM.c,118 :: 		}
L_end_InitPorts:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _InitPorts

_InitCan:

;Inicializacoes_LSM.c,124 :: 		void InitCan()
;Inicializacoes_LSM.c,128 :: 		IFS0=0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	IFS0
;Inicializacoes_LSM.c,129 :: 		IFS1=0;
	CLR	IFS1
;Inicializacoes_LSM.c,130 :: 		IFS2=0;
	CLR	IFS2
;Inicializacoes_LSM.c,131 :: 		IFS3=0;
	CLR	IFS3
;Inicializacoes_LSM.c,132 :: 		IFS4=0;
	CLR	IFS4
;Inicializacoes_LSM.c,136 :: 		IEC2bits.C1IE   = 1;                       // enable ECAN1 interrupt
	BSET	IEC2bits, #3
;Inicializacoes_LSM.c,137 :: 		C1INTEbits.TBIE = 1;                       // enable ECAN1 tx interrupt
	BSET.B	C1INTEbits, #0
;Inicializacoes_LSM.c,138 :: 		C1INTEbits.RBIE = 1;                       // enable ECAN1 rx interrupt
	BSET.B	C1INTEbits, #1
;Inicializacoes_LSM.c,140 :: 		Can_Init_Flags = 0;                              //
	CLR	W0
	MOV	W0, _Can_Init_Flags
;Inicializacoes_LSM.c,141 :: 		Can_Send_Flags = 0;                              // clear flags
	CLR	W0
	MOV	W0, _Can_Send_Flags
;Inicializacoes_LSM.c,142 :: 		Can_Rcv_Flags  = 0;                              //
	CLR	W0
	MOV	W0, _Can_Rcv_Flags
;Inicializacoes_LSM.c,146 :: 		_ECAN_TX_NO_RTR_FRAME;
	MOV	#244, W0
	MOV	W0, _Can_Send_Flags
;Inicializacoes_LSM.c,152 :: 		_ECAN_CONFIG_LINE_FILTER_OFF;
	MOV	#241, W0
	MOV	W0, _Can_Init_Flags
;Inicializacoes_LSM.c,154 :: 		ECAN1DmaChannelInit(0, 1, &ECAN1RxTxRAMBuffer);  // init dma channel 0 for
	MOV	#16384, W12
	MOV	#1, W11
	CLR	W10
	CALL	_ECAN1DmaChannelInit
;Inicializacoes_LSM.c,156 :: 		ECAN1DmaChannelInit(2, 0, &ECAN1RxTxRAMBuffer);  // init dma channel 2 for
	MOV	#16384, W12
	CLR	W11
	MOV	#2, W10
	CALL	_ECAN1DmaChannelInit
;Inicializacoes_LSM.c,158 :: 		ECAN1Initialize(SJW, BRP, PHSEG1, PHSEG2, PROPSEG, Can_Init_Flags);  // initialize ECAN 1Mbps
	MOV	#3, W13
	MOV	#3, W12
	MOV	#4, W11
	MOV	#1, W10
	PUSH	_Can_Init_Flags
	MOV	#1, W0
	PUSH	W0
	CALL	_ECAN1Initialize
	SUB	#4, W15
;Inicializacoes_LSM.c,159 :: 		ECAN1SetBufferSize(ECAN1RAMBUFFERSIZE);          // set number of rx+tx buffers in DMA RAM
	MOV	#16, W10
	CALL	_ECAN1SetBufferSize
;Inicializacoes_LSM.c,161 :: 		ECAN1SelectTxBuffers(0x00FF);                    // select transmit buffers
	MOV	#255, W10
	CALL	_ECAN1SelectTxBuffers
;Inicializacoes_LSM.c,163 :: 		ECAN1SetOperationMode(_ECAN_MODE_CONFIG,0xFF);   // set CONFIGURATION mode
	MOV	#255, W11
	MOV	#4, W10
	CALL	_ECAN1SetOperationMode
;Inicializacoes_LSM.c,165 :: 		ECAN1SetMask(_ECAN_MASK_0, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask1 bits to ones
	MOV	#247, W13
	MOV	#65535, W11
	MOV	#65535, W12
	CLR	W10
	CALL	_ECAN1SetMask
;Inicializacoes_LSM.c,166 :: 		ECAN1SetMask(_ECAN_MASK_1, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask2 bits to ones
	MOV	#247, W13
	MOV	#65535, W11
	MOV	#65535, W12
	MOV	#1, W10
	CALL	_ECAN1SetMask
;Inicializacoes_LSM.c,167 :: 		ECAN1SetMask(_ECAN_MASK_2, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask3 bits to ones
	MOV	#247, W13
	MOV	#65535, W11
	MOV	#65535, W12
	MOV	#2, W10
	CALL	_ECAN1SetMask
;Inicializacoes_LSM.c,171 :: 		ECAN1SetOperationMode(_ECAN_MODE_NORMAL,0xFF);   // set NORMAL mode
	MOV	#255, W11
	CLR	W10
	CALL	_ECAN1SetOperationMode
;Inicializacoes_LSM.c,172 :: 		}
L_end_InitCan:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _InitCan

_InitTimersCapture:

;Inicializacoes_LSM.c,174 :: 		void InitTimersCapture()
;Inicializacoes_LSM.c,177 :: 		T2CONbits.TCKPS = 0b11; //1:256 prescaler(Período de 6,4us e estouro em 419ms)
	MOV	#lo_addr(T2CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#48, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(T2CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_LSM.c,178 :: 		T2CONbits.T32 = 0;      //Funciona como um timer de 16bits
	BCLR	T2CONbits, #3
;Inicializacoes_LSM.c,179 :: 		T2CONbits.TCS = 0;      //Clock interno (Fosc/2)
	BCLR	T2CONbits, #1
;Inicializacoes_LSM.c,180 :: 		T2CONbits.TON = 1;      //Liga o Timer 2
	BSET	T2CONbits, #15
;Inicializacoes_LSM.c,183 :: 		IC1CONbits.ICM=0b00; // Desabilita módulo Input Capture 1
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#248, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_LSM.c,184 :: 		IC1CONbits.ICTMR= 1; // Seleciona Timer2 como base de tempo do IC1
	BSET	IC1CONbits, #7
;Inicializacoes_LSM.c,185 :: 		IC1CONbits.ICI= 0b01; // Interrupt on every second capture event
	MOV.B	#32, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC1CONbits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#96, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC1CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_LSM.c,186 :: 		IC1CONbits.ICM= 0b011; // Generate capture event on every Rising edge
	MOV.B	#3, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC1CONbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IC1CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_LSM.c,189 :: 		IPC0bits.IC1IP = 2; // Setup IC1 interrupt priority level
	MOV.B	#32, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#112, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC0bits), W0
	MOV.B	W1, [W0]
;Inicializacoes_LSM.c,190 :: 		IFS0bits.IC1IF = 0; // Clear IC1 Interrupt Status Flag
	BCLR	IFS0bits, #1
;Inicializacoes_LSM.c,191 :: 		IEC0bits.IC1IE = 1; // Enable IC1 interrupt
	BSET	IEC0bits, #1
;Inicializacoes_LSM.c,193 :: 		}
L_end_InitTimersCapture:
	RETURN
; end of _InitTimersCapture

_InitMain:

;Inicializacoes_LSM.c,211 :: 		void InitMain()
;Inicializacoes_LSM.c,215 :: 		ADC1_Init_Advanced(_ADC_12bit, _ADC_INTERNAL_REF);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	W11
	MOV	#1, W10
	CALL	_ADC1_Init_Advanced
;Inicializacoes_LSM.c,218 :: 		SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_8, _SPI_PRESCALE_PRI_1, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_IDLE_2_ACTIVE);
	MOV	#3, W13
	CLR	W12
	CLR	W11
	MOV	#32, W10
	MOV	#256, W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI1_Init_Advanced
	SUB	#8, W15
;Inicializacoes_LSM.c,221 :: 		PGA_Set_Gain(1);
	MOV.B	#1, W10
	CALL	_PGA_Set_Gain
;Inicializacoes_LSM.c,223 :: 		}
L_end_InitMain:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _InitMain
