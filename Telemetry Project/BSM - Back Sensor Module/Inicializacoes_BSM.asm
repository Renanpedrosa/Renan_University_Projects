
_InitClock:

;Inicializacoes_BSM.c,7 :: 		void InitClock()
;Inicializacoes_BSM.c,20 :: 		CLKDIV &= 0xFFE0;   //Zera os bits do PLL prescaler que serão modificados
	MOV	#65504, W1
	MOV	#lo_addr(CLKDIV), W0
	AND	W1, [W0], [W0]
;Inicializacoes_BSM.c,21 :: 		CLKDIV |= 0x0002;   //PLL prescaler = N1 = 4
	MOV	#2, W1
	MOV	#lo_addr(CLKDIV), W0
	IOR	W1, [W0], [W0]
;Inicializacoes_BSM.c,22 :: 		PLLFBD = 38;        //PLL multiplier = M = 40
	MOV	#38, W0
	MOV	WREG, PLLFBD
;Inicializacoes_BSM.c,23 :: 		CLKDIV &= 0xFF3F;   //PLL postscaler = N2 = 2
	MOV	#65343, W1
	MOV	#lo_addr(CLKDIV), W0
	AND	W1, [W0], [W0]
;Inicializacoes_BSM.c,32 :: 		MOV #0x743, w1         ;note memory address of OSSCONH address
	MOV	#1859, W1
;Inicializacoes_BSM.c,33 :: 		MOV.B #0b011, w0
	MOV.B	#3, W0
;Inicializacoes_BSM.c,34 :: 		MOV #0x78, w2
	MOV	#120, W2
;Inicializacoes_BSM.c,35 :: 		MOV #0x9A, w3
	MOV	#154, W3
;Inicializacoes_BSM.c,36 :: 		MOV.B w2, [w1]
	MOV.B	W2, [W1]
;Inicializacoes_BSM.c,37 :: 		MOV.B w3, [w1]
	MOV.B	W3, [W1]
;Inicializacoes_BSM.c,38 :: 		MOV.B w0, [w1]
	MOV.B	W0, [W1]
;Inicializacoes_BSM.c,40 :: 		MOV #0x742, w1         ;note memory address of OSSCONL address
	MOV	#1858, W1
;Inicializacoes_BSM.c,41 :: 		MOV.B #0x01, w0
	MOV.B	#1, W0
;Inicializacoes_BSM.c,42 :: 		MOV #0x46, w2
	MOV	#70, W2
;Inicializacoes_BSM.c,43 :: 		MOV #0x57, w3
	MOV	#87, W3
;Inicializacoes_BSM.c,44 :: 		MOV.B w2, [w1]
	MOV.B	W2, [W1]
;Inicializacoes_BSM.c,45 :: 		MOV.B w3, [w1]
	MOV.B	W3, [W1]
;Inicializacoes_BSM.c,46 :: 		MOV.B w0, [w1]
	MOV.B	W0, [W1]
;Inicializacoes_BSM.c,47 :: 		NOP
	NOP
;Inicializacoes_BSM.c,48 :: 		NOP
	NOP
;Inicializacoes_BSM.c,50 :: 		while(OSCCONbits.COSC != 0b011) {}
L_InitClock0:
	MOV	OSCCONbits, WREG
	MOV	W0, W1
	MOV	#28672, W0
	AND	W1, W0, W1
	LSR	W1, #12, W1
	CP	W1, #3
	BRA NZ	L__InitClock3
	GOTO	L_InitClock1
L__InitClock3:
	GOTO	L_InitClock0
L_InitClock1:
;Inicializacoes_BSM.c,54 :: 		}
L_end_InitClock:
	RETURN
; end of _InitClock

_InitPorts:

;Inicializacoes_BSM.c,57 :: 		void InitPorts()
;Inicializacoes_BSM.c,60 :: 		AD1PCFGL = 0x1000;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#4096, W0
	MOV	WREG, AD1PCFGL
;Inicializacoes_BSM.c,63 :: 		TRISA0_bit  = 1;        //ANA0
	BSET	TRISA0_bit, #0
;Inicializacoes_BSM.c,64 :: 		TRISA1_bit  = 1;        //ANA1
	BSET	TRISA1_bit, #1
;Inicializacoes_BSM.c,65 :: 		TRISB0_bit  = 1;        //ANA2
	BSET	TRISB0_bit, #0
;Inicializacoes_BSM.c,66 :: 		TRISB1_bit  = 1;        //ANA3
	BSET	TRISB1_bit, #1
;Inicializacoes_BSM.c,67 :: 		TRISB2_bit  = 1;        //ANA4
	BSET	TRISB2_bit, #2
;Inicializacoes_BSM.c,68 :: 		TRISB3_bit  = 1;        //ANA5
	BSET	TRISB3_bit, #3
;Inicializacoes_BSM.c,69 :: 		TRISC0_bit  = 1;        //ANA6
	BSET	TRISC0_bit, #0
;Inicializacoes_BSM.c,70 :: 		TRISC1_bit  = 1;        //ANA7
	BSET	TRISC1_bit, #1
