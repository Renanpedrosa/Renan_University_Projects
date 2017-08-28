
_GetCap:
;Pletismômetro.c,215 :: 		int GetCap(long last_Cap)
;Pletismômetro.c,217 :: 		if(CAP.capInit == 0)
	BTFSC       _CAP+0, 3 
	GOTO        L_GetCap0
;Pletismômetro.c,220 :: 		PIR1.CCP1IF = 0;            //limpar interrupt flag do capture CCP1
	BCF         PIR1+0, 2 
;Pletismômetro.c,221 :: 		PIR1.TMR1IF = 0;            // ||        ||     ||  || timer1
	BCF         PIR1+0, 0 
;Pletismômetro.c,223 :: 		cntOvrf = 0;               //Resetar contagem de overflow
	CLRF        _cntOvrf+0 
;Pletismômetro.c,224 :: 		CAP.cnt = 0;               //Resetar para a primeira borda
	BCF         _CAP+0, 5 
;Pletismômetro.c,225 :: 		CAP.capTest = 0;           //Resetar indicador de medida completa
	BCF         _CAP+0, 6 
;Pletismômetro.c,227 :: 		TMR1H = 0;
	CLRF        TMR1H+0 
;Pletismômetro.c,228 :: 		TMR1L = 0;
	CLRF        TMR1L+0 
;Pletismômetro.c,229 :: 		T1CON = 0x00;               //Iniciar Timer 1 1/4 desligado
	CLRF        T1CON+0 
;Pletismômetro.c,230 :: 		PIE1.CCP1IE = 1;            // setar interrupção do capture CCP1
	BSF         PIE1+0, 2 
;Pletismômetro.c,231 :: 		PIE1.TMR1IE = 1;            // enable Timer1 interrupt
	BSF         PIE1+0, 0 
;Pletismômetro.c,233 :: 		CAP.capInit = 1;
	BSF         _CAP+0, 3 
;Pletismômetro.c,235 :: 		return last_Cap;
	MOVF        FARG_GetCap_last_Cap+0, 0 
	MOVWF       R0 
	MOVF        FARG_GetCap_last_Cap+1, 0 
	MOVWF       R1 
	RETURN      0
;Pletismômetro.c,236 :: 		}
L_GetCap0:
;Pletismômetro.c,237 :: 		if(CAP.capTest==1)        //Se ocorreu a contagem ,
	BTFSS       _CAP+0, 6 
	GOTO        L_GetCap1
;Pletismômetro.c,239 :: 		CAP.capInit = 0;
	BCF         _CAP+0, 3 
;Pletismômetro.c,241 :: 		Hi(cntCap2) = High_B2;               //Somar o byte superior com o byte
	MOVF        _High_B2+0, 0 
	MOVWF       _cntCap2+1 
;Pletismômetro.c,242 :: 		Lo(cntCap2) = Low_B2;
	MOVF        _Low_B2+0, 0 
	MOVWF       _cntCap2+0 
;Pletismômetro.c,246 :: 		OnLed = 1;
	BSF         PORTB+0, 2 
;Pletismômetro.c,247 :: 		return cntCap2;   //Periodo em microsegundos
	MOVF        _cntCap2+0, 0 
	MOVWF       R0 
	MOVF        _cntCap2+1, 0 
	MOVWF       R1 
	RETURN      0
;Pletismômetro.c,248 :: 		}
L_GetCap1:
;Pletismômetro.c,251 :: 		return last_Cap;
	MOVF        FARG_GetCap_last_Cap+0, 0 
	MOVWF       R0 
	MOVF        FARG_GetCap_last_Cap+1, 0 
	MOVWF       R1 
;Pletismômetro.c,253 :: 		}
	RETURN      0
; end of _GetCap

