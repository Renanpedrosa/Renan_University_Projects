
_InitClock:

;Inicializacoes_FSM.c,23 :: 		void InitClock()
;Inicializacoes_FSM.c,31 :: 		CLKDIV &= 0xFFE0;   //Zera os bits do PLL prescaler que serão modificados
	MOV	#65504, W1
	MOV	#lo_addr(CLKDIV), W0
	AND	W1, [W0], [W0]
;Inicializacoes_FSM.c,32 :: 		CLKDIV |= 0x0003;   //PLL prescaler = N1 = 5
	MOV	#3, W1
	MOV	#lo_addr(CLKDIV), W0
	IOR	W1, [W0], [W0]
;Inicializacoes_FSM.c,33 :: 		PLLFBD = 38;        //PLL multiplier = M = 40
	MOV	#38, W0
	MOV	WREG, PLLFBD
;Inicializacoes_FSM.c,34 :: 		CLKDIV &= 0xFF3F;   //PLL postscaler = N2 = 2
	MOV	#65343, W1
	MOV	#lo_addr(CLKDIV), W0
	AND	W1, [W0], [W0]
;Inicializacoes_FSM.c,55 :: 		MOV #0x743, w1         ;note memory address of OSSCONH address
	MOV	#1859, W1
;Inicializacoes_FSM.c,56 :: 		MOV.B #0b011, w0
	MOV.B	#3, W0
;Inicializacoes_FSM.c,57 :: 		MOV #0x78, w2
	MOV	#120, W2
;Inicializacoes_FSM.c,58 :: 		MOV #0x9A, w3
	MOV	#154, W3
;Inicializacoes_FSM.c,59 :: 		MOV.B w2, [w1]
	MOV.B	W2, [W1]
;Inicializacoes_FSM.c,60 :: 		MOV.B w3, [w1]
	MOV.B	W3, [W1]
;Inicializacoes_FSM.c,61 :: 		MOV.B w0, [w1]
	MOV.B	W0, [W1]
;Inicializacoes_FSM.c,63 :: 		MOV #0x742, w1         ;note memory address of OSSCONL address
	MOV	#1858, W1
;Inicializacoes_FSM.c,64 :: 		MOV.B #0x03, w0
	MOV.B	#3, W0
;Inicializacoes_FSM.c,65 :: 		MOV #0x46, w2
	MOV	#70, W2
;Inicializacoes_FSM.c,66 :: 		MOV #0x57, w3
	MOV	#87, W3
;Inicializacoes_FSM.c,67 :: 		MOV.B w2, [w1]
	MOV.B	W2, [W1]
;Inicializacoes_FSM.c,68 :: 		MOV.B w3, [w1]
	MOV.B	W3, [W1]
;Inicializacoes_FSM.c,69 :: 		MOV.B w0, [w1]
	MOV.B	W0, [W1]
;Inicializacoes_FSM.c,70 :: 		NOP
	NOP
;Inicializacoes_FSM.c,71 :: 		NOP
	NOP
;Inicializacoes_FSM.c,77 :: 		}
L_end_InitClock:
	RETURN
; end of _InitClock

_InitPorts:

;Inicializacoes_FSM.c,79 :: 		void InitPorts()
;Inicializacoes_FSM.c,82 :: 		AD1PCFGL = 0x01BE;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#446, W0
	MOV	WREG, AD1PCFGL
;Inicializacoes_FSM.c,85 :: 		TRISA10_bit = 0;        //Seta o pino do Led como uma saída digital
	BCLR	TRISA10_bit, #10
;Inicializacoes_FSM.c,86 :: 		TRISA7_bit  = 0;        //Seta o pino do GPteste como como uma saída digital
	BCLR	TRISA7_bit, #7
;Inicializacoes_FSM.c,87 :: 		TRISB2_bit  = 0;        //Seta o pino do AUX como como uma saída digital
	BCLR	TRISB2_bit, #2
;Inicializacoes_FSM.c,88 :: 		TRISB4_bit  = 1;        //Seta o pino do botão 1 como uma entrada digital
	BSET	TRISB4_bit, #4
;Inicializacoes_FSM.c,89 :: 		TRISA4_bit  = 1;        //Seta o pino do botão 2 como uma entrada digital
	BSET	TRISA4_bit, #4