;Inicializacoes_BSM.c,71 :: 		TRISC2_bit  = 1;        //ANA8
	BSET	TRISC2_bit, #2
;Inicializacoes_BSM.c,72 :: 		TRISB15_bit = 1;        //ANA9
	BSET	TRISB15_bit, #15
;Inicializacoes_BSM.c,73 :: 		TRISB14_bit = 1;        //ANA10
	BSET	TRISB14_bit, #14
;Inicializacoes_BSM.c,74 :: 		TRISB13_bit = 1;        //ANA11
	BSET	TRISB13_bit, #13
;Inicializacoes_BSM.c,77 :: 		TRISB11_bit = 1;           //DIG1
	BSET	TRISB11_bit, #11
;Inicializacoes_BSM.c,78 :: 		TRISB12_bit = 1;           //DIG2
	BSET	TRISB12_bit, #12
;Inicializacoes_BSM.c,79 :: 		TRISB10_bit = 1;           //DIG3
	BSET	TRISB10_bit, #10
;Inicializacoes_BSM.c,80 :: 		TRISC9_bit = 1;           //DIG4
	BSET	TRISC9_bit, #9
;Inicializacoes_BSM.c,81 :: 		TRISB4_bit = 1;           //DIG5
	BSET	TRISB4_bit, #4
;Inicializacoes_BSM.c,82 :: 		TRISA10_bit = 1;           //DIG6
	BSET	TRISA10_bit, #10
;Inicializacoes_BSM.c,83 :: 		TRISB7_bit = 1;           //DIG7
	BSET	TRISB7_bit, #7
;Inicializacoes_BSM.c,84 :: 		TRISA7_bit = 1;           //DIG8
	BSET	TRISA7_bit, #7
;Inicializacoes_BSM.c,85 :: 		TRISA8_bit = 0;           //LED1
	BCLR	TRISA8_bit, #8
;Inicializacoes_BSM.c,86 :: 		TRISA9_bit = 0;           //LED2
	BCLR	TRISA9_bit, #9
;Inicializacoes_BSM.c,87 :: 		TRISC7_bit = 0;           //CAN 1 TX
	BCLR	TRISC7_bit, #7
;Inicializacoes_BSM.c,88 :: 		TRISC8_bit = 1;           //CAN 1 RX
	BSET	TRISC8_bit, #8
;Inicializacoes_BSM.c,89 :: 		TRISC3_bit = 0;           //UART 1 TX
	BCLR	TRISC3_bit, #3
;Inicializacoes_BSM.c,90 :: 		TRISC4_bit = 1;           //UART 1 RX
	BSET	TRISC4_bit, #4
;Inicializacoes_BSM.c,91 :: 		TRISB9_bit = 1;           //I2C SDA
	BSET	TRISB9_bit, #9
;Inicializacoes_BSM.c,92 :: 		TRISB8_bit = 0;           //I2C SCL
	BCLR	TRISB8_bit, #8
;Inicializacoes_BSM.c,93 :: 		TRISA4_bit = 1;           //Botão 1
	BSET	TRISA4_bit, #4
;Inicializacoes_BSM.c,94 :: 		TRISC5_bit = 0;           //Relé 1 - RL1
	BCLR	TRISC5_bit, #5
;Inicializacoes_BSM.c,95 :: 		TRISC6_bit = 0;           //Relé 2 - RL2
	BCLR	TRISC6_bit, #6
;Inicializacoes_BSM.c,99 :: 		Unlock_IOLOCK();
	CALL	_Unlock_IOLOCK
;Inicializacoes_BSM.c,102 :: 		PPS_Mapping(12, _INPUT, _IC1);     //Configura DIG2 como Entrada do Input Capture 1
	MOV.B	#6, W12
	MOV.B	#1, W11
	MOV.B	#12, W10
	CALL	_PPS_Mapping
;Inicializacoes_BSM.c,103 :: 		PPS_Mapping(10, _INPUT, _IC2);     //Configura DIG3 como Entrada do Input Capture 2
	MOV.B	#7, W12
	MOV.B	#1, W11
	MOV.B	#10, W10
	CALL	_PPS_Mapping
;Inicializacoes_BSM.c,104 :: 		PPS_Mapping(25, _INPUT, _IC7);     //Configura DIG4 como Entrada do Input Capture 7
	MOV.B	#8, W12
	MOV.B	#1, W11
	MOV.B	#25, W10
	CALL	_PPS_Mapping
;Inicializacoes_BSM.c,105 :: 		PPS_Mapping(23, _OUTPUT, _C1TX);     //Configura o pino 4 como TX do CAN
	MOV.B	#16, W12
	CLR	W11
	MOV.B	#23, W10
	CALL	_PPS_Mapping
;Inicializacoes_BSM.c,106 :: 		PPS_Mapping(24, _INPUT, _CIRX);      //Configura o pino 5 como RX da CAN
	MOV.B	#24, W12
	MOV.B	#1, W11
	MOV.B	#24, W10
	CALL	_PPS_Mapping
;Inicializacoes_BSM.c,107 :: 		Lock_IOLOCK();
	CALL	_Lock_IOLOCK
