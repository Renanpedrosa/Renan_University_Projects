
_init_main:
;PicTemp2.c,57 :: 		void init_main()
;PicTemp2.c,60 :: 		}
	RETURN      0
; end of _init_main

_main:
;PicTemp2.c,62 :: 		void main()
;PicTemp2.c,80 :: 		TRISA  = 0xFF;               //PortA é entrada
	MOVLW       255
	MOVWF       TRISA+0 
;PicTemp2.c,81 :: 		ADCON1 = 0x0C;               //RA0, RA1 e RA2 são ent. analógicas.
	MOVLW       12
	MOVWF       ADCON1+0 
;PicTemp2.c,82 :: 		TRISB  = 0x08;               //RB2 é saída(TXD) e RB3 é entrada (RXD)
	MOVLW       8
	MOVWF       TRISB+0 
;PicTemp2.c,83 :: 		TRISC  = 0;                  //PortC é saída
	CLRF        TRISC+0 
;PicTemp2.c,84 :: 		OSCCON = 0b01110011;         //Oscilador interno selecionado(8MHz)
	MOVLW       115
	MOVWF       OSCCON+0 
;PicTemp2.c,95 :: 		mask = -1;
	MOVLW       255
	MOVWF       main_mask_L0+0 
	MOVLW       255
	MOVWF       main_mask_L0+1 
	MOVWF       main_mask_L0+2 
	MOVWF       main_mask_L0+3 
;PicTemp2.c,105 :: 		_CAN_TX_NO_RTR_FRAME;
	MOVLW       244
	MOVWF       main_Send_Flags_L0+0 
;PicTemp2.c,106 :: 		Read_Flags = 0;
	CLRF        main_Read_Flags_L0+0 
;PicTemp2.c,109 :: 		CANInitialize(SJW, BRP, Phase_Seg1, Phase_Seg2, Prop_Seg, Init_Flags);
	MOVLW       1
	MOVWF       FARG_CANInitialize_SJW+0 
	MOVLW       1
	MOVWF       FARG_CANInitialize_BRP+0 
	MOVLW       6
	MOVWF       FARG_CANInitialize_PHSEG1+0 
	MOVLW       7
	MOVWF       FARG_CANInitialize_PHSEG2+0 
	MOVLW       6
	MOVWF       FARG_CANInitialize_PROPSEG+0 
	MOVLW       211
	MOVWF       FARG_CANInitialize_CAN_CONFIG_FLAGS+0 
	CALL        _CANInitialize+0, 0
;PicTemp2.c,112 :: 		CANSetOperationMode(_CAN_MODE_CONFIG,0xFF);               // set CONFIGURATION mode
	MOVLW       128
	MOVWF       FARG_CANSetOperationMode_mode+0 
	MOVLW       255
	MOVWF       FARG_CANSetOperationMode_WAIT+0 
	CALL        _CANSetOperationMode+0, 0
;PicTemp2.c,113 :: 		CANSetMask(_CAN_MASK_B1,mask,_CAN_CONFIG_XTD_MSG);          // set all mask1 bits to ones
	CLRF        FARG_CANSetMask_CAN_MASK+0 
	MOVF        main_mask_L0+0, 0 
	MOVWF       FARG_CANSetMask_val+0 
	MOVF        main_mask_L0+1, 0 
	MOVWF       FARG_CANSetMask_val+1 
	MOVF        main_mask_L0+2, 0 
	MOVWF       FARG_CANSetMask_val+2 
	MOVF        main_mask_L0+3, 0 
	MOVWF       FARG_CANSetMask_val+3 
	MOVLW       247
	MOVWF       FARG_CANSetMask_CAN_CONFIG_FLAGS+0 
	CALL        _CANSetMask+0, 0
;PicTemp2.c,114 :: 		CANSetMask(_CAN_MASK_B2,mask,_CAN_CONFIG_XTD_MSG);          // set all mask2 bits to ones
	MOVLW       1
	MOVWF       FARG_CANSetMask_CAN_MASK+0 
	MOVF        main_mask_L0+0, 0 
	MOVWF       FARG_CANSetMask_val+0 
	MOVF        main_mask_L0+1, 0 
	MOVWF       FARG_CANSetMask_val+1 
	MOVF        main_mask_L0+2, 0 
	MOVWF       FARG_CANSetMask_val+2 
	MOVF        main_mask_L0+3, 0 
	MOVWF       FARG_CANSetMask_val+3 
	MOVLW       247
	MOVWF       FARG_CANSetMask_CAN_CONFIG_FLAGS+0 
	CALL        _CANSetMask+0, 0
;PicTemp2.c,115 :: 		CANSetFilter(_CAN_FILTER_B2_F3,ID_ReqT2,_CAN_CONFIG_XTD_MSG);// set id of filter B2_F3 to 1st Temp req
	MOVLW       4
	MOVWF       FARG_CANSetFilter_CAN_FILTER+0 
	MOVLW       209
	MOVWF       FARG_CANSetFilter_val+0 
	MOVLW       7
	MOVWF       FARG_CANSetFilter_val+1 
	MOVLW       0
	MOVWF       FARG_CANSetFilter_val+2 
	MOVLW       0
	MOVWF       FARG_CANSetFilter_val+3 
	MOVLW       247
	MOVWF       FARG_CANSetFilter_CAN_CONFIG_FLAGS+0 
	CALL        _CANSetFilter+0, 0