;Inicializacoes_FSM.c,90 :: 		TRISB1_bit  = 1;        //Seta o pino do botão 3 como uma entrada digital
	BSET	TRISB1_bit, #1
;Inicializacoes_FSM.c,91 :: 		TRISB0_bit  = 1;        //Seta o pino do botão 4 como uma entrada digital
	BSET	TRISB0_bit, #0
;Inicializacoes_FSM.c,92 :: 		TRISA1_bit  = 1;        //Seta o pino do jumper como uma entrada digital
	BSET	TRISA1_bit, #1
;Inicializacoes_FSM.c,93 :: 		TRISA2_bit  = 1;        //Clock In
	BSET	TRISA2_bit, #2
;Inicializacoes_FSM.c,94 :: 		TRISA3_bit  = 0;        //Clock Out
	BCLR	TRISA3_bit, #3
;Inicializacoes_FSM.c,97 :: 		TRISC0_bit  = 1;        //AN6 - GPIN_0
	BSET	TRISC0_bit, #0
;Inicializacoes_FSM.c,98 :: 		TRISC1_bit  = 1;        //AN7 - GPIN_1 (Digital para VelFE)
	BSET	TRISC1_bit, #1
;Inicializacoes_FSM.c,99 :: 		TRISC2_bit  = 1;        //AN8 - GPIN_2 (Digital para VelFD)
	BSET	TRISC2_bit, #2
;Inicializacoes_FSM.c,100 :: 		TRISB3_bit  = 1;        //AN5 - GPIN_3 (Digital para RPM)
	BSET	TRISB3_bit, #3
;Inicializacoes_FSM.c,101 :: 		TRISB15_bit = 1;        //AN9 - GPIN_4
	BSET	TRISB15_bit, #15
;Inicializacoes_FSM.c,102 :: 		TRISA0_bit  = 1;        //AN0 - GPIN_6
	BSET	TRISA0_bit, #0
;Inicializacoes_FSM.c,103 :: 		TRISB14_bit = 1;        //AN12 - Acelerômetro eixo X
	BSET	TRISB14_bit, #14
;Inicializacoes_FSM.c,104 :: 		TRISB12_bit = 1;        //AN10 - Acelerômetro eixo Y
	BSET	TRISB12_bit, #12
;Inicializacoes_FSM.c,105 :: 		TRISB13_bit = 1;        //AN11 - Acelerômetro eixo Z
	BSET	TRISB13_bit, #13
;Inicializacoes_FSM.c,108 :: 		ADXL_CS_Direction = 0;         //CS - Adxl345
	BCLR	TRISC5_bit, #5
;Inicializacoes_FSM.c,109 :: 		Mmc_Chip_Select_Direction = 0; //CS - Cartão SD
	BCLR	TRISB8_bit, #8
;Inicializacoes_FSM.c,110 :: 		SPExpanderRST_Direction = 0;   //Reset - Expansor SPI MCP23S17
	BCLR	TRISA9_bit, #9
;Inicializacoes_FSM.c,111 :: 		SPExpanderCS_Direction = 0;    //ChipSelect - Expansor SPI MCP23S17
	BCLR	TRISA8_bit, #8
;Inicializacoes_FSM.c,112 :: 		TRISB5_bit = 0;                //SPI - SCK
	BCLR	TRISB5_bit, #5
;Inicializacoes_FSM.c,113 :: 		TRISB6_bit = 1;                //SPI - SDI
	BSET	TRISB6_bit, #6
;Inicializacoes_FSM.c,114 :: 		TRISB7_bit = 0;                //SPI - SDO
	BCLR	TRISB7_bit, #7
;Inicializacoes_FSM.c,115 :: 		TRISC8_bit = 0;                //Uart1 - TX  Conectado ao rádio da telemetria
	BCLR	TRISC8_bit, #8
;Inicializacoes_FSM.c,116 :: 		TRISC7_bit = 1;                //Uart1 - RX
	BSET	TRISC7_bit, #7
;Inicializacoes_FSM.c,117 :: 		TRISB9_bit = 0;                //Uart2 - TX  Conectado ao GPS
	BCLR	TRISB9_bit, #9
;Inicializacoes_FSM.c,118 :: 		TRISC6_bit = 1;                //Uart2 - RX  Conectado ao GPS
	BSET	TRISC6_bit, #6
