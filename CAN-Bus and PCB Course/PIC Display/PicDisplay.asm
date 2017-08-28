
_init_main:
;PicDisplay.c,84 :: 		void init_main()
;PicDisplay.c,87 :: 		}
	RETURN      0
; end of _init_main

_main:
;PicDisplay.c,89 :: 		void main()
;PicDisplay.c,104 :: 		TRISC  = 0;                  //Port C é saída
	CLRF        TRISC+0 
;PicDisplay.c,105 :: 		TRISB  = 0x08;               //RB2 é saída(TXD) e RB3 é entrada (RXD)
	MOVLW       8
	MOVWF       TRISB+0 
;PicDisplay.c,106 :: 		OSCCON = 0b01110011;         //Oscilador interno selecionado(8MHz)
	MOVLW       115
	MOVWF       OSCCON+0 
;PicDisplay.c,116 :: 		mask = -1;
	MOVLW       255
	MOVWF       main_mask_L0+0 
	MOVLW       255
	MOVWF       main_mask_L0+1 
	MOVWF       main_mask_L0+2 
	MOVWF       main_mask_L0+3 
;PicDisplay.c,126 :: 		_CAN_TX_NO_RTR_FRAME;
	MOVLW       244
	MOVWF       main_Send_Flags_L0+0 
;PicDisplay.c,128 :: 		Read_Flags = 0;
	CLRF        main_Read_Flags_L0+0 
;PicDisplay.c,131 :: 		CANInitialize(SJW, BRP, Phase_Seg1, Phase_Seg2, Prop_Seg, Init_Flags);
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
;PicDisplay.c,134 :: 		CANSetOperationMode(_CAN_MODE_CONFIG,0xFF);               // set CONFIGURATION mode
	MOVLW       128
	MOVWF       FARG_CANSetOperationMode_mode+0 
	MOVLW       255
	MOVWF       FARG_CANSetOperationMode_WAIT+0 
	CALL        _CANSetOperationMode+0, 0
;PicDisplay.c,135 :: 		CANSetMask(_CAN_MASK_B1,mask,_CAN_CONFIG_XTD_MSG);          // set all mask1 bits to ones
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
;PicDisplay.c,136 :: 		CANSetMask(_CAN_MASK_B2,mask,_CAN_CONFIG_XTD_MSG);          // set all mask2 bits to ones
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
;PicDisplay.c,137 :: 		CANSetFilter(_CAN_FILTER_B2_F4,ID_Temp1,_CAN_CONFIG_XTD_MSG);// set id of filter B2_F4 to 1st Temp msg
	MOVLW       5
	MOVWF       FARG_CANSetFilter_CAN_FILTER+0 
	MOVLW       232
	MOVWF       FARG_CANSetFilter_val+0 
	MOVLW       3
	MOVWF       FARG_CANSetFilter_val+1 
	MOVLW       0
	MOVWF       FARG_CANSetFilter_val+2 
	MOVLW       0
	MOVWF       FARG_CANSetFilter_val+3 
	MOVLW       247
	MOVWF       FARG_CANSetFilter_CAN_CONFIG_FLAGS+0 
	CALL        _CANSetFilter+0, 0
;PicDisplay.c,138 :: 		CANSetFilter(_CAN_FILTER_B2_F3,ID_Temp2,_CAN_CONFIG_XTD_MSG);// set id of filter B2_F3 to 2nd Temp msg
	MOVLW       4
	MOVWF       FARG_CANSetFilter_CAN_FILTER+0 
	MOVLW       208
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
;PicDisplay.c,141 :: 		CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);               // set NORMAL mode
	CLRF        FARG_CANSetOperationMode_mode+0 
	MOVLW       255
	MOVWF       FARG_CANSetOperationMode_WAIT+0 
	CALL        _CANSetOperationMode+0, 0
