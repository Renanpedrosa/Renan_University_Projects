
_GetCap:
;Pletism�metro.c,215 :: 		int GetCap(long last_Cap)
;Pletism�metro.c,217 :: 		if(CAP.capInit == 0)
	BTFSC       _CAP+0, 3 
	GOTO        L_GetCap0
;Pletism�metro.c,220 :: 		PIR1.CCP1IF = 0;            //limpar interrupt flag do capture CCP1
	BCF         PIR1+0, 2 
;Pletism�metro.c,221 :: 		PIR1.TMR1IF = 0;            // ||        ||     ||  || timer1
	BCF         PIR1+0, 0 
;Pletism�metro.c,223 :: 		cntOvrf = 0;               //Resetar contagem de overflow
	CLRF        _cntOvrf+0 
;Pletism�metro.c,224 :: 		CAP.cnt = 0;               //Resetar para a primeira borda
	BCF         _CAP+0, 5 
;Pletism�metro.c,225 :: 		CAP.capTest = 0;           //Resetar indicador de medida completa
	BCF         _CAP+0, 6 
;Pletism�metro.c,227 :: 		TMR1H = 0;
	CLRF        TMR1H+0 
;Pletism�metro.c,228 :: 		TMR1L = 0;
	CLRF        TMR1L+0 
;Pletism�metro.c,229 :: 		T1CON = 0x00;               //Iniciar Timer 1 1/4 desligado
	CLRF        T1CON+0 
;Pletism�metro.c,230 :: 		PIE1.CCP1IE = 1;            // setar interrup��o do capture CCP1
	BSF         PIE1+0, 2 
;Pletism�metro.c,231 :: 		PIE1.TMR1IE = 1;            // enable Timer1 interrupt
	BSF         PIE1+0, 0 
;Pletism�metro.c,233 :: 		CAP.capInit = 1;
	BSF         _CAP+0, 3 
;Pletism�metro.c,235 :: 		return last_Cap;
	MOVF        FARG_GetCap_last_Cap+0, 0 
	MOVWF       R0 
	MOVF        FARG_GetCap_last_Cap+1, 0 
	MOVWF       R1 
	RETURN      0
;Pletism�metro.c,236 :: 		}
L_GetCap0:
;Pletism�metro.c,237 :: 		if(CAP.capTest==1)        //Se ocorreu a contagem ,
	BTFSS       _CAP+0, 6 
	GOTO        L_GetCap1
;Pletism�metro.c,239 :: 		CAP.capInit = 0;
	BCF         _CAP+0, 3 
;Pletism�metro.c,241 :: 		Hi(cntCap2) = High_B2;               //Somar o byte superior com o byte
	MOVF        _High_B2+0, 0 
	MOVWF       _cntCap2+1 
;Pletism�metro.c,242 :: 		Lo(cntCap2) = Low_B2;
	MOVF        _Low_B2+0, 0 
	MOVWF       _cntCap2+0 
;Pletism�metro.c,246 :: 		OnLed = 1;
	BSF         PORTB+0, 2 
;Pletism�metro.c,247 :: 		return cntCap2;   //Periodo em microsegundos
	MOVF        _cntCap2+0, 0 
	MOVWF       R0 
	MOVF        _cntCap2+1, 0 
	MOVWF       R1 
	RETURN      0
;Pletism�metro.c,248 :: 		}
L_GetCap1:
;Pletism�metro.c,251 :: 		return last_Cap;
	MOVF        FARG_GetCap_last_Cap+0, 0 
	MOVWF       R0 
	MOVF        FARG_GetCap_last_Cap+1, 0 
	MOVWF       R1 
;Pletism�metro.c,253 :: 		}
	RETURN      0
; end of _GetCap

_KeyScan:
;Pletism�metro.c,266 :: 		unsigned short int KeyScan()
;Pletism�metro.c,269 :: 		if (Button(&PORTB, 7, 1, 1))                // detect logical one on RB7 pin
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0
	MOVWF       FARG_Button_port+1 
	MOVLW       7
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_KeyScan3
;Pletism�metro.c,270 :: 		oldstate = 1;
	MOVLW       1
	MOVWF       _oldstate+0 