;Inicializacoes_FSM.c,119 :: 		TRISC3_bit = 0;                //CAN bus TX
	BCLR	TRISC3_bit, #3
;Inicializacoes_FSM.c,120 :: 		TRISC4_bit = 1;                //CAN bus RX
	BSET	TRISC4_bit, #4
;Inicializacoes_FSM.c,121 :: 		ADXL_CS = 1;
	BSET	LATC5_bit, #5
;Inicializacoes_FSM.c,124 :: 		Unlock_IOLOCK();
	CALL	_Unlock_IOLOCK
;Inicializacoes_FSM.c,125 :: 		PPS_Mapping(5, _OUTPUT, _SCK1OUT); //Configura o pino 41 como saída do clock do SPI1
	MOV.B	#8, W12
	CLR	W11
	MOV.B	#5, W10
	CALL	_PPS_Mapping
;Inicializacoes_FSM.c,126 :: 		PPS_Mapping(6, _INPUT, _SDI1);     //Configura o pino 42 como entrada serial do SPI1
	MOV.B	#15, W12
	MOV.B	#1, W11
	MOV.B	#6, W10
	CALL	_PPS_Mapping
;Inicializacoes_FSM.c,127 :: 		PPS_Mapping(7, _OUTPUT, _SDO1);    //Configura o pino 43 como saída serial do SPI1
	MOV.B	#7, W12
	CLR	W11
	MOV.B	#7, W10
	CALL	_PPS_Mapping
;Inicializacoes_FSM.c,128 :: 		PPS_Mapping(24, _OUTPUT, _U1TX);   //Configura o pino 4 como TX da UART1
	MOV.B	#3, W12
	CLR	W11
	MOV.B	#24, W10
	CALL	_PPS_Mapping
;Inicializacoes_FSM.c,129 :: 		PPS_Mapping(23, _INPUT, _U1RX);    //Configura o pino 3 como RX da UART1
	MOV.B	#11, W12
	MOV.B	#1, W11
	MOV.B	#23, W10
	CALL	_PPS_Mapping
;Inicializacoes_FSM.c,130 :: 		PPS_Mapping(9, _OUTPUT, _U2TX);    //Configura o pino 1 como TX da UART2
	MOV.B	#5, W12
	CLR	W11
	MOV.B	#9, W10
	CALL	_PPS_Mapping
;Inicializacoes_FSM.c,131 :: 		PPS_Mapping(22, _INPUT, _U2RX);    //Configura o pino 2 como RX da UART2
	MOV.B	#13, W12
	MOV.B	#1, W11
	MOV.B	#22, W10
	CALL	_PPS_Mapping
;Inicializacoes_FSM.c,132 :: 		PPS_Mapping(19, _OUTPUT, _C1TX);   //Configura o pino 36 como TX do CAN
	MOV.B	#16, W12
	CLR	W11
	MOV.B	#19, W10
	CALL	_PPS_Mapping
;Inicializacoes_FSM.c,133 :: 		PPS_Mapping(20, _INPUT, _CIRX);    //Configura o pino 37 como RX do CAN
	MOV.B	#24, W12
	MOV.B	#1, W11
	MOV.B	#20, W10
	CALL	_PPS_Mapping
;Inicializacoes_FSM.c,134 :: 		PPS_Mapping(17, _INPUT, _IC1);     //Configura o pino 26 (GPIN1) como Entrada do Input Capture 1 (Velocidade Roda)
	MOV.B	#6, W12
	MOV.B	#1, W11
	MOV.B	#17, W10
	CALL	_PPS_Mapping
;Inicializacoes_FSM.c,135 :: 		PPS_Mapping(18, _INPUT, _IC2);     //Configura o pino 27 (GPIN2) como Entrada do Input Capture 2 (Velocidade Roda)
	MOV.B	#7, W12
	MOV.B	#1, W11
	MOV.B	#18, W10
	CALL	_PPS_Mapping
;Inicializacoes_FSM.c,136 :: 		PPS_Mapping(3, _INPUT, _IC7);     //Configura o pino 24 (GPIN3) como Entrada do Input Capture 7   (Rotação)
	MOV.B	#8, W12
	MOV.B	#1, W11
	MOV.B	#3, W10
	CALL	_PPS_Mapping