_KeyScan:
;Pletismômetro.c,266 :: 		unsigned short int KeyScan()
;Pletismômetro.c,269 :: 		if (Button(&PORTB, 7, 1, 1))                // detect logical one on RB7 pin
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
;Pletismômetro.c,270 :: 		oldstate = 1;
	MOVLW       1
	MOVWF       _oldstate+0 
L_KeyScan3:
;Pletismômetro.c,271 :: 		if (oldstate && Button(&PORTB, 7, 1, 0)) {  // detect one-to-zero transition on RB1 pin
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
;Pletismômetro.c,272 :: 		oldstate = 0;
	CLRF        _oldstate+0 
;Pletismômetro.c,273 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	RETURN      0
;Pletismômetro.c,274 :: 		}
L_KeyScan6:
;Pletismômetro.c,277 :: 		if (Button(&PORTB, 6, 1, 1))                // detect logical one on RB6 pin
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
;Pletismômetro.c,278 :: 		oldstate1 = 1;
	MOVLW       1
	MOVWF       _oldstate1+0 
L_KeyScan7:
;Pletismômetro.c,279 :: 		if (oldstate1 && Button(&PORTB, 6, 1, 0)) {  // detect one-to-zero transition on RB1 pin
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
;Pletismômetro.c,280 :: 		oldstate1 = 0;
	CLRF        _oldstate1+0 
;Pletismômetro.c,281 :: 		return 2;
	MOVLW       2
	MOVWF       R0 
	RETURN      0
;Pletismômetro.c,282 :: 		}
L_KeyScan10:
;Pletismômetro.c,285 :: 		if (Button(&PORTB, 5, 1, 1))                // detect logical one on RB5 pin
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
;Pletismômetro.c,286 :: 		oldstate2 = 1;
	MOVLW       1
	MOVWF       _oldstate2+0 
L_KeyScan11:
;Pletismômetro.c,287 :: 		if (oldstate2 && Button(&PORTB, 5, 1, 0)) {  // detect one-to-zero transition on RB1 pin
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
;Pletismômetro.c,288 :: 		oldstate2 = 0;
	CLRF        _oldstate2+0 
;Pletismômetro.c,289 :: 		return 3;
	MOVLW       3
	MOVWF       R0 
	RETURN      0
;Pletismômetro.c,290 :: 		}
L_KeyScan14:
;Pletismômetro.c,293 :: 		if (Button(&PORTB, 4, 1, 1))                // detect logical one on RB4 pin
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
;Pletismômetro.c,294 :: 		oldstate3 = 1;
	MOVLW       1
	MOVWF       _oldstate3+0 
L_KeyScan15:
;Pletismômetro.c,295 :: 		if (oldstate3 && Button(&PORTB, 4, 1, 0)) {  // detect one-to-zero transition on RB1 pin
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
;Pletismômetro.c,296 :: 		oldstate3 = 0;
	CLRF        _oldstate3+0 
;Pletismômetro.c,297 :: 		return 4;
	MOVLW       4
	MOVWF       R0 
	RETURN      0
;Pletismômetro.c,298 :: 		}
L_KeyScan18:
;Pletismômetro.c,302 :: 		return 0;
	CLRF        R0 
;Pletismômetro.c,304 :: 		}
	RETURN      0
; end of _KeyScan

_InitMain:
;Pletismômetro.c,316 :: 		void InitMain()
;Pletismômetro.c,319 :: 		ADCON1 = 0x0F;          //Todos pinos AN são digitais.
	MOVLW       15
	MOVWF       ADCON1+0 
;Pletismômetro.c,322 :: 		TRISB = 0xF0;           //RB7-RB4 >> Input, RB3-RB0 >> Out
	MOVLW       240
	MOVWF       TRISB+0 
;Pletismômetro.c,324 :: 		LCD_RW = 1;             //Iniciando o LCD no modo Write(projeto ja na placa)
	BSF         RD1_bit+0, 1 
;Pletismômetro.c,325 :: 		LCD_RW_Direction = 0;
	BCF         TRISD1_bit+0, 1 
