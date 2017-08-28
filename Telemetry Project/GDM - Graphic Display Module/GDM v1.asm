
_InitClock:

;GDM v1.c,82 :: 		void InitClock()
;GDM v1.c,99 :: 		CLKDIV &= 0xFFE0;   //Zera os bits do PLL prescaler que serão modificados
	MOV	#65504, W1
	MOV	#lo_addr(CLKDIV), W0
	AND	W1, [W0], [W0]
;GDM v1.c,100 :: 		CLKDIV |= 0x0002;   //PLL prescaler = N1 = 4
	MOV	#2, W1
	MOV	#lo_addr(CLKDIV), W0
	IOR	W1, [W0], [W0]
;GDM v1.c,101 :: 		PLLFBD = 38;        //PLL multiplier = M = 40
	MOV	#38, W0
	MOV	WREG, PLLFBD
;GDM v1.c,102 :: 		CLKDIV &= 0xFF3F;   //PLL postscaler = N2 = 2
	MOV	#65343, W1
	MOV	#lo_addr(CLKDIV), W0
	AND	W1, [W0], [W0]
;GDM v1.c,115 :: 		MOV #0x743, w1         ;note memory address of OSSCONH address
	MOV	#1859, W1
;GDM v1.c,116 :: 		MOV.B #0b011, w0
	MOV.B	#3, W0
;GDM v1.c,117 :: 		MOV #0x78, w2
	MOV	#120, W2
;GDM v1.c,118 :: 		MOV #0x9A, w3
	MOV	#154, W3
;GDM v1.c,119 :: 		MOV.B w2, [w1]
	MOV.B	W2, [W1]
;GDM v1.c,120 :: 		MOV.B w3, [w1]
	MOV.B	W3, [W1]
;GDM v1.c,121 :: 		MOV.B w0, [w1]
	MOV.B	W0, [W1]
;GDM v1.c,123 :: 		MOV #0x742, w1         ;note memory address of OSSCONL address
	MOV	#1858, W1
;GDM v1.c,124 :: 		MOV.B #0x03, w0
	MOV.B	#3, W0
;GDM v1.c,125 :: 		MOV #0x46, w2
	MOV	#70, W2
;GDM v1.c,126 :: 		MOV #0x57, w3
	MOV	#87, W3
;GDM v1.c,127 :: 		MOV.B w2, [w1]
	MOV.B	W2, [W1]
;GDM v1.c,128 :: 		MOV.B w3, [w1]
	MOV.B	W3, [W1]
;GDM v1.c,129 :: 		MOV.B w0, [w1]
	MOV.B	W0, [W1]
;GDM v1.c,130 :: 		NOP
	NOP
;GDM v1.c,131 :: 		NOP
	NOP
;GDM v1.c,142 :: 		}
L_end_InitClock:
	RETURN
; end of _InitClock

_InitCan:

;GDM v1.c,146 :: 		void InitCan()
;GDM v1.c,150 :: 		IFS0=0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	IFS0
;GDM v1.c,151 :: 		IFS1=0;
	CLR	IFS1
;GDM v1.c,152 :: 		IFS2=0;
	CLR	IFS2
;GDM v1.c,153 :: 		IFS3=0;
	CLR	IFS3
;GDM v1.c,154 :: 		IFS4=0;
	CLR	IFS4
;GDM v1.c,158 :: 		IEC2bits.C1IE   = 1;                       // enable ECAN1 interrupt
	BSET	IEC2bits, #3
;GDM v1.c,159 :: 		C1INTEbits.TBIE = 1;                       // enable ECAN1 tx interrupt
	BSET.B	C1INTEbits, #0
;GDM v1.c,160 :: 		C1INTEbits.RBIE = 1;                       // enable ECAN1 rx interrupt
	BSET.B	C1INTEbits, #1
;GDM v1.c,162 :: 		Can_Init_Flags = 0;                              //
	CLR	W0
	MOV	W0, _Can_Init_Flags
;GDM v1.c,163 :: 		Can_Send_Flags = 0;                              // clear flags
	CLR	W0
	MOV	W0, _Can_Send_Flags