L_KeyScan3:
;Pletism�metro.c,271 :: 		if (oldstate && Button(&PORTB, 7, 1, 0)) {  // detect one-to-zero transition on RB1 pin
	MOVF        _oldstate+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_KeyScan6
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0
	MOVWF       FARG_Button_port+1 
	MOVLW       7
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_KeyScan6
L__KeyScan50:
;Pletism�metro.c,272 :: 		oldstate = 0;
	CLRF        _oldstate+0 
;Pletism�metro.c,273 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	RETURN      0
;Pletism�metro.c,274 :: 		}
L_KeyScan6:
;Pletism�metro.c,277 :: 		if (Button(&PORTB, 6, 1, 1))                // detect logical one on RB6 pin
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0
	MOVWF       FARG_Button_port+1 
	MOVLW       6
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_KeyScan7
;Pletism�metro.c,278 :: 		oldstate1 = 1;
	MOVLW       1
	MOVWF       _oldstate1+0 
L_KeyScan7:
;Pletism�metro.c,279 :: 		if (oldstate1 && Button(&PORTB, 6, 1, 0)) {  // detect one-to-zero transition on RB1 pin
	MOVF        _oldstate1+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_KeyScan10
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0
	MOVWF       FARG_Button_port+1 
	MOVLW       6
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_KeyScan10
L__KeyScan49:
;Pletism�metro.c,280 :: 		oldstate1 = 0;
	CLRF        _oldstate1+0 
;Pletism�metro.c,281 :: 		return 2;
	MOVLW       2
	MOVWF       R0 
	RETURN      0
;Pletism�metro.c,282 :: 		}
L_KeyScan10:
;Pletism�metro.c,285 :: 		if (Button(&PORTB, 5, 1, 1))                // detect logical one on RB5 pin
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0
	MOVWF       FARG_Button_port+1 
	MOVLW       5
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_KeyScan11
;Pletism�metro.c,286 :: 		oldstate2 = 1;
	MOVLW       1
	MOVWF       _oldstate2+0 
L_KeyScan11:
;Pletism�metro.c,287 :: 		if (oldstate2 && Button(&PORTB, 5, 1, 0)) {  // detect one-to-zero transition on RB1 pin
	MOVF        _oldstate2+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_KeyScan14
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0
	MOVWF       FARG_Button_port+1 
	MOVLW       5
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_KeyScan14
L__KeyScan48:
;Pletism�metro.c,288 :: 		oldstate2 = 0;
	CLRF        _oldstate2+0 
;Pletism�metro.c,289 :: 		return 3;
	MOVLW       3
	MOVWF       R0 
	RETURN      0
;Pletism�metro.c,290 :: 		}
L_KeyScan14:
;Pletism�metro.c,293 :: 		if (Button(&PORTB, 4, 1, 1))                // detect logical one on RB4 pin
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0
	MOVWF       FARG_Button_port+1 
	MOVLW       4
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_KeyScan15
;Pletism�metro.c,294 :: 		oldstate3 = 1;
	MOVLW       1
	MOVWF       _oldstate3+0 
L_KeyScan15:
;Pletism�metro.c,295 :: 		if (oldstate3 && Button(&PORTB, 4, 1, 0)) {  // detect one-to-zero transition on RB1 pin
	MOVF        _oldstate3+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_KeyScan18
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0
	MOVWF       FARG_Button_port+1 
	MOVLW       4
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_KeyScan18
L__KeyScan47:
;Pletism�metro.c,296 :: 		oldstate3 = 0;
	CLRF        _oldstate3+0 
;Pletism�metro.c,297 :: 		return 4;
	MOVLW       4
	MOVWF       R0 
	RETURN      0
;Pletism�metro.c,298 :: 		}
L_KeyScan18:
;Pletism�metro.c,302 :: 		return 0;
	CLRF        R0 
;Pletism�metro.c,304 :: 		}
	RETURN      0
; end of _KeyScan

_InitMain:
;Pletism�metro.c,316 :: 		void InitMain()
;Pletism�metro.c,319 :: 		ADCON1 = 0x0F;          //Todos pinos AN s�o digitais.
	MOVLW       15
	MOVWF       ADCON1+0 
;Pletism�metro.c,322 :: 		TRISB = 0xF0;           //RB7-RB4 >> Input, RB3-RB0 >> Out
	MOVLW       240
	MOVWF       TRISB+0 
;Pletism�metro.c,324 :: 		LCD_RW = 1;             //Iniciando o LCD no modo Write(projeto ja na placa)
	BSF         RD1_bit+0, 1 
;Pletism�metro.c,325 :: 		LCD_RW_Direction = 0;
	BCF         TRISD1_bit+0, 1 