;PicTemp2.c,118 :: 		CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);               // set NORMAL mode
	CLRF        FARG_CANSetOperationMode_mode+0 
	MOVLW       255
	MOVWF       FARG_CANSetOperationMode_WAIT+0 
	CALL        _CANSetOperationMode+0, 0
;PicTemp2.c,120 :: 		while(1)
L_main0:
;PicTemp2.c,122 :: 		dt = 0;
	CLRF        main_dt_L0+0 
;PicTemp2.c,125 :: 		dt = CANRead(&Rx_ID, RxTx_Data, &len, &Read_Flags);
	MOVLW       main_Rx_ID_L0+0
	MOVWF       FARG_CANRead_id+0 
	MOVLW       hi_addr(main_Rx_ID_L0+0
	MOVWF       FARG_CANRead_id+1 
	MOVLW       main_RxTx_Data_L0+0
	MOVWF       FARG_CANRead_data_+0 
	MOVLW       hi_addr(main_RxTx_Data_L0+0
	MOVWF       FARG_CANRead_data_+1 
	MOVLW       main_len_L0+0
	MOVWF       FARG_CANRead_dataLen+0 
	MOVLW       hi_addr(main_len_L0+0
	MOVWF       FARG_CANRead_dataLen+1 
	MOVLW       main_Read_Flags_L0+0
	MOVWF       FARG_CANRead_CAN_RX_MSG_FLAGS+0 
	MOVLW       hi_addr(main_Read_Flags_L0+0
	MOVWF       FARG_CANRead_CAN_RX_MSG_FLAGS+1 
	CALL        _CANRead+0, 0
	MOVF        R0, 0 
	MOVWF       main_dt_L0+0 
;PicTemp2.c,128 :: 		LED = dt;
	BTFSC       R0, 0 
	GOTO        L__main6
	BCF         LATC6_bit+0, 6 
	GOTO        L__main7
L__main6:
	BSF         LATC6_bit+0, 6 
L__main7:
;PicTemp2.c,131 :: 		if((Rx_ID == ID_ReqT2)&& dt)
	MOVF        main_Rx_ID_L0+3, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main8
	MOVF        main_Rx_ID_L0+2, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main8
	MOVF        main_Rx_ID_L0+1, 0 
	XORLW       7
	BTFSS       STATUS+0, 2 
	GOTO        L__main8
	MOVF        main_Rx_ID_L0+0, 0 
	XORLW       209
L__main8:
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_dt_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
L__main5:
;PicTemp2.c,133 :: 		temp = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;PicTemp2.c,134 :: 		mV = (unsigned long)temp * 5000/1024;
	MOVLW       0
	MOVWF       R2 
	MOVWF       R3 
	MOVLW       136
	MOVWF       R4 
	MOVLW       19
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       10
	MOVWF       R8 
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        R8, 0 
L__main9:
	BZ          L__main10
	RRCF        R7, 1 
	RRCF        R6, 1 
	RRCF        R5, 1 
	RRCF        R4, 1 
	BCF         R7, 7 
	ADDLW       255
	GOTO        L__main9
L__main10:
;PicTemp2.c,135 :: 		temperature = mV/10;
	MOVF        R4, 0 
	MOVWF       R0 
	MOVF        R5, 0 
	MOVWF       R1 
	MOVF        R6, 0 
	MOVWF       R2 
	MOVF        R7, 0 
	MOVWF       R3 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
;PicTemp2.c,136 :: 		RxTx_Data[0] = temperature;
	MOVF        R0, 0 
	MOVWF       main_RxTx_Data_L0+0 
;PicTemp2.c,137 :: 		CANWrite(ID_Temp2, RxTx_Data, 1, Send_Flags);
	MOVLW       208
	MOVWF       FARG_CANWrite_id+0 
	MOVLW       7
	MOVWF       FARG_CANWrite_id+1 
	MOVLW       0
	MOVWF       FARG_CANWrite_id+2 
	MOVLW       0
	MOVWF       FARG_CANWrite_id+3 
	MOVLW       main_RxTx_Data_L0+0
	MOVWF       FARG_CANWrite_data_+0 
	MOVLW       hi_addr(main_RxTx_Data_L0+0
	MOVWF       FARG_CANWrite_data_+1 
	MOVLW       1
	MOVWF       FARG_CANWrite_DataLen+0 
	MOVF        main_Send_Flags_L0+0, 0 
	MOVWF       FARG_CANWrite_CAN_TX_MSG_FLAGS+0 
	CALL        _CANWrite+0, 0
;PicTemp2.c,138 :: 		}
L_main4:
;PicTemp2.c,140 :: 		}
	GOTO        L_main0
;PicTemp2.c,141 :: 		}
	GOTO        $+0
; end of _main
