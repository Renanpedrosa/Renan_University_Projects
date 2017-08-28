
_PGA_Set_Gain:

;PGA_Drivers_LSM.c,9 :: 		void PGA_Set_Gain(char ganho)
;PGA_Drivers_LSM.c,11 :: 		SPI_CS_PGA1 = 0;                             //Ativar PGA1
	BCLR	LATC5_bit, #5
;PGA_Drivers_LSM.c,12 :: 		SPI1_Write(PGA_Inst_WriteGN);                //Endereçar o ganho
	PUSH	W10
	MOV	#64, W10
	CALL	_SPI1_Write
	POP	W10
;PGA_Drivers_LSM.c,13 :: 		SPI1_Write(ganho);                            //Ganho de x vezes
	ZE	W10, W10
	CALL	_SPI1_Write
;PGA_Drivers_LSM.c,14 :: 		SPI_CS_PGA1 = 1;                             //Desativar o PGA1
	BSET	LATC5_bit, #5
;PGA_Drivers_LSM.c,15 :: 		Delay_us(4);                                 //Tempo para mudança de ganho
	MOV	#53, W7
L_PGA_Set_Gain0:
	DEC	W7
	BRA NZ	L_PGA_Set_Gain0
	NOP
;PGA_Drivers_LSM.c,16 :: 		}
L_end_PGA_Set_Gain:
	RETURN
; end of _PGA_Set_Gain

_PGA_Set_Channel:

;PGA_Drivers_LSM.c,18 :: 		void PGA_Set_Channel(char canal)
;PGA_Drivers_LSM.c,20 :: 		SPI_CS_PGA1 = 0;                     //Ativar PGA1
	BCLR	LATC5_bit, #5
;PGA_Drivers_LSM.c,21 :: 		SPI1_Write(PGA_Inst_WriteCH);        //Endereçar a configuração de Canais do PGA
	PUSH	W10
	MOV	#65, W10
	CALL	_SPI1_Write
	POP	W10
;PGA_Drivers_LSM.c,22 :: 		SPI1_Write(canal);                   //Selecionar o Canal x do PGA1
	ZE	W10, W10
	CALL	_SPI1_Write
;PGA_Drivers_LSM.c,23 :: 		SPI_CS_PGA1 = 1;                     //Desativar o PGA1
	BSET	LATC5_bit, #5
;PGA_Drivers_LSM.c,24 :: 		Delay_us(4);                         //Tempo para ocorrer a troca de canais dentro do PGA
	MOV	#53, W7
L_PGA_Set_Channel2:
	DEC	W7
	BRA NZ	L_PGA_Set_Channel2
	NOP
;PGA_Drivers_LSM.c,25 :: 		}
L_end_PGA_Set_Channel:
	RETURN
; end of _PGA_Set_Channel
