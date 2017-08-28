
_ADXL345_Write:

;Funcoes_ADXL.c,29 :: 		void ADXL345_Write(unsigned short address, unsigned short data1) {
;Funcoes_ADXL.c,30 :: 		unsigned short internal = 0;
	PUSH	W10
;Funcoes_ADXL.c,31 :: 		internal = address | _SPI_WRITE;                 // Register and Write bit
	ZE	W10, W0
;Funcoes_ADXL.c,33 :: 		ADXL_CS = 0;
	BCLR	LATC5_bit, #5
;Funcoes_ADXL.c,34 :: 		SPI1_Write(internal);
	ZE	W0, W10
	CALL	_SPI1_Write
;Funcoes_ADXL.c,35 :: 		SPI1_Write(data1);
	ZE	W11, W10
	CALL	_SPI1_Write
;Funcoes_ADXL.c,36 :: 		ADXL_CS = 1;
	BSET	LATC5_bit, #5
;Funcoes_ADXL.c,37 :: 		}
L_end_ADXL345_Write:
	POP	W10
	RETURN
; end of _ADXL345_Write

_ADXL345_Read:

;Funcoes_ADXL.c,39 :: 		unsigned short ADXL345_Read(unsigned short address) {
;Funcoes_ADXL.c,40 :: 		unsigned short internal = 0;
	PUSH	W10
;Funcoes_ADXL.c,41 :: 		internal = address | _SPI_READ;                  // Register and Read bit
	ZE	W10, W1
	MOV	#128, W0
	IOR	W1, W0, W0
;Funcoes_ADXL.c,43 :: 		ADXL_CS = 0;
	BCLR	LATC5_bit, #5
;Funcoes_ADXL.c,44 :: 		SPI1_Write(internal);
	ZE	W0, W10
	CALL	_SPI1_Write
;Funcoes_ADXL.c,45 :: 		internal = SPI1_Read(0);
	CLR	W10
	CALL	_SPI1_Read
;Funcoes_ADXL.c,46 :: 		ADXL_CS = 1;
	BSET	LATC5_bit, #5
;Funcoes_ADXL.c,48 :: 		return internal;
;Funcoes_ADXL.c,49 :: 		}
;Funcoes_ADXL.c,48 :: 		return internal;
;Funcoes_ADXL.c,49 :: 		}
L_end_ADXL345_Read:
	POP	W10
	RETURN
; end of _ADXL345_Read

_ADXL345_Init:

;Funcoes_ADXL.c,65 :: 		void ADXL345_Init()
;Funcoes_ADXL.c,68 :: 		ADXL345_Write(_POWER_CTL, 0x00);
	PUSH	W10
	PUSH	W11
	CLR	W11
	MOV.B	#45, W10
	CALL	_ADXL345_Write
;Funcoes_ADXL.c,71 :: 		ADXL345_Write(_DATA_FORMAT, 0x02);
	MOV.B	#2, W11
	MOV.B	#49, W10
	CALL	_ADXL345_Write
;Funcoes_ADXL.c,74 :: 		ADXL345_Write(_BW_RATE, _SPEED_100);
	MOV.B	#10, W11
	MOV.B	#44, W10
	CALL	_ADXL345_Write
;Funcoes_ADXL.c,77 :: 		ADXL345_Write(_POWER_CTL, 0x08);
	MOV.B	#8, W11
	MOV.B	#45, W10
	CALL	_ADXL345_Write
;Funcoes_ADXL.c,78 :: 		}
L_end_ADXL345_Init:
	POP	W11
	POP	W10
	RETURN
; end of _ADXL345_Init

_ADXL345_Read_XYZ:
	LNK	#2

;Funcoes_ADXL.c,80 :: 		void ADXL345_Read_XYZ(char * dados)
;Funcoes_ADXL.c,82 :: 		dados[0] = ADXL345_Read(_DATAX0);
	PUSH	W10
	MOV	W10, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV.B	#50, W10
	CALL	_ADXL345_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;Funcoes_ADXL.c,83 :: 		dados[1] = ADXL345_Read(_DATAX1);
	ADD	W10, #1, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV.B	#51, W10
	CALL	_ADXL345_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;Funcoes_ADXL.c,84 :: 		dados[2] = ADXL345_Read(_DATAY0);
	ADD	W10, #2, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV.B	#52, W10
	CALL	_ADXL345_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;Funcoes_ADXL.c,85 :: 		dados[3] = ADXL345_Read(_DATAY1);
	ADD	W10, #3, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV.B	#53, W10
	CALL	_ADXL345_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;Funcoes_ADXL.c,86 :: 		dados[4] = ADXL345_Read(_DATAZ0);
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV.B	#54, W10
	CALL	_ADXL345_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;Funcoes_ADXL.c,87 :: 		dados[5] = ADXL345_Read(_DATAZ1);
	ADD	W10, #5, W0
	MOV	W0, [W14+0]
	MOV.B	#55, W10
	CALL	_ADXL345_Read
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;Funcoes_ADXL.c,88 :: 		}
L_end_ADXL345_Read_XYZ:
	POP	W10
	ULNK
	RETURN
; end of _ADXL345_Read_XYZ