;Pletismômetro.c,328 :: 		TRISC.F2 = 1;
	BSF         TRISC+0, 2 
;Pletismômetro.c,329 :: 		TMR1H = 0;
	CLRF        TMR1H+0 
;Pletismômetro.c,330 :: 		TMR1L = 0;
	CLRF        TMR1L+0 
;Pletismômetro.c,331 :: 		INTCON = 0;
	CLRF        INTCON+0 
;Pletismômetro.c,332 :: 		PIE1 = 0;
	CLRF        PIE1+0 
;Pletismômetro.c,333 :: 		PIR1 = 0;
	CLRF        PIR1+0 
;Pletismômetro.c,334 :: 		CCP1CON = 5;            //Iniciar CCP1CON em capture a cada rising edge
	MOVLW       5
	MOVWF       CCP1CON+0 
;Pletismômetro.c,335 :: 		T1CON = 0x00;           //Iniciar Timer 1 1/4 desligado
	CLRF        T1CON+0 
;Pletismômetro.c,337 :: 		INTCON = 0xC0;              // Set GIE, PEIE(interrupções globais ja setadas)
	MOVLW       192
	MOVWF       INTCON+0 
;Pletismômetro.c,339 :: 		CAP.capScale = 0;         //Colocar a escala para o periodo real,
	BCF         _CAP+0, 7 
;Pletismômetro.c,341 :: 		CAP.capInit = 0;
	BCF         _CAP+0, 3 
;Pletismômetro.c,342 :: 		cntOvrf = 0;
	CLRF        _cntOvrf+0 
;Pletismômetro.c,343 :: 		OnLed = 0;
	BCF         PORTB+0, 2 
;Pletismômetro.c,344 :: 		Capacitancia = 0;           //Valor inicial a ser mostrado no lcd caso
	CLRF        _Capacitancia+0 
	CLRF        _Capacitancia+1 
;Pletismômetro.c,346 :: 		Lcd_Init();                        // Lcd_Init_EP5, see Autocomplete
	CALL        _Lcd_Init+0, 0
;Pletismômetro.c,347 :: 		LCD_Cmd(_LCD_CURSOR_OFF);                 // send command to LCD (cursor off)
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Pletismômetro.c,348 :: 		LCD_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Pletismômetro.c,350 :: 		}
	RETURN      0
; end of _InitMain

_interrupt:
;Pletismômetro.c,356 :: 		void interrupt()
;Pletismômetro.c,358 :: 		if(PIR1.CCP1IF)            //Ocorreu interrupção do Capture?
	BTFSS       PIR1+0, 2 
	GOTO        L_interrupt20
;Pletismômetro.c,360 :: 		if(CAP.cnt==0)                         //É a primeira borda?
	BTFSC       _CAP+0, 5 
	GOTO        L_interrupt21
;Pletismômetro.c,362 :: 		T1CON.TMR1ON = 1;                      //Ligar Timer1
	BSF         T1CON+0, 0 
;Pletismômetro.c,363 :: 		LedLcd = 1;
	BSF         PORTB+0, 3 
;Pletismômetro.c,364 :: 		cntOvrf = 0;
	CLRF        _cntOvrf+0 
;Pletismômetro.c,365 :: 		CAP.cnt = 1;                         //Proxima borda de subida
	BSF         _CAP+0, 5 
;Pletismômetro.c,366 :: 		}
	GOTO        L_interrupt22
L_interrupt21:
;Pletismômetro.c,369 :: 		High_B2 = CCPR1H;                     //Passando os valores do timer1
	MOVF        CCPR1H+0, 0 
	MOVWF       _High_B2+0 
;Pletismômetro.c,370 :: 		Low_B2 = CCPR1L;
	MOVF        CCPR1L+0, 0 
	MOVWF       _Low_B2+0 