;Inicializacoes_FSM.c,137 :: 		Lock_IOLOCK();
	CALL	_Lock_IOLOCK
;Inicializacoes_FSM.c,138 :: 		}
L_end_InitPorts:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _InitPorts

_InitTimersCapture:

;Inicializacoes_FSM.c,142 :: 		void InitTimersCapture()
;Inicializacoes_FSM.c,145 :: 		IEC0.F3 = 1;                     // Enable Timer1 interrupt
	BSET	IEC0, #3
;Inicializacoes_FSM.c,146 :: 		TMR1 = 0xE795;                   // Timer1 starts counting from 57722
	MOV	#59285, W0
	MOV	WREG, TMR1
;Inicializacoes_FSM.c,147 :: 		T1CON.F5 = 1;                    // Set Timer1 Prescaler to 1:256
	BSET	T1CON, #5
;Inicializacoes_FSM.c,148 :: 		T1CON.F4 = 1;
	BSET	T1CON, #4
;Inicializacoes_FSM.c,149 :: 		IFS0.F3 = 0;                     // Clear Timer1 interrupt flag
	BCLR	IFS0, #3
;Inicializacoes_FSM.c,154 :: 		T1CON.F15 = 1;                   // Start Timer 1*/
	BSET	T1CON, #15
;Inicializacoes_FSM.c,157 :: 		T5CONbits.TCKPS = 0b01; //1:8 prescaler(Período de 0,2us e estouro em 13,1ms)
	MOV.B	#16, W0
	MOV.B	W0, W1
	MOV	#lo_addr(T5CONbits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#48, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(T5CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(T5CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_FSM.c,158 :: 		T5CONbits.TCS = 0;      //Clock interno (Fosc/2)
	BCLR	T5CONbits, #1
;Inicializacoes_FSM.c,159 :: 		TMR5 = 0xF447;          //Carregando o Timer 5 para gerar uma interrupção a cada 600us
	MOV	#62535, W0
	MOV	WREG, TMR5
;Inicializacoes_FSM.c,160 :: 		T5IE_bit = 1;
	BSET	T5IE_bit, #12
;Inicializacoes_FSM.c,161 :: 		T5IF_bit = 0;
	BCLR	T5IF_bit, #12
;Inicializacoes_FSM.c,162 :: 		T5CONbits.TON = 1;      //Liga o Timer 2
	BSET	T5CONbits, #15
;Inicializacoes_FSM.c,165 :: 		T2CONbits.TCKPS = 0b11; //1:256 prescaler(Período de 6,4us e estouro em 419ms)
	MOV	#lo_addr(T2CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#48, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(T2CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_FSM.c,166 :: 		T2CONbits.T32 = 0;      //Funciona como um timer de 16bits
	BCLR	T2CONbits, #3
;Inicializacoes_FSM.c,167 :: 		T2CONbits.TCS = 0;      //Clock interno (Fosc/2)
	BCLR	T2CONbits, #1
;Inicializacoes_FSM.c,168 :: 		T2CONbits.TON = 1;      //Liga o Timer 2
	BSET	T2CONbits, #15
;Inicializacoes_FSM.c,171 :: 		T3CONbits.TCKPS = 0b10; //1:64 prescaler(Período de 1,6us e estouro em 104ms)
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
;Inicializacoes_FSM.c,172 :: 		T3CONbits.TCS = 0;      //Clock interno (Fosc/2)
	BCLR	T3CONbits, #1
;Inicializacoes_FSM.c,173 :: 		T3CONbits.TON = 1;      //Liga o Timer 3
	BSET	T3CONbits, #15
;Inicializacoes_FSM.c,176 :: 		IC1CONbits.ICM=0b00; // Disable Input Capture 1 module
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#248, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_FSM.c,177 :: 		IC1CONbits.ICTMR= 1; // Select Timer2 as the IC1 Time base
	BSET	IC1CONbits, #7
;Inicializacoes_FSM.c,178 :: 		IC1CONbits.ICI= 0b01; // Interrupt on every second capture event
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
;Inicializacoes_FSM.c,179 :: 		IC1CONbits.ICM= 0b011; // Generate capture event on every Rising edge
	MOV.B	#3, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC1CONbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IC1CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC1CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_FSM.c,182 :: 		IPC0bits.IC1IP = 1; // Setup IC1 interrupt priority level
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
;Inicializacoes_FSM.c,183 :: 		IFS0bits.IC1IF = 0; // Clear IC1 Interrupt Status Flag
	BCLR	IFS0bits, #1