;GDM v1.c,164 :: 		Can_Rcv_Flags  = 0;                              //
	CLR	W0
	MOV	W0, _Can_Rcv_Flags
;GDM v1.c,168 :: 		_ECAN_TX_NO_RTR_FRAME;
	MOV	#244, W0
	MOV	W0, _Can_Send_Flags
;GDM v1.c,174 :: 		_ECAN_CONFIG_LINE_FILTER_OFF;
	MOV	#241, W0
	MOV	W0, _Can_Init_Flags
;GDM v1.c,176 :: 		ECAN1DmaChannelInit(0, 1, &ECAN1RxTxRAMBuffer);  // init dma channel 0 for
	MOV	#16384, W12
	MOV	#1, W11
	CLR	W10
	CALL	_ECAN1DmaChannelInit
;GDM v1.c,178 :: 		ECAN1DmaChannelInit(2, 0, &ECAN1RxTxRAMBuffer);  // init dma channel 2 for
	MOV	#16384, W12
	CLR	W11
	MOV	#2, W10
	CALL	_ECAN1DmaChannelInit
;GDM v1.c,180 :: 		ECAN1Initialize(SJW, BRP, PHSEG1, PHSEG2, PROPSEG, Can_Init_Flags);  // initialize ECAN 1Mbps
	MOV	#6, W13
	MOV	#8, W12
	MOV	#1, W11
	MOV	#1, W10
	PUSH	_Can_Init_Flags
	MOV	#5, W0
	PUSH	W0
	CALL	_ECAN1Initialize
	SUB	#4, W15
;GDM v1.c,181 :: 		ECAN1SetBufferSize(ECAN1RAMBUFFERSIZE);          // set number of rx+tx buffers in DMA RAM
	MOV	#16, W10
	CALL	_ECAN1SetBufferSize
;GDM v1.c,183 :: 		ECAN1SelectTxBuffers(0x000F);                    // select transmit buffers
	MOV	#15, W10
	CALL	_ECAN1SelectTxBuffers
;GDM v1.c,185 :: 		ECAN1SetOperationMode(_ECAN_MODE_CONFIG,0xFF);   // set CONFIGURATION mode
	MOV	#255, W11
	MOV	#4, W10
	CALL	_ECAN1SetOperationMode