;Pletismômetro.c,371 :: 		T1CON.TMR1ON = 0;
	BCF         T1CON+0, 0 
;Pletismômetro.c,372 :: 		PIE1.CCP1IE = 0;
	BCF         PIE1+0, 2 
;Pletismômetro.c,373 :: 		PIE1.TMR1IE = 0;
	BCF         PIE1+0, 0 
;Pletismômetro.c,374 :: 		CAP.capTest = 1;                     //Medida do periodo completa
	BSF         _CAP+0, 6 
;Pletismômetro.c,375 :: 		CAP.cnt = 0;
	BCF         _CAP+0, 5 
;Pletismômetro.c,376 :: 		}
L_interrupt22:
;Pletismômetro.c,377 :: 		PIR1.CCP1IF = 0;                         //retirar o flag de interrupção
	BCF         PIR1+0, 2 
;Pletismômetro.c,378 :: 		}
L_interrupt20:
;Pletismômetro.c,379 :: 		if(PIR1.TMR1IF)                           //ocorreu overflow entre a
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt23
;Pletismômetro.c,381 :: 		cntOvrf++;
	INCF        _cntOvrf+0, 1 
;Pletismômetro.c,382 :: 		PIR1.TMR1IF = 0;                        //retirar o flag de interrupção
	BCF         PIR1+0, 0 
;Pletismômetro.c,384 :: 		}
L_interrupt23:
;Pletismômetro.c,386 :: 		}
L__interrupt51:
	RETFIE      1
; end of _interrupt

_main:
;Pletismômetro.c,392 :: 		void main()
;Pletismômetro.c,395 :: 		InitMain();
	CALL        _InitMain+0, 0
;Pletismômetro.c,396 :: 		CAP.mode = 0x00;
	MOVLW       248
	ANDWF       _CAP+0, 1 
;Pletismômetro.c,397 :: 		LCD_Out(1,1,&cap_msg);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _cap_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_cap_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletismômetro.c,398 :: 		clk = Clock_Khz();
	MOVLW       128
	MOVWF       _clk+0 
;Pletismômetro.c,399 :: 		for(;;)
L_main24:
;Pletismômetro.c,401 :: 		switch (CAP.mode) //Loop principal das funções
	GOTO        L_main27
;Pletismômetro.c,404 :: 		case 0: Capacitancia = GetCap(Capacitancia);
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
;Pletismômetro.c,406 :: 		IntToStr(Capacitancia, &tnum);
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _tnum+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_tnum+0
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;Pletismômetro.c,407 :: 		ByteToStr(High_B2,&byteHigh);
	MOVF        _High_B2+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _byteHigh+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_byteHigh+0
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;Pletismômetro.c,408 :: 		ByteToStr(Low_B2,&byteLow);
	MOVF        _Low_B2+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _byteLow+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_byteLow+0
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;Pletismômetro.c,409 :: 		LCD_Out(1,5,&tnum);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _tnum+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_tnum+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletismômetro.c,410 :: 		LCD_Out(2,3,&byteHigh);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _byteHigh+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_byteHigh+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletismômetro.c,411 :: 		LCD_Out(2,11,&byteLow);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _byteLow+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_byteLow+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletismômetro.c,413 :: 		break;
	GOTO        L_main28
;Pletismômetro.c,416 :: 		case 1: //LedLcd = 0;
L_main30:
;Pletismômetro.c,417 :: 		break;
	GOTO        L_main28
;Pletismômetro.c,420 :: 		case 2: //LedLcd = 1;
L_main31:
;Pletismômetro.c,421 :: 		break;
	GOTO        L_main28
;Pletismômetro.c,424 :: 		case 3:
L_main32:
;Pletismômetro.c,425 :: 		break;
	GOTO        L_main28
;Pletismômetro.c,428 :: 		case 4:
L_main33:
;Pletismômetro.c,429 :: 		break;
	GOTO        L_main28