;Pletism�metro.c,328 :: 		TRISC.F2 = 1;
	BSF         TRISC+0, 2 
;Pletism�metro.c,329 :: 		TMR1H = 0;
	CLRF        TMR1H+0 
;Pletism�metro.c,330 :: 		TMR1L = 0;
	CLRF        TMR1L+0 
;Pletism�metro.c,331 :: 		INTCON = 0;
	CLRF        INTCON+0 
;Pletism�metro.c,332 :: 		PIE1 = 0;
	CLRF        PIE1+0 
;Pletism�metro.c,333 :: 		PIR1 = 0;
	CLRF        PIR1+0 
;Pletism�metro.c,334 :: 		CCP1CON = 5;            //Iniciar CCP1CON em capture a cada rising edge
	MOVLW       5
	MOVWF       CCP1CON+0 
;Pletism�metro.c,335 :: 		T1CON = 0x00;           //Iniciar Timer 1 1/4 desligado
	CLRF        T1CON+0 
;Pletism�metro.c,337 :: 		INTCON = 0xC0;              // Set GIE, PEIE(interrup��es globais ja setadas)
	MOVLW       192
	MOVWF       INTCON+0 
;Pletism�metro.c,339 :: 		CAP.capScale = 0;         //Colocar a escala para o periodo real,
	BCF         _CAP+0, 7 
;Pletism�metro.c,341 :: 		CAP.capInit = 0;
	BCF         _CAP+0, 3 
;Pletism�metro.c,342 :: 		cntOvrf = 0;
	CLRF        _cntOvrf+0 
;Pletism�metro.c,343 :: 		OnLed = 0;
	BCF         PORTB+0, 2 
;Pletism�metro.c,344 :: 		Capacitancia = 0;           //Valor inicial a ser mostrado no lcd caso
	CLRF        _Capacitancia+0 
	CLRF        _Capacitancia+1 
;Pletism�metro.c,346 :: 		Lcd_Init();                        // Lcd_Init_EP5, see Autocomplete
	CALL        _Lcd_Init+0, 0
;Pletism�metro.c,347 :: 		LCD_Cmd(_LCD_CURSOR_OFF);                 // send command to LCD (cursor off)
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Pletism�metro.c,348 :: 		LCD_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Pletism�metro.c,350 :: 		}
	RETURN      0
; end of _InitMain

_interrupt:
;Pletism�metro.c,356 :: 		void interrupt()
;Pletism�metro.c,358 :: 		if(PIR1.CCP1IF)            //Ocorreu interrup��o do Capture?
	BTFSS       PIR1+0, 2 
	GOTO        L_interrupt20
;Pletism�metro.c,360 :: 		if(CAP.cnt==0)                         //� a primeira borda?
	BTFSC       _CAP+0, 5 
	GOTO        L_interrupt21
;Pletism�metro.c,362 :: 		T1CON.TMR1ON = 1;                      //Ligar Timer1
	BSF         T1CON+0, 0 
;Pletism�metro.c,363 :: 		LedLcd = 1;
	BSF         PORTB+0, 3 
;Pletism�metro.c,364 :: 		cntOvrf = 0;
	CLRF        _cntOvrf+0 
;Pletism�metro.c,365 :: 		CAP.cnt = 1;                         //Proxima borda de subida
	BSF         _CAP+0, 5 
;Pletism�metro.c,366 :: 		}
	GOTO        L_interrupt22
L_interrupt21:
;Pletism�metro.c,369 :: 		High_B2 = CCPR1H;                     //Passando os valores do timer1
	MOVF        CCPR1H+0, 0 
	MOVWF       _High_B2+0 
;Pletism�metro.c,370 :: 		Low_B2 = CCPR1L;
	MOVF        CCPR1L+0, 0 
	MOVWF       _Low_B2+0 
;Pletism�metro.c,371 :: 		T1CON.TMR1ON = 0;
	BCF         T1CON+0, 0 
;Pletism�metro.c,372 :: 		PIE1.CCP1IE = 0;
	BCF         PIE1+0, 2 
;Pletism�metro.c,373 :: 		PIE1.TMR1IE = 0;
	BCF         PIE1+0, 0 
;Pletism�metro.c,374 :: 		CAP.capTest = 1;                     //Medida do periodo completa
	BSF         _CAP+0, 6 
;Pletism�metro.c,375 :: 		CAP.cnt = 0;
	BCF         _CAP+0, 5 