;Inicializacoes_FSM.c,184 :: 		IEC0bits.IC1IE = 1; // Enable IC1 interrupt
	BSET	IEC0bits, #1
;Inicializacoes_FSM.c,187 :: 		IC2CONbits.ICM=0b00; // Disable Input Capture 2 module
	MOV	#lo_addr(IC2CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#248, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC2CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_FSM.c,188 :: 		IC2CONbits.ICTMR= 1; // Select Timer2 as the IC2 Time base
	BSET	IC2CONbits, #7
;Inicializacoes_FSM.c,189 :: 		IC2CONbits.ICI= 0b01; // Interrupt on every second capture event
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
;Inicializacoes_FSM.c,190 :: 		IC2CONbits.ICM= 0b011; // Generate capture event on every Rising edge
	MOV.B	#3, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC2CONbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IC2CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC2CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_FSM.c,193 :: 		IPC1bits.IC2IP = 1; // Setup IC2 interrupt priority level
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
;Inicializacoes_FSM.c,194 :: 		IFS0bits.IC2IF = 0; // Clear IC2 Interrupt Status Flag
	BCLR	IFS0bits, #5
;Inicializacoes_FSM.c,195 :: 		IEC0bits.IC2IE = 1; // Enable IC2 interrupt
	BSET	IEC0bits, #5
;Inicializacoes_FSM.c,198 :: 		IC7CONbits.ICM=0b00; // Disable Input Capture 7 module
	MOV	#lo_addr(IC7CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#248, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IC7CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_FSM.c,199 :: 		IC7CONbits.ICTMR= 0; // Select Timer3 as the IC7 Time base
	BCLR	IC7CONbits, #7
;Inicializacoes_FSM.c,200 :: 		IC7CONbits.ICI= 0b01; // Interrupt on every second capture event
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
;Inicializacoes_FSM.c,201 :: 		IC7CONbits.ICM= 0b011; // Generate capture event on every Rising edge
	MOV.B	#3, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IC7CONbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IC7CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IC7CONbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_FSM.c,204 :: 		IPC5bits.IC7IP = 1; // Setup IC7 interrupt priority level
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC5bits
;Inicializacoes_FSM.c,205 :: 		IFS1bits.IC7IF = 0; // Clear IC7 Interrupt Status Flag
	BCLR	IFS1bits, #6
;Inicializacoes_FSM.c,206 :: 		IEC1bits.IC7IE = 1; // Enable IC7 interrupt
	BSET	IEC1bits, #6
;Inicializacoes_FSM.c,208 :: 		}
L_end_InitTimersCapture:
	RETURN
; end of _InitTimersCapture

_InitMain:

;Inicializacoes_FSM.c,210 :: 		void InitMain()
;Inicializacoes_FSM.c,212 :: 		ADC1_Init_Advanced(_ADC_12bit, _ADC_INTERNAL_REF);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	W11
	MOV	#1, W10
	CALL	_ADC1_Init_Advanced
;Inicializacoes_FSM.c,214 :: 		UART1_Init(115200);             // Initialize UART1 module at 115200 bps
	MOV	#49664, W10
	MOV	#1, W11
	CALL	_UART1_Init
;Inicializacoes_FSM.c,215 :: 		Delay_ms(1000);                  // Wait for UART module to stabilize
	MOV	#204, W8
	MOV	#29592, W7
L_InitMain0:
	DEC	W7
	BRA NZ	L_InitMain0
	DEC	W8
	BRA NZ	L_InitMain0
;Inicializacoes_FSM.c,217 :: 		UART1_Write_Text("Inicializando módulo...");
	MOV	#lo_addr(?lstr1_Inicializacoes_FSM), W10
	CALL	_UART1_Write_Text
;Inicializacoes_FSM.c,218 :: 		UART1_Write(0X0D);
	MOV	#13, W10
	CALL	_UART1_Write
;Inicializacoes_FSM.c,219 :: 		UART1_Write(0X0A);
	MOV	#10, W10
	CALL	_UART1_Write