;Pletismômetro.c,432 :: 		}
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
;Pletismômetro.c,434 :: 		botaoPress = KeyScan();
	CALL        _KeyScan+0, 0
	MOVF        R0, 0 
	MOVWF       _botaoPress+0 
;Pletismômetro.c,436 :: 		switch(botaoPress)
	GOTO        L_main34
;Pletismômetro.c,438 :: 		case 1: LCD_Cmd(_LCD_CLEAR);
L_main36:
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Pletismômetro.c,439 :: 		CAP.mode++;          //Proximo modo
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
;Pletismômetro.c,440 :: 		switch (CAP.mode)
	GOTO        L_main37
;Pletismômetro.c,443 :: 		case 0: LCD_Out(1,1,&cap_msg);
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
;Pletismômetro.c,445 :: 		break;
	GOTO        L_main38
;Pletismômetro.c,448 :: 		case 1: LCD_Out(1,1,&data_msg);
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
;Pletismômetro.c,449 :: 		ShortToStr(clk,&clk_msg);
	MOVF        _clk+0, 0 
	MOVWF       FARG_ShortToStr_input+0 
	MOVLW       _clk_msg+0
	MOVWF       FARG_ShortToStr_output+0 
	MOVLW       hi_addr(_clk_msg+0
	MOVWF       FARG_ShortToStr_output+1 
	CALL        _ShortToStr+0, 0
;Pletismômetro.c,450 :: 		LCD_Out(2,1,&clk_msg);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _clk_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_clk_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletismômetro.c,453 :: 		break;
	GOTO        L_main38
;Pletismômetro.c,456 :: 		case 2: LCD_Out(1,1,&vol_msg);
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
;Pletismômetro.c,457 :: 		LCD_Out(2,3,&hora_msg);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _hora_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_hora_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletismômetro.c,459 :: 		break;
	GOTO        L_main38
;Pletismômetro.c,462 :: 		case 3: LCD_Out(1,1,&vol_msg);
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
;Pletismômetro.c,463 :: 		LCD_Out(2,3,&hora_msg);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _hora_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_hora_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletismômetro.c,464 :: 		break;
	GOTO        L_main38
;Pletismômetro.c,467 :: 		case 4: LCD_Out(1,1,&comm_msg);
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
;Pletismômetro.c,468 :: 		LCD_Out(2,1,&sendDado_msg);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _sendDado_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_sendDado_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletismômetro.c,470 :: 		break;
	GOTO        L_main38
;Pletismômetro.c,473 :: 		case 5: CAP.mode = 0; //Voltar ao primeiro
L_main44:
	MOVLW       248
	ANDWF       _CAP+0, 1 
;Pletismômetro.c,474 :: 		LCD_Out(1,1,&cap_msg);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _cap_msg+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_cap_msg+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletismômetro.c,475 :: 		LCD_Out(2,1,"H:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_Pletismômetro+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_Pletismômetro+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletismômetro.c,476 :: 		LCD_Out(2,9,"L:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       9
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_Pletismômetro+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_Pletismômetro+0
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pletismômetro.c,477 :: 		break;
	GOTO        L_main38
;Pletismômetro.c,478 :: 		}
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
;Pletismômetro.c,479 :: 		break;
	GOTO        L_main35
;Pletismômetro.c,481 :: 		case 2: LedLcd = 0;
L_main45:
	BCF         PORTB+0, 3 
;Pletismômetro.c,482 :: 		break;
	GOTO        L_main35
;Pletismômetro.c,484 :: 		case 3: OnLed = 0;
L_main46:
	BCF         PORTB+0, 2 
;Pletismômetro.c,485 :: 		break;
	GOTO        L_main35
;Pletismômetro.c,486 :: 		}
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
;Pletismômetro.c,487 :: 		}
	GOTO        L_main24
;Pletismômetro.c,488 :: 		}
	GOTO        $+0
; end of _main