;Pletism�metro.c,376 :: 		}
L_interrupt22:
;Pletism�metro.c,377 :: 		PIR1.CCP1IF = 0;                         //retirar o flag de interrup��o
	BCF         PIR1+0, 2 
;Pletism�metro.c,378 :: 		}
L_interrupt20:
;Pletism�metro.c,379 :: 		if(PIR1.TMR1IF)                           //ocorreu overflow entre a
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt23
;Pletism�metro.c,381 :: 		cntOvrf++;
	INCF        _cntOvrf+0, 1 
;Pletism�metro.c,382 :: 		PIR1.TMR1IF = 0;                        //retirar o flag de interrup��o
	BCF         PIR1+0, 0 
;Pletism�metro.c,384 :: 		}
L_interrupt23:
;Pletism�metro.c,386 :: 		}
L__interrupt51:
	RETFIE      1
; end of _interrupt

_main:
;Pletism�metro.c,392 :: 		void main()
;Pletism�metro.c,395 :: 		InitMain();
	CALL        _InitMain+0, 0
;Pletism�metro.c,396 :: 		CAP.mode = 0x00;
	MOVLW       248
	ANDWF       _CAP+0, 1 
;Pletism�metro.c,397 :: 		LCD_Out(1,1,&cap_msg);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _cap_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_cap_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,398 :: 		clk = Clock_Khz();
	MOVLW       128
	MOVWF       _clk+0 
;Pletism�metro.c,399 :: 		for(;;)
L_main24:
;Pletism�metro.c,401 :: 		switch (CAP.mode) //Loop principal das fun��es
	GOTO        L_main27
;Pletism�metro.c,404 :: 		case 0: Capacitancia = GetCap(Capacitancia);
L_main29:
	MOVF        _Capacitancia+0, 0 
	MOVWF       FARG_GetCap_last_Cap+0 
	MOVF        _Capacitancia+1, 0 
	MOVWF       FARG_GetCap_last_Cap+1 
	MOVLW       0
	BTFSC       _Capacitancia+1, 7 
	MOVLW       255
	MOVWF       FARG_GetCap_last_Cap+2 
	MOVWF       FARG_GetCap_last_Cap+3 
	CALL        _GetCap+0, 0
	MOVF        R0, 0 
	MOVWF       _Capacitancia+0 
	MOVF        R1, 0 
	MOVWF       _Capacitancia+1 
;Pletism�metro.c,406 :: 		IntToStr(Capacitancia, &tnum);
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _tnum+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_tnum+0
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;Pletism�metro.c,407 :: 		ByteToStr(High_B2,&byteHigh);
	MOVF        _High_B2+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _byteHigh+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_byteHigh+0
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;Pletism�metro.c,408 :: 		ByteToStr(Low_B2,&byteLow);
	MOVF        _Low_B2+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _byteLow+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_byteLow+0
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;Pletism�metro.c,409 :: 		LCD_Out(1,5,&tnum);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _tnum+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_tnum+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,410 :: 		LCD_Out(2,3,&byteHigh);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _byteHigh+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_byteHigh+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,411 :: 		LCD_Out(2,11,&byteLow);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _byteLow+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_byteLow+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,413 :: 		break;
	GOTO        L_main28
;Pletism�metro.c,416 :: 		case 1: //LedLcd = 0;
L_main30:
;Pletism�metro.c,417 :: 		break;
	GOTO        L_main28
;Pletism�metro.c,420 :: 		case 2: //LedLcd = 1;
L_main31:
;Pletism�metro.c,421 :: 		break;
	GOTO        L_main28
;Pletism�metro.c,424 :: 		case 3:
L_main32:
;Pletism�metro.c,425 :: 		break;
	GOTO        L_main28
;Pletism�metro.c,428 :: 		case 4:
L_main33:
;Pletism�metro.c,429 :: 		break;
	GOTO        L_main28
;Pletism�metro.c,432 :: 		}
L_main27:
	MOVLW       7
	ANDWF       _CAP+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main29
	MOVLW       7
	ANDWF       _CAP+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main30
	MOVLW       7
	ANDWF       _CAP+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_main31
	MOVLW       7
	ANDWF       _CAP+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_main32
	MOVLW       7
	ANDWF       _CAP+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_main33
L_main28:
;Pletism�metro.c,434 :: 		botaoPress = KeyScan();
	CALL        _KeyScan+0, 0
	MOVF        R0, 0 
	MOVWF       _botaoPress+0 