;GDM v1.c,187 :: 		ECAN1SetMask(_ECAN_MASK_0, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask1 bits to ones
	MOV	#247, W13
	MOV	#65535, W11
	MOV	#65535, W12
	CLR	W10
	CALL	_ECAN1SetMask
;GDM v1.c,188 :: 		ECAN1SetMask(_ECAN_MASK_1, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask2 bits to ones
	MOV	#247, W13
	MOV	#65535, W11
	MOV	#65535, W12
	MOV	#1, W10
	CALL	_ECAN1SetMask
;GDM v1.c,189 :: 		ECAN1SetMask(_ECAN_MASK_2, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask3 bits to ones
	MOV	#247, W13
	MOV	#65535, W11
	MOV	#65535, W12
	MOV	#2, W10
	CALL	_ECAN1SetMask
;GDM v1.c,190 :: 		ECAN1SetFilter(_ECAN_FILTER_10,FSM_CTRL, _ECAN_MASK_2, _ECAN_RX_BUFFER_7, _ECAN_CONFIG_XTD_MSG); // set id of filter10 to 1st node ID
	MOV	#2, W13
	MOV	#1060, W11
	MOV	#0, W12
	MOV	#10, W10
	MOV	#247, W0
	PUSH	W0
	MOV	#7, W0
	PUSH	W0
	CALL	_ECAN1SetFilter
	SUB	#4, W15
;GDM v1.c,193 :: 		ECAN1SetOperationMode(_ECAN_MODE_NORMAL,0xFF);   // set NORMAL mode
	MOV	#255, W11
	CLR	W10
	CALL	_ECAN1SetOperationMode
;GDM v1.c,194 :: 		}
L_end_InitCan:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _InitCan

_InitTimersCapture:

;GDM v1.c,198 :: 		void InitTimersCapture()
;GDM v1.c,213 :: 		T2CONbits.TCKPS = 0b11; //1:256 prescaler(Período de 6,4us e estouro em 419ms)
	MOV	#lo_addr(T2CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#48, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(T2CONbits), W0
	MOV.B	W1, [W0]
;GDM v1.c,214 :: 		T2CONbits.T32 = 0;      //Funciona como um timer de 16bits
	BCLR	T2CONbits, #3
;GDM v1.c,215 :: 		T2CONbits.TCS = 0;      //Clock interno (Fosc/2)
	BCLR	T2CONbits, #1
;GDM v1.c,216 :: 		T2CONbits.TON = 1;      //Liga o Timer 2
	BSET	T2CONbits, #15
;GDM v1.c,219 :: 		T3CONbits.TCKPS = 0b10; //1:64 prescaler(Período de 1,6us e estouro em 104ms)
	MOV.B	#32, W0
	MOV.B	W0, W1
	MOV	#lo_addr(T3CONbits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#48, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(T3CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(T3CONbits), W0
	MOV.B	W1, [W0]
;GDM v1.c,220 :: 		T3CONbits.TCS = 0;      //Clock interno (Fosc/2)
	BCLR	T3CONbits, #1
;GDM v1.c,221 :: 		T3CONbits.TON = 1;      //Liga o Timer 3
	BSET	T3CONbits, #15
;GDM v1.c,224 :: 		IC1CONbits.ICM=0b00; // Disable Input Capture 1 module
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#248, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	W1, [W0]
;GDM v1.c,225 :: 		IC1CONbits.ICTMR= 1; // Select Timer2 as the IC1 Time base
	BSET	IC1CONbits, #7
;GDM v1.c,226 :: 		IC1CONbits.ICI= 0b01; // Interrupt on every second capture event
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
;GDM v1.c,227 :: 		IC1CONbits.ICM= 0b011; // Generate capture event on every Rising edge
	MOV.B	#3, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC1CONbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IC1CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	W1, [W0]
;GDM v1.c,230 :: 		IPC0bits.IC1IP = 1; // Setup IC1 interrupt priority level
	MOV.B	#16, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#112, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC0bits), W0
	MOV.B	W1, [W0]
;GDM v1.c,231 :: 		IFS0bits.IC1IF = 0; // Clear IC1 Interrupt Status Flag
	BCLR	IFS0bits, #1
;GDM v1.c,232 :: 		IEC0bits.IC1IE = 1; // Enable IC1 interrupt
	BSET	IEC0bits, #1
;GDM v1.c,235 :: 		IC2CONbits.ICM=0b00; // Disable Input Capture 2 module
	MOV	#lo_addr(IC2CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#248, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC2CONbits), W0
	MOV.B	W1, [W0]
;GDM v1.c,236 :: 		IC2CONbits.ICTMR= 1; // Select Timer2 as the IC2 Time base
	BSET	IC2CONbits, #7
;GDM v1.c,237 :: 		IC2CONbits.ICI= 0b01; // Interrupt on every second capture event
	MOV.B	#32, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC2CONbits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#96, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC2CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC2CONbits), W0
	MOV.B	W1, [W0]
;GDM v1.c,238 :: 		IC2CONbits.ICM= 0b011; // Generate capture event on every Rising edge
	MOV.B	#3, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC2CONbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IC2CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC2CONbits), W0
	MOV.B	W1, [W0]
;GDM v1.c,241 :: 		IPC1bits.IC2IP = 1; // Setup IC2 interrupt priority level
	MOV.B	#16, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#112, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC1bits), W0
	MOV.B	W1, [W0]
;GDM v1.c,242 :: 		IFS0bits.IC2IF = 0; // Clear IC2 Interrupt Status Flag
	BCLR	IFS0bits, #5
;GDM v1.c,243 :: 		IEC0bits.IC2IE = 1; // Enable IC2 interrupt
	BSET	IEC0bits, #5
;GDM v1.c,246 :: 		IC7CONbits.ICM=0b00; // Disable Input Capture 7 module
	MOV	#lo_addr(IC7CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#248, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC7CONbits), W0
	MOV.B	W1, [W0]
;GDM v1.c,247 :: 		IC7CONbits.ICTMR= 0; // Select Timer3 as the IC7 Time base
	BCLR	IC7CONbits, #7
;GDM v1.c,248 :: 		IC7CONbits.ICI= 0b01; // Interrupt on every second capture event
	MOV.B	#32, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC7CONbits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#96, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC7CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC7CONbits), W0
	MOV.B	W1, [W0]
;GDM v1.c,249 :: 		IC7CONbits.ICM= 0b011; // Generate capture event on every Rising edge
	MOV.B	#3, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC7CONbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IC7CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC7CONbits), W0
	MOV.B	W1, [W0]
;GDM v1.c,252 :: 		IPC5bits.IC7IP = 1; // Setup IC7 interrupt priority level
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC5bits
;GDM v1.c,253 :: 		IFS1bits.IC7IF = 0; // Clear IC7 Interrupt Status Flag
	BCLR	IFS1bits, #6
;GDM v1.c,254 :: 		IEC1bits.IC7IE = 1; // Enable IC7 interrupt
	BSET	IEC1bits, #6
;GDM v1.c,256 :: 		}
L_end_InitTimersCapture:
	RETURN
; end of _InitTimersCapture

_delay2S:

;GDM v1.c,673 :: 		void delay2S(){
;GDM v1.c,674 :: 		delay_ms(2000);
	MOV	#407, W8
	MOV	#59185, W7
L_delay2S0:
	DEC	W7
	BRA NZ	L_delay2S0
	DEC	W8
	BRA NZ	L_delay2S0
;GDM v1.c,675 :: 		}
L_end_delay2S:
	RETURN
; end of _delay2S

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;GDM v1.c,676 :: 		void main() {
;GDM v1.c,677 :: 		InitClock();
	CALL	_InitClock
;GDM v1.c,678 :: 		AD1PCFGL = 0xFFFF;
	MOV	#65535, W0
	MOV	WREG, AD1PCFGL
;GDM v1.c,680 :: 		ADPCFG = 0xFFFF;       // Configure AN pins as digital I/O
	MOV	#65535, W0
	MOV	WREG, ADPCFG
;GDM v1.c,681 :: 		TRISA = 0x00;
	CLR	TRISA
;GDM v1.c,682 :: 		TRISB = 0;             // Initialize PORTB as output
	CLR	TRISB
;GDM v1.c,683 :: 		TRISC = 0;             // Initialize PORTC as output
	CLR	TRISC
;GDM v1.c,684 :: 		LATA = 0;
	CLR	LATA
;GDM v1.c,685 :: 		LATB = 0;              // Set PORTB to zero
	CLR	LATB
;GDM v1.c,686 :: 		LATC = 0;              // Set PORTC to zero*/
	CLR	LATC
;GDM v1.c,692 :: 		while(1) {
L_main2:
;GDM v1.c,696 :: 		RA7_bit = ~RA7_bit;
	BTG	RA7_bit, #7
;GDM v1.c,697 :: 		RA9_bit = ~RA9_bit;
	BTG	RA9_bit, #9
;GDM v1.c,698 :: 		RA10_bit = ~RA10_bit;
	BTG	RA10_bit, #10
;GDM v1.c,699 :: 		LATB = ~LATB;        // Invert PORTB value
	COM	LATB
;GDM v1.c,700 :: 		LATC = ~LATC;        // Invert PORTC value
	COM	LATC
;GDM v1.c,701 :: 		Delay_ms(1000);
	MOV	#204, W8
	MOV	#29592, W7
L_main4:
	DEC	W7
	BRA NZ	L_main4
	DEC	W8
	BRA NZ	L_main4
;GDM v1.c,702 :: 		}
	GOTO	L_main2
;GDM v1.c,703 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