;Inicializacoes_FSM.c,221 :: 		UART2_Init(57600);              // Initialize UART2 module at 19200 bps for GPS
	MOV	#57600, W10
	MOV	#0, W11
	CALL	_UART2_Init
;Inicializacoes_FSM.c,222 :: 		U2MODEbits.UARTEN = 0;
	BCLR	U2MODEbits, #15
;Inicializacoes_FSM.c,223 :: 		U2RXIF_bit = 0;                  //Zerar flag de interrupções
	BCLR	U2RXIF_bit, #14
;Inicializacoes_FSM.c,224 :: 		IPC7bits.U2RXIP = 0;             // Definir prioridade (baixa)
	MOV	IPC7bits, W1
	MOV	#63743, W0
	AND	W1, W0, W0
	MOV	WREG, IPC7bits
;Inicializacoes_FSM.c,225 :: 		U2STAbits.URXISEL = 0b11;        //Interrupção a cada recebimento de caractere
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#192, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	W1, [W0]
;Inicializacoes_FSM.c,226 :: 		IFS1bits.U2TXIF = 0;	// Clear the Transmit Interrupt Flag
	BCLR	IFS1bits, #15
;Inicializacoes_FSM.c,227 :: 		IEC1bits.U2TXIE = 1;	// Enable Transmit Interrupts
	BSET	IEC1bits, #15
;Inicializacoes_FSM.c,228 :: 		IFS1bits.U2RXIF = 0;	// Clear the Recieve Interrupt Flag
	BCLR	IFS1bits, #14
;Inicializacoes_FSM.c,229 :: 		IEC1bits.U2RXIE = 1;	// Enable Recieve Interrupts
	BSET	IEC1bits, #14
;Inicializacoes_FSM.c,230 :: 		U2MODEbits.UARTEN = 1;
	BSET	U2MODEbits, #15
;Inicializacoes_FSM.c,231 :: 		Delay_ms(1000);                  // Wait for UART2 module to stabilize
	MOV	#204, W8
	MOV	#29592, W7
L_InitMain2:
	DEC	W7
	BRA NZ	L_InitMain2
	DEC	W8
	BRA NZ	L_InitMain2
;Inicializacoes_FSM.c,235 :: 		UART2_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29");
	MOV	#lo_addr(?lstr2_Inicializacoes_FSM), W10
	CALL	_UART2_Write_Text
;Inicializacoes_FSM.c,236 :: 		UART2_Write(0x0D);
	MOV	#13, W10
	CALL	_UART2_Write
;Inicializacoes_FSM.c,237 :: 		UART2_Write(0x0A);
	MOV	#10, W10
	CALL	_UART2_Write
;Inicializacoes_FSM.c,238 :: 		Delay_ms(500);
	MOV	#102, W8
	MOV	#47563, W7
L_InitMain4:
	DEC	W7
	BRA NZ	L_InitMain4
	DEC	W8
	BRA NZ	L_InitMain4
	NOP
;Inicializacoes_FSM.c,240 :: 		UART2_Write_Text("$PMTK220,200*2C");
	MOV	#lo_addr(?lstr3_Inicializacoes_FSM), W10
	CALL	_UART2_Write_Text
;Inicializacoes_FSM.c,241 :: 		UART2_Write(0x0D);
	MOV	#13, W10
	CALL	_UART2_Write
;Inicializacoes_FSM.c,242 :: 		UART2_Write(0x0A);
	MOV	#10, W10
	CALL	_UART2_Write
;Inicializacoes_FSM.c,243 :: 		Delay_ms(500);
	MOV	#102, W8
	MOV	#47563, W7
L_InitMain6:
	DEC	W7
	BRA NZ	L_InitMain6
	DEC	W8
	BRA NZ	L_InitMain6
	NOP
;Inicializacoes_FSM.c,249 :: 		SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_8, _SPI_PRESCALE_PRI_4,_SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
	MOV	#2, W13
	CLR	W12
	CLR	W11
	MOV	#32, W10
	CLR	W0
	PUSH	W0
	MOV	#64, W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI1_Init_Advanced
	SUB	#8, W15
;Inicializacoes_FSM.c,251 :: 		ADXL345_Init();
	CALL	_ADXL345_Init
;Inicializacoes_FSM.c,256 :: 		}
L_end_InitMain:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _InitMain