;Pletism�metro.c,436 :: 		switch(botaoPress)
	GOTO        L_main34
;Pletism�metro.c,438 :: 		case 1: LCD_Cmd(_LCD_CLEAR);
L_main36:
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Pletism�metro.c,439 :: 		CAP.mode++;          //Proximo modo
	MOVLW       7
	ANDWF       _CAP+0, 0 
	MOVWF       R0 
	INCF        R0, 1 
	MOVF        _CAP+0, 0 
	XORWF       R0, 1 
	MOVLW       7
	ANDWF       R0, 1 
	MOVF        _CAP+0, 0 
	XORWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       _CAP+0 
;Pletism�metro.c,440 :: 		switch (CAP.mode)
	GOTO        L_main37
;Pletism�metro.c,443 :: 		case 0: LCD_Out(1,1,&cap_msg);
L_main39:
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _cap_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_cap_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,445 :: 		break;
	GOTO        L_main38
;Pletism�metro.c,448 :: 		case 1: LCD_Out(1,1,&data_msg);
L_main40:
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _data_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_data_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,449 :: 		ShortToStr(clk,&clk_msg);
	MOVF        _clk+0, 0 
	MOVWF       FARG_ShortToStr_input+0 
	MOVLW       _clk_msg+0
	MOVWF       FARG_ShortToStr_output+0 
	MOVLW       hi_addr(_clk_msg+0
	MOVWF       FARG_ShortToStr_output+1 
	CALL        _ShortToStr+0, 0
;Pletism�metro.c,450 :: 		LCD_Out(2,1,&clk_msg);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _clk_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_clk_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,453 :: 		break;
	GOTO        L_main38
;Pletism�metro.c,456 :: 		case 2: LCD_Out(1,1,&vol_msg);
L_main41:
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _vol_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_vol_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,457 :: 		LCD_Out(2,3,&hora_msg);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _hora_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_hora_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,459 :: 		break;
	GOTO        L_main38
;Pletism�metro.c,462 :: 		case 3: LCD_Out(1,1,&vol_msg);
L_main42:
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _vol_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_vol_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,463 :: 		LCD_Out(2,3,&hora_msg);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _hora_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_hora_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,464 :: 		break;
	GOTO        L_main38
;Pletism�metro.c,467 :: 		case 4: LCD_Out(1,1,&comm_msg);
L_main43:
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _comm_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_comm_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,468 :: 		LCD_Out(2,1,&sendDado_msg);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _sendDado_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_sendDado_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,470 :: 		break;
	GOTO        L_main38
;Pletism�metro.c,473 :: 		case 5: CAP.mode = 0; //Voltar ao primeiro
L_main44:
	MOVLW       248
	ANDWF       _CAP+0, 1 
;Pletism�metro.c,474 :: 		LCD_Out(1,1,&cap_msg);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _cap_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_cap_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,475 :: 		LCD_Out(2,1,"H:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_Pletism�metro+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_Pletism�metro+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,476 :: 		LCD_Out(2,9,"L:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       9
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_Pletism�metro+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_Pletism�metro+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletism�metro.c,477 :: 		break;
	GOTO        L_main38
;Pletism�metro.c,478 :: 		}
L_main37:
	MOVLW       7
	ANDWF       _CAP+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main39
	MOVLW       7
	ANDWF       _CAP+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main40
	MOVLW       7
	ANDWF       _CAP+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_main41
	MOVLW       7
	ANDWF       _CAP+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_main42
	MOVLW       7
	ANDWF       _CAP+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_main43
	MOVLW       7
	ANDWF       _CAP+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_main44
L_main38:
;Pletism�metro.c,479 :: 		break;
	GOTO        L_main35
;Pletism�metro.c,481 :: 		case 2: LedLcd = 0;
L_main45:
	BCF         PORTB+0, 3 
;Pletism�metro.c,482 :: 		break;
	GOTO        L_main35
;Pletism�metro.c,484 :: 		case 3: OnLed = 0;
L_main46:
	BCF         PORTB+0, 2 
;Pletism�metro.c,485 :: 		break;
	GOTO        L_main35
;Pletism�metro.c,486 :: 		}
L_main34:
	MOVF        _botaoPress+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main36
	MOVF        _botaoPress+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_main45
	MOVF        _botaoPress+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_main46
L_main35:
;Pletism�metro.c,487 :: 		}
	GOTO        L_main24
;Pletism�metro.c,488 :: 		}
	GOTO        $+0
; end of _main