;Inicializacoes_BSM.c,108 :: 		}
L_end_InitPorts:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _InitPorts

_InitTimersCapture:

;Inicializacoes_BSM.c,114 :: 		void InitTimersCapture()
;Inicializacoes_BSM.c,129 :: 		T3CONbits.TCKPS = 0b10; //1:64 prescaler(Período de 1,6us e estouro em 104ms)
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
;Inicializacoes_BSM.c,130 :: 		T3CONbits.TCS = 0;      //Clock interno (Fosc/2)
	BCLR	T3CONbits, #1
;Inicializacoes_BSM.c,131 :: 		T3CONbits.TON = 1;      //Liga o Timer 3
	BSET	T3CONbits, #15
;Inicializacoes_BSM.c,134 :: 		T2CONbits.TCKPS = 0b11; //1:256 prescaler(Período de 6,4us e estouro em 419ms)
	MOV	#lo_addr(T2CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#48, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(T2CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_BSM.c,135 :: 		T2CONbits.T32 = 0;      //Funciona como um timer de 16bits
	BCLR	T2CONbits, #3
;Inicializacoes_BSM.c,136 :: 		T2CONbits.TCS = 0;      //Clock interno (Fosc/2)
	BCLR	T2CONbits, #1
;Inicializacoes_BSM.c,137 :: 		T2CONbits.TON = 1;      //Liga o Timer 2
	BSET	T2CONbits, #15
;Inicializacoes_BSM.c,141 :: 		IC1CONbits.ICM=0b00; // Disable Input Capture 1 module
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#248, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_BSM.c,142 :: 		IC1CONbits.ICTMR= 0; // Select Timer3 as the IC1 Time base
	BCLR	IC1CONbits, #7
;Inicializacoes_BSM.c,143 :: 		IC1CONbits.ICI= 0b01; // Interrupt on every second capture event
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
;Inicializacoes_BSM.c,144 :: 		IC1CONbits.ICM= 0b011; // Generate capture event on every Rising edge
	MOV.B	#3, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC1CONbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IC1CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_BSM.c,147 :: 		IPC0bits.IC1IP = 1; // Setup IC1 interrupt priority level
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
;Inicializacoes_BSM.c,148 :: 		IFS0bits.IC1IF = 0; // Clear IC1 Interrupt Status Flag
	BCLR	IFS0bits, #1
;Inicializacoes_BSM.c,149 :: 		IEC0bits.IC1IE = 1; // Enable IC1 interrupt
	BSET	IEC0bits, #1
;Inicializacoes_BSM.c,152 :: 		IC2CONbits.ICM=0b00; // Disable Input Capture 2 module
	MOV	#lo_addr(IC2CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#248, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC2CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_BSM.c,153 :: 		IC2CONbits.ICTMR= 1; // Select Timer2 as the IC2 Time base
	BSET	IC2CONbits, #7
;Inicializacoes_BSM.c,154 :: 		IC2CONbits.ICI= 0b01; // Interrupt on every second capture event
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
;Inicializacoes_BSM.c,155 :: 		IC2CONbits.ICM= 0b011; // Generate capture event on every Rising edge
	MOV.B	#3, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC2CONbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IC2CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC2CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_BSM.c,158 :: 		IPC1bits.IC2IP = 1; // Setup IC2 interrupt priority level
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
;Inicializacoes_BSM.c,159 :: 		IFS0bits.IC2IF = 0; // Clear IC2 Interrupt Status Flag
	BCLR	IFS0bits, #5
;Inicializacoes_BSM.c,160 :: 		IEC0bits.IC2IE = 1; // Enable IC2 interrupt
	BSET	IEC0bits, #5
;Inicializacoes_BSM.c,163 :: 		IC7CONbits.ICM=0b00; // Disable Input Capture 7 module
	MOV	#lo_addr(IC7CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#248, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC7CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_BSM.c,164 :: 		IC7CONbits.ICTMR= 1; // Select Timer2 as the IC7 Time base
	BSET	IC7CONbits, #7
;Inicializacoes_BSM.c,165 :: 		IC7CONbits.ICI= 0b01; // Interrupt on every second capture event
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
;Inicializacoes_BSM.c,166 :: 		IC7CONbits.ICM= 0b011; // Generate capture event on every Rising edge
	MOV.B	#3, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC7CONbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IC7CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC7CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_BSM.c,169 :: 		IPC5bits.IC7IP = 1; // Setup IC7 interrupt priority level
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC5bits
;Inicializacoes_BSM.c,170 :: 		IFS1bits.IC7IF = 0; // Clear IC7 Interrupt Status Flag
	BCLR	IFS1bits, #6
;Inicializacoes_BSM.c,171 :: 		IEC1bits.IC7IE = 1; // Enable IC7 interrupt
	BSET	IEC1bits, #6
;Inicializacoes_BSM.c,173 :: 		}
L_end_InitTimersCapture:
	RETURN
; end of _InitTimersCapture

_InitMain:

;Inicializacoes_BSM.c,175 :: 		void InitMain()
;Inicializacoes_BSM.c,181 :: 		}
L_end_InitMain:
	RETURN
; end of _InitMain
