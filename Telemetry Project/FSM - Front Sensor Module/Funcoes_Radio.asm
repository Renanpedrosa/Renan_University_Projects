
_Write_UART_UDATA:
	LNK	#0

;Funcoes_Radio.c,14 :: 		void Write_UART_UDATA(char *ID, unsigned dado1, unsigned dado2, unsigned dado3, unsigned dado4)
;Funcoes_Radio.c,17 :: 		WordToStr(dado1,dado1_txt);
	PUSH	W10
	PUSH	W11
; dado4 start address is: 8 (W4)
	MOV	[W14-8], W4
	PUSH	W10
	MOV	W11, W10
	MOV	#lo_addr(_dado1_txt), W11
	CALL	_WordToStr
;Funcoes_Radio.c,18 :: 		WordToStr(dado2,dado2_txt);
	MOV	#lo_addr(_dado2_txt), W11
	MOV	W12, W10
	CALL	_WordToStr
;Funcoes_Radio.c,19 :: 		WordToStr(dado3,dado3_txt);
	MOV	#lo_addr(_dado3_txt), W11
	MOV	W13, W10
	CALL	_WordToStr
;Funcoes_Radio.c,20 :: 		WordToStr(dado4,dado4_txt);
	MOV	#lo_addr(_dado4_txt), W11
	MOV	W4, W10
; dado4 end address is: 8 (W4)
	CALL	_WordToStr
	POP	W10
;Funcoes_Radio.c,22 :: 		UART1_Write_Text(ID);
	CALL	_UART1_Write_Text
;Funcoes_Radio.c,23 :: 		UART1_Write_Text(dado1_txt);
	MOV	#lo_addr(_dado1_txt), W10
	CALL	_UART1_Write_Text
;Funcoes_Radio.c,24 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;Funcoes_Radio.c,25 :: 		UART1_Write_Text(dado2_txt);
	MOV	#lo_addr(_dado2_txt), W10
	CALL	_UART1_Write_Text
;Funcoes_Radio.c,26 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;Funcoes_Radio.c,27 :: 		UART1_Write_Text(dado3_txt);
	MOV	#lo_addr(_dado3_txt), W10
	CALL	_UART1_Write_Text
;Funcoes_Radio.c,28 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;Funcoes_Radio.c,29 :: 		UART1_Write_Text(dado4_txt);
	MOV	#lo_addr(_dado4_txt), W10
	CALL	_UART1_Write_Text
;Funcoes_Radio.c,30 :: 		UART1_Write(DATA_end);
	MOV	#59, W10
	CALL	_UART1_Write
;Funcoes_Radio.c,31 :: 		UART1_Write(CR);
	MOV	#13, W10
	CALL	_UART1_Write
;Funcoes_Radio.c,32 :: 		UART1_Write(LF);
	MOV	#10, W10
	CALL	_UART1_Write
;Funcoes_Radio.c,33 :: 		}
L_end_Write_UART_UDATA:
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _Write_UART_UDATA

_GetGPSData:

;Funcoes_Radio.c,34 :: 		void GetGPSData(char *string)
;Funcoes_Radio.c,37 :: 		}
L_end_GetGPSData:
	RETURN
; end of _GetGPSData