;PicDisplay.c,144 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;PicDisplay.c,145 :: 		Lcd_Cmd(_LCD_CLEAR);                // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;PicDisplay.c,146 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);           // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;PicDisplay.c,149 :: 		Lcd_Out(1,1,introTxt1);                 // Write text in first row
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _introTxt1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_introTxt1+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PicDisplay.c,150 :: 		Lcd_Out(2,1,introTxt2);                 // Write text in second row
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _introTxt2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_introTxt2+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PicDisplay.c,151 :: 		Delay_ms(2000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 0
	BRA         L_main0
	DECFSZ      R12, 1, 0
	BRA         L_main0
	DECFSZ      R11, 1, 0
	BRA         L_main0
	NOP
;PicDisplay.c,152 :: 		Lcd_Cmd(_LCD_CLEAR);                // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;PicDisplay.c,153 :: 		Lcd_Out(1,1,Temp1Txt);                 // Write temp1
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _Temp1Txt+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_Temp1Txt+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PicDisplay.c,154 :: 		Lcd_Out(2,1,Temp2Txt);                 // Write temp2
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _Temp2Txt+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_Temp2Txt+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PicDisplay.c,156 :: 		while(1)
L_main1:
;PicDisplay.c,160 :: 		RxTx_Data[0] = 'T';
	MOVLW       84
	MOVWF       main_RxTx_Data_L0+0 
;PicDisplay.c,161 :: 		CANWrite(ID_ReqT1, RxTx_Data, 1, Send_Flags);
	MOVLW       233
	MOVWF       FARG_CANWrite_id+0 
	MOVLW       3
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
;PicDisplay.c,162 :: 		dt = 0;
	CLRF        main_dt_L0+0 
;PicDisplay.c,165 :: 		dt = CANRead(&Rx_ID, RxTx_Data, &len, &Read_Flags);
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
;PicDisplay.c,166 :: 		LED = dt;
	BTFSC       R0, 0 
	GOTO        L__main12
	BCF         LATC6_bit+0, 6 
	GOTO        L__main13
L__main12:
	BSF         LATC6_bit+0, 6 
L__main13:
;PicDisplay.c,169 :: 		if((Rx_ID == ID_Temp1)&& dt)
	MOVF        main_Rx_ID_L0+3, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main14
	MOVF        main_Rx_ID_L0+2, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main14
	MOVF        main_Rx_ID_L0+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main14
	MOVF        main_Rx_ID_L0+0, 0 
	XORLW       232
L__main14:
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
	MOVF        main_dt_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main5
L__main11:
;PicDisplay.c,172 :: 		ByteToStr(temperature,txt);
	MOVF        main_RxTx_Data_L0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       main_txt_L0+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(main_txt_L0+0
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;PicDisplay.c,173 :: 		Lcd_Out(1,9,txt);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       9
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_txt_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_txt_L0+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PicDisplay.c,174 :: 		}
L_main5:
;PicDisplay.c,176 :: 		Delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main6:
	DECFSZ      R13, 1, 0
	BRA         L_main6
	DECFSZ      R12, 1, 0
	BRA         L_main6
	DECFSZ      R11, 1, 0
	BRA         L_main6
	NOP
	NOP
;PicDisplay.c,179 :: 		CANWrite(ID_ReqT2, RxTx_Data, 1, Send_Flags);
	MOVLW       209
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
;PicDisplay.c,182 :: 		if((Rx_ID == ID_Temp2)&& dt)
	MOVF        main_Rx_ID_L0+3, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main15
	MOVF        main_Rx_ID_L0+2, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main15
	MOVF        main_Rx_ID_L0+1, 0 
	XORLW       7
	BTFSS       STATUS+0, 2 
	GOTO        L__main15
	MOVF        main_Rx_ID_L0+0, 0 
	XORLW       208
L__main15:
	BTFSS       STATUS+0, 2 
	GOTO        L_main9
	MOVF        main_dt_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main9
L__main10:
;PicDisplay.c,185 :: 		ByteToStr(temperature,txt);
	MOVF        main_RxTx_Data_L0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       main_txt_L0+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(main_txt_L0+0
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;PicDisplay.c,186 :: 		Lcd_Out(2,9,txt);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       9
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_txt_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_txt_L0+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PicDisplay.c,187 :: 		}
L_main9:
;PicDisplay.c,191 :: 		}
	GOTO        L_main1
;PicDisplay.c,192 :: 		}
	GOTO        $+0
; end of _main
