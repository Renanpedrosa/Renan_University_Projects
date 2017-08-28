
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0
;Dimmer e Sensor.c,46 :: 		void interrupt() {
;Dimmer e Sensor.c,47 :: 		if (TMR1IF_bit) {
	BTFSS      TMR1IF_bit+0, 0
	GOTO       L_interrupt0
;Dimmer e Sensor.c,48 :: 		read_err = 1;
	BSF        _read_err+0, BitPos(_read_err+0)
;Dimmer e Sensor.c,49 :: 		}
L_interrupt0:
;Dimmer e Sensor.c,50 :: 		}
L__interrupt113:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:
;Dimmer e Sensor.c,52 :: 		void main()
;Dimmer e Sensor.c,54 :: 		OPTION_REG = 0x85;   //1:64 tmr0 prescaler, pullups disabled
	MOVLW      133
	MOVWF      OPTION_REG+0
;Dimmer e Sensor.c,55 :: 		PORTA = 0;
	CLRF       PORTA+0
;Dimmer e Sensor.c,56 :: 		PORTB = 0;
	CLRF       PORTB+0
;Dimmer e Sensor.c,57 :: 		PORTC = 0;
	CLRF       PORTC+0
;Dimmer e Sensor.c,58 :: 		ADCON1 = 0x83;       //RA0:RA3 são AN0:3 , RA3=Vref+, RA5 = AN4
	MOVLW      131
	MOVWF      ADCON1+0
;Dimmer e Sensor.c,59 :: 		TRISA = 0xFF;        //PORTA é entrada
	MOVLW      255
	MOVWF      TRISA+0
;Dimmer e Sensor.c,60 :: 		TRISB = 0xFF;        //PORTB é saída
	MOVLW      255
	MOVWF      TRISB+0
;Dimmer e Sensor.c,61 :: 		TRISC = 0x30;        //Apenas RC5 é entrada,
	MOVLW      48
	MOVWF      TRISC+0
;Dimmer e Sensor.c,64 :: 		T1CON = 0x31;               // Timer1 settings (1:8) + T1ON
	MOVLW      49
	MOVWF      T1CON+0
;Dimmer e Sensor.c,65 :: 		TMR1IF_bit = 0;             // clear TMR1IF
	BCF        TMR1IF_bit+0, 0
;Dimmer e Sensor.c,66 :: 		TMR1H = 0x80;               // Initialize Timer1 register
	MOVLW      128
	MOVWF      TMR1H+0
;Dimmer e Sensor.c,67 :: 		TMR1L = 0x00;               // to interrupt every 4ms
	CLRF       TMR1L+0
;Dimmer e Sensor.c,68 :: 		TMR1IE_bit = 1;             // enable Timer1 Interrupt
	BSF        TMR1IE_bit+0, 0
;Dimmer e Sensor.c,71 :: 		set_point = 600;  //Começar com um valor de controle
	MOVLW      88
	MOVWF      _set_point+0
	MOVLW      2
	MOVWF      _set_point+1
;Dimmer e Sensor.c,72 :: 		PercentOn = 0xD0; //On Period
	MOVLW      208
	MOVWF      _PercentOn+0
	CLRF       _PercentOn+1
;Dimmer e Sensor.c,73 :: 		Maxdim = 0x70; //Value of Maximum dimming
	MOVLW      112
	MOVWF      _Maxdim+0
	MOVLW      0
	MOVWF      _Maxdim+1
;Dimmer e Sensor.c,74 :: 		TestCheck = 0; //Test mode check counter
	CLRF       _TestCheck+0
	CLRF       _TestCheck+1
;Dimmer e Sensor.c,75 :: 		Outcount = 0; //Counter for test mode exit
	CLRF       _Outcount+0
	CLRF       _Outcount+1
;Dimmer e Sensor.c,76 :: 		TestCount = 0; //Test mode counter
	CLRF       _TestCount+0
	CLRF       _TestCount+1
;Dimmer e Sensor.c,77 :: 		DelayCnt = NotInTest; //Delay count
	MOVLW      3
	MOVWF      _DelayCnt+0
	MOVLW      0
	MOVWF      _DelayCnt+1
;Dimmer e Sensor.c,78 :: 		LastBoth = 0; //Both buttons pressed last time flag
	CLRF       _LastBoth+0
	CLRF       _LastBoth+1
;Dimmer e Sensor.c,79 :: 		FirstPass = 1; //Indicate power-up
	MOVLW      1
	MOVWF      _FirstPass+0
	MOVLW      0
	MOVWF      _FirstPass+1
;Dimmer e Sensor.c,80 :: 		Count = 0; //General counter
	CLRF       _Count+0
	CLRF       _Count+1
;Dimmer e Sensor.c,82 :: 		kp = 3;
	MOVLW      3
	MOVWF      _kp+0
	MOVLW      0
	MOVWF      _kp+1
;Dimmer e Sensor.c,83 :: 		ki = 5;
	MOVLW      5
	MOVWF      _ki+0
	MOVLW      0
	MOVWF      _ki+1
;Dimmer e Sensor.c,84 :: 		en3 = en2 = en1 = en0 = 0;
	CLRF       _en0+0
	CLRF       _en0+1
	CLRF       _en1+0
	CLRF       _en1+1
	CLRF       _en2+0
	CLRF       _en2+1
	CLRF       _en3+0
	CLRF       _en3+1
;Dimmer e Sensor.c,85 :: 		RC0_bit = 1;
	BSF        RC0_bit+0, 0
;Dimmer e Sensor.c,87 :: 		for(Count = 0; Count < 60; Count++) //Allow power supply to stabilize
	CLRF       _Count+0
	CLRF       _Count+1
L_main1:
	MOVLW      0
	SUBWF      _Count+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main114
	MOVLW      60
	SUBWF      _Count+0, 0
L__main114:
	BTFSC      STATUS+0, 0
	GOTO       L_main2
;Dimmer e Sensor.c,89 :: 		while(LineInput == 1);
L_main4:
	BTFSS      PORTB+0, 0
	GOTO       L_main5
	GOTO       L_main4
L_main5:
;Dimmer e Sensor.c,90 :: 		while(LineInput == 0);
L_main6:
	BTFSC      PORTB+0, 0
	GOTO       L_main7
	GOTO       L_main6
L_main7:
;Dimmer e Sensor.c,91 :: 		asm{CLRWDT};
	CLRWDT
;Dimmer e Sensor.c,87 :: 		for(Count = 0; Count < 60; Count++) //Allow power supply to stabilize
	INCF       _Count+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Count+1, 1
;Dimmer e Sensor.c,92 :: 		}
	GOTO       L_main1
L_main2:
;Dimmer e Sensor.c,95 :: 		while(LineInput == 1) //Synch to line phase
L_main8:
	BTFSS      PORTB+0, 0
	GOTO       L_main9
;Dimmer e Sensor.c,96 :: 		asm{CLRWDT};
	CLRWDT
	GOTO       L_main8
L_main9:
;Dimmer e Sensor.c,97 :: 		TMR0 = PercentOn; //Get Delay time
	MOVF       _PercentOn+0, 0
	MOVWF      TMR0+0
;Dimmer e Sensor.c,98 :: 		while(TMR0 >= 3 && LineInput == 0) //Delay to enter main at proper point
L_main10:
	MOVLW      3
	SUBWF      TMR0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main11
	BTFSC      PORTB+0, 0
	GOTO       L_main11
L__main105:
;Dimmer e Sensor.c,99 :: 		asm{CLRWDT};
	CLRWDT
	GOTO       L_main10
L_main11:
;Dimmer e Sensor.c,100 :: 		RC1_bit = 1;
	BSF        RC1_bit+0, 1
;Dimmer e Sensor.c,101 :: 		INTCON = 0xC0;              // Set GIE, PEIE
	MOVLW      192
	MOVWF      INTCON+0
;Dimmer e Sensor.c,103 :: 		while(1) //Stay in this loop
L_main14:
;Dimmer e Sensor.c,105 :: 		Count = 0;
	CLRF       _Count+0
	CLRF       _Count+1
;Dimmer e Sensor.c,106 :: 		while (Count++ < DelayCnt) //Check for button press every
L_main16:
	MOVF       _Count+0, 0
	MOVWF      R1+0
	MOVF       _Count+1, 0
	MOVWF      R1+1
	INCF       _Count+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Count+1, 1
	MOVF       _DelayCnt+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main115
	MOVF       _DelayCnt+0, 0
	SUBWF      R1+0, 0
L__main115:
	BTFSC      STATUS+0, 0
	GOTO       L_main17
;Dimmer e Sensor.c,109 :: 		if(LineInput == 1) //Check for AC line already high
	BTFSS      PORTB+0, 0
	GOTO       L_main18
;Dimmer e Sensor.c,111 :: 		Maxdim += 5; //If so, increment Maxdim
	MOVLW      5
	ADDWF      _Maxdim+0, 1
	BTFSC      STATUS+0, 0
	INCF       _Maxdim+1, 1
;Dimmer e Sensor.c,112 :: 		while(LineInput == 1); // and re-sync with line
L_main19:
	BTFSS      PORTB+0, 0
	GOTO       L_main20
	GOTO       L_main19
L_main20:
;Dimmer e Sensor.c,113 :: 		while(LineInput == 0)
L_main21:
	BTFSC      PORTB+0, 0
	GOTO       L_main22
;Dimmer e Sensor.c,114 :: 		asm{CLRWDT};
	CLRWDT
	GOTO       L_main21
L_main22:
;Dimmer e Sensor.c,115 :: 		}
	GOTO       L_main23
L_main18:
;Dimmer e Sensor.c,118 :: 		while(LineInput == 0) //Wait for zero crossing
L_main24:
	BTFSC      PORTB+0, 0
	GOTO       L_main25
;Dimmer e Sensor.c,119 :: 		asm{CLRWDT};
	CLRWDT
	GOTO       L_main24
L_main25:
;Dimmer e Sensor.c,120 :: 		Maxdim = PercentOn - TMR0 + 2; //Compensate full dim value for line
	MOVF       TMR0+0, 0
	SUBWF      _PercentOn+0, 0
	MOVWF      _Maxdim+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _PercentOn+1, 0
	MOVWF      _Maxdim+1
	MOVLW      2
	ADDWF      _Maxdim+0, 1
	BTFSC      STATUS+0, 0
	INCF       _Maxdim+1, 1
;Dimmer e Sensor.c,122 :: 		}
L_main23:
;Dimmer e Sensor.c,123 :: 		if(FirstPass == 1) //If first pass, go to full dim
	MOVLW      0
	XORWF      _FirstPass+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main116
	MOVLW      1
	XORWF      _FirstPass+0, 0
L__main116:
	BTFSS      STATUS+0, 2
	GOTO       L_main26
;Dimmer e Sensor.c,125 :: 		FirstPass = 0;
	CLRF       _FirstPass+0
	CLRF       _FirstPass+1
;Dimmer e Sensor.c,126 :: 		PercentOn = Maxdim;
	MOVF       _Maxdim+0, 0
	MOVWF      _PercentOn+0
	MOVF       _Maxdim+1, 0
	MOVWF      _PercentOn+1
;Dimmer e Sensor.c,127 :: 		}
L_main26:
;Dimmer e Sensor.c,128 :: 		if(PercentOn < Maxdim) //If maxdim moved, fix brightness
	MOVF       _Maxdim+1, 0
	SUBWF      _PercentOn+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main117
	MOVF       _Maxdim+0, 0
	SUBWF      _PercentOn+0, 0
L__main117:
	BTFSC      STATUS+0, 0
	GOTO       L_main27
;Dimmer e Sensor.c,129 :: 		PercentOn = Maxdim;
	MOVF       _Maxdim+0, 0
	MOVWF      _PercentOn+0
	MOVF       _Maxdim+1, 0
	MOVWF      _PercentOn+1
L_main27:
;Dimmer e Sensor.c,130 :: 		TMR0 = PercentOn; //Get delay time
	MOVF       _PercentOn+0, 0
	MOVWF      TMR0+0
;Dimmer e Sensor.c,131 :: 		while(TMR0 >= 3 && LineInput == 1) //Delay TRIAC turn on (wait for Counter rollover)
L_main28:
	MOVLW      3
	SUBWF      TMR0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main29
	BTFSS      PORTB+0, 0
	GOTO       L_main29
L__main104:
;Dimmer e Sensor.c,132 :: 		asm{CLRWDT};
	CLRWDT
	GOTO       L_main28
L_main29:
;Dimmer e Sensor.c,134 :: 		Output = 1; //Fire TRIAC
	BSF        PORTC+0, 6
;Dimmer e Sensor.c,135 :: 		asm{NOP}; //Delay for TRIAC fire pulse
	NOP
;Dimmer e Sensor.c,136 :: 		asm{NOP};
	NOP
;Dimmer e Sensor.c,137 :: 		asm{NOP};
	NOP
;Dimmer e Sensor.c,138 :: 		asm{NOP};
	NOP
;Dimmer e Sensor.c,139 :: 		asm{NOP};
	NOP
;Dimmer e Sensor.c,140 :: 		asm{NOP};
	NOP
;Dimmer e Sensor.c,141 :: 		asm{NOP};
	NOP
;Dimmer e Sensor.c,142 :: 		Output = 0; //Release TRIAC fire Signal
	BCF        PORTC+0, 6
;Dimmer e Sensor.c,143 :: 		asm{CLRWDT};
	CLRWDT
;Dimmer e Sensor.c,144 :: 		RC2_bit = 1;
	BSF        RC2_bit+0, 2
;Dimmer e Sensor.c,145 :: 		if(LineInput == 0) //Check for AC line already low
	BTFSC      PORTB+0, 0
	GOTO       L_main32
;Dimmer e Sensor.c,147 :: 		Maxdim += 5; //If so, increment Maxdim
	MOVLW      5
	ADDWF      _Maxdim+0, 1
	BTFSC      STATUS+0, 0
	INCF       _Maxdim+1, 1
;Dimmer e Sensor.c,148 :: 		while(LineInput == 0); // and re-sync with line
L_main33:
	BTFSC      PORTB+0, 0
	GOTO       L_main34
	GOTO       L_main33
L_main34:
;Dimmer e Sensor.c,149 :: 		while(LineInput == 1)
L_main35:
	BTFSS      PORTB+0, 0
	GOTO       L_main36
;Dimmer e Sensor.c,150 :: 		asm{CLRWDT};
	CLRWDT
	GOTO       L_main35
L_main36:
;Dimmer e Sensor.c,151 :: 		}
	GOTO       L_main37
L_main32:
;Dimmer e Sensor.c,154 :: 		while(LineInput==1) //Wait for zero crossing
L_main38:
	BTFSS      PORTB+0, 0
	GOTO       L_main39
;Dimmer e Sensor.c,155 :: 		asm{CLRWDT};
	CLRWDT
	GOTO       L_main38
L_main39:
;Dimmer e Sensor.c,156 :: 		Maxdim = PercentOn - TMR0 + 2; //Compensate full dim value for line
	MOVF       TMR0+0, 0
	SUBWF      _PercentOn+0, 0
	MOVWF      _Maxdim+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _PercentOn+1, 0
	MOVWF      _Maxdim+1
	MOVLW      2
	ADDWF      _Maxdim+0, 1
	BTFSC      STATUS+0, 0
	INCF       _Maxdim+1, 1
;Dimmer e Sensor.c,158 :: 		}
L_main37:
;Dimmer e Sensor.c,159 :: 		if(PercentOn < Maxdim) //If maxdim moved, fix brightness
	MOVF       _Maxdim+1, 0
	SUBWF      _PercentOn+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main118
	MOVF       _Maxdim+0, 0
	SUBWF      _PercentOn+0, 0
L__main118:
	BTFSC      STATUS+0, 0
	GOTO       L_main40
;Dimmer e Sensor.c,160 :: 		PercentOn = Maxdim;
	MOVF       _Maxdim+0, 0
	MOVWF      _PercentOn+0
	MOVF       _Maxdim+1, 0
	MOVWF      _PercentOn+1
L_main40:
;Dimmer e Sensor.c,161 :: 		TMR0 = PercentOn; //Get Delay time
	MOVF       _PercentOn+0, 0
	MOVWF      TMR0+0
;Dimmer e Sensor.c,162 :: 		while(TMR0 >= 3 && LineInput == 0) //Delay TRIAC turn on
L_main41:
	MOVLW      3
	SUBWF      TMR0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main42
	BTFSC      PORTB+0, 0
	GOTO       L_main42
L__main103:
;Dimmer e Sensor.c,163 :: 		asm{CLRWDT};
	CLRWDT
	GOTO       L_main41
L_main42:
;Dimmer e Sensor.c,164 :: 		Output = 1; //Fire TRIAC
	BSF        PORTC+0, 6
;Dimmer e Sensor.c,165 :: 		asm{NOP}; //Delay for TRIAC fire pulse
	NOP
;Dimmer e Sensor.c,166 :: 		asm{NOP};
	NOP
;Dimmer e Sensor.c,167 :: 		asm{NOP};
	NOP
;Dimmer e Sensor.c,168 :: 		asm{NOP};
	NOP
;Dimmer e Sensor.c,169 :: 		asm{NOP};
	NOP
;Dimmer e Sensor.c,170 :: 		asm{NOP};
	NOP
;Dimmer e Sensor.c,171 :: 		asm{NOP};
	NOP
;Dimmer e Sensor.c,172 :: 		Output = 0;    //Release TRIAC fire signal
	BCF        PORTC+0, 6
;Dimmer e Sensor.c,173 :: 		asm{CLRWDT};
	CLRWDT
;Dimmer e Sensor.c,174 :: 		}
	GOTO       L_main16
L_main17:
;Dimmer e Sensor.c,176 :: 		sensor_out = ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _sensor_out+0
	MOVF       R0+1, 0
	MOVWF      _sensor_out+1
;Dimmer e Sensor.c,178 :: 		auto_normal = ADC_Read(4);
	MOVLW      4
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _auto_normal+0
	MOVF       R0+1, 0
	MOVWF      _auto_normal+1
;Dimmer e Sensor.c,179 :: 		if(auto_normal >= 500)
	MOVLW      1
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main119
	MOVLW      244
	SUBWF      R0+0, 0
L__main119:
	BTFSS      STATUS+0, 0
	GOTO       L_main45
;Dimmer e Sensor.c,180 :: 		sw_auto = 1;
	BSF        _sw_auto+0, BitPos(_sw_auto+0)
	GOTO       L_main46
L_main45:
;Dimmer e Sensor.c,182 :: 		sw_auto = 0;
	BCF        _sw_auto+0, BitPos(_sw_auto+0)
L_main46:
;Dimmer e Sensor.c,184 :: 		Buttoncheck(); //Check for button press
	CALL       _Buttoncheck+0
;Dimmer e Sensor.c,185 :: 		asm{CLRWDT};
	CLRWDT
;Dimmer e Sensor.c,186 :: 		RC3_bit = 1;
	BSF        RC3_bit+0, 3
;Dimmer e Sensor.c,187 :: 		}
	GOTO       L_main14
;Dimmer e Sensor.c,188 :: 		}
	GOTO       $+0
; end of _main

_Buttoncheck:
;Dimmer e Sensor.c,206 :: 		void Buttoncheck()
;Dimmer e Sensor.c,208 :: 		asm{NOP}; //Bugfix for MPLABC V1.10
	NOP
;Dimmer e Sensor.c,209 :: 		if(TestCheck == 3) //Check test mode flag
	MOVLW      0
	XORWF      _TestCheck+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck120
	MOVLW      3
	XORWF      _TestCheck+0, 0
L__Buttoncheck120:
	BTFSS      STATUS+0, 2
	GOTO       L_Buttoncheck47
;Dimmer e Sensor.c,211 :: 		DelayCnt = 2; //Reset the delay count
	MOVLW      2
	MOVWF      _DelayCnt+0
	MOVLW      0
	MOVWF      _DelayCnt+1
;Dimmer e Sensor.c,212 :: 		if(Brtbut && !Dimbut) //If Dimbutton pressed, exit test mode
	BTFSS      PORTA+0, 4
	GOTO       L_Buttoncheck50
	BTFSC      PORTC+0, 4
	GOTO       L_Buttoncheck50
L__Buttoncheck112:
;Dimmer e Sensor.c,214 :: 		TestCheck = 0; //Clear Test mode flag
	CLRF       _TestCheck+0
	CLRF       _TestCheck+1
;Dimmer e Sensor.c,215 :: 		DelayCnt = 5;
	MOVLW      5
	MOVWF      _DelayCnt+0
	MOVLW      0
	MOVWF      _DelayCnt+1
;Dimmer e Sensor.c,216 :: 		return;
	RETURN
;Dimmer e Sensor.c,217 :: 		}
L_Buttoncheck50:
;Dimmer e Sensor.c,218 :: 		if(TestCount == 0) //Ramp up to full dim
	MOVLW      0
	XORWF      _TestCount+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck121
	MOVLW      0
	XORWF      _TestCount+0, 0
L__Buttoncheck121:
	BTFSS      STATUS+0, 2
	GOTO       L_Buttoncheck51
;Dimmer e Sensor.c,220 :: 		if(++PercentOn > Maxbrt) //Check for full bright
	INCF       _PercentOn+0, 1
	BTFSC      STATUS+0, 2
	INCF       _PercentOn+1, 1
	MOVF       _PercentOn+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck122
	MOVF       _PercentOn+0, 0
	SUBLW      253
L__Buttoncheck122:
	BTFSC      STATUS+0, 0
	GOTO       L_Buttoncheck52
;Dimmer e Sensor.c,222 :: 		PercentOn = Maxbrt;
	MOVLW      253
	MOVWF      _PercentOn+0
	MOVLW      0
	MOVWF      _PercentOn+1
;Dimmer e Sensor.c,223 :: 		++TestCount;
	INCF       _TestCount+0, 1
	BTFSC      STATUS+0, 2
	INCF       _TestCount+1, 1
;Dimmer e Sensor.c,224 :: 		return;
	RETURN
;Dimmer e Sensor.c,225 :: 		}
L_Buttoncheck52:
;Dimmer e Sensor.c,227 :: 		return;
	RETURN
;Dimmer e Sensor.c,228 :: 		}
L_Buttoncheck51:
;Dimmer e Sensor.c,229 :: 		if(TestCount == 1) //Ramp down to full dim
	MOVLW      0
	XORWF      _TestCount+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck123
	MOVLW      1
	XORWF      _TestCount+0, 0
L__Buttoncheck123:
	BTFSS      STATUS+0, 2
	GOTO       L_Buttoncheck54
;Dimmer e Sensor.c,231 :: 		if(--PercentOn <= Maxdim) //Check for full dim
	MOVLW      1
	SUBWF      _PercentOn+0, 1
	BTFSS      STATUS+0, 0
	DECF       _PercentOn+1, 1
	MOVF       _PercentOn+1, 0
	SUBWF      _Maxdim+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck124
	MOVF       _PercentOn+0, 0
	SUBWF      _Maxdim+0, 0
L__Buttoncheck124:
	BTFSS      STATUS+0, 0
	GOTO       L_Buttoncheck55
;Dimmer e Sensor.c,233 :: 		PercentOn = Maxbrt;
	MOVLW      253
	MOVWF      _PercentOn+0
	MOVLW      0
	MOVWF      _PercentOn+1
;Dimmer e Sensor.c,234 :: 		++TestCount;
	INCF       _TestCount+0, 1
	BTFSC      STATUS+0, 2
	INCF       _TestCount+1, 1
;Dimmer e Sensor.c,235 :: 		return;
	RETURN
;Dimmer e Sensor.c,236 :: 		}
L_Buttoncheck55:
;Dimmer e Sensor.c,238 :: 		return;
	RETURN
;Dimmer e Sensor.c,239 :: 		}
L_Buttoncheck54:
;Dimmer e Sensor.c,240 :: 		while(TestCount++ < 5) //Delay
	MOVF       _TestCount+0, 0
	MOVWF      R1+0
	MOVF       _TestCount+1, 0
	MOVWF      R1+1
	INCF       _TestCount+0, 1
	BTFSC      STATUS+0, 2
	INCF       _TestCount+1, 1
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck125
	MOVLW      5
	SUBWF      R1+0, 0
L__Buttoncheck125:
	BTFSC      STATUS+0, 0
	GOTO       L_Buttoncheck58
;Dimmer e Sensor.c,241 :: 		return;
	RETURN
L_Buttoncheck58:
;Dimmer e Sensor.c,242 :: 		while(TestCount++ < 10) //Turn off for a short period
	MOVF       _TestCount+0, 0
	MOVWF      R1+0
	MOVF       _TestCount+1, 0
	MOVWF      R1+1
	INCF       _TestCount+0, 1
	BTFSC      STATUS+0, 2
	INCF       _TestCount+1, 1
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck126
	MOVLW      10
	SUBWF      R1+0, 0
L__Buttoncheck126:
	BTFSC      STATUS+0, 0
	GOTO       L_Buttoncheck60
;Dimmer e Sensor.c,244 :: 		PercentOn = Maxdim;
	MOVF       _Maxdim+0, 0
	MOVWF      _PercentOn+0
	MOVF       _Maxdim+1, 0
	MOVWF      _PercentOn+1
;Dimmer e Sensor.c,245 :: 		return;
	RETURN
;Dimmer e Sensor.c,246 :: 		}
L_Buttoncheck60:
;Dimmer e Sensor.c,247 :: 		while(TestCount++ < 15) //Turn On for a short period
	MOVF       _TestCount+0, 0
	MOVWF      R1+0
	MOVF       _TestCount+1, 0
	MOVWF      R1+1
	INCF       _TestCount+0, 1
	BTFSC      STATUS+0, 2
	INCF       _TestCount+1, 1
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck127
	MOVLW      15
	SUBWF      R1+0, 0
L__Buttoncheck127:
	BTFSC      STATUS+0, 0
	GOTO       L_Buttoncheck62
;Dimmer e Sensor.c,249 :: 		PercentOn = Maxbrt;
	MOVLW      253
	MOVWF      _PercentOn+0
	MOVLW      0
	MOVWF      _PercentOn+1
;Dimmer e Sensor.c,250 :: 		return;
	RETURN
;Dimmer e Sensor.c,251 :: 		}
L_Buttoncheck62:
;Dimmer e Sensor.c,252 :: 		while(TestCount++ < 20) //Turn off for a short period
	MOVF       _TestCount+0, 0
	MOVWF      R1+0
	MOVF       _TestCount+1, 0
	MOVWF      R1+1
	INCF       _TestCount+0, 1
	BTFSC      STATUS+0, 2
	INCF       _TestCount+1, 1
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck128
	MOVLW      20
	SUBWF      R1+0, 0
L__Buttoncheck128:
	BTFSC      STATUS+0, 0
	GOTO       L_Buttoncheck64
;Dimmer e Sensor.c,254 :: 		PercentOn = Maxdim;
	MOVF       _Maxdim+0, 0
	MOVWF      _PercentOn+0
	MOVF       _Maxdim+1, 0
	MOVWF      _PercentOn+1
;Dimmer e Sensor.c,255 :: 		return;
	RETURN
;Dimmer e Sensor.c,256 :: 		}
L_Buttoncheck64:
;Dimmer e Sensor.c,257 :: 		while(TestCount++ < 25) //Turn on for a short period
	MOVF       _TestCount+0, 0
	MOVWF      R1+0
	MOVF       _TestCount+1, 0
	MOVWF      R1+1
	INCF       _TestCount+0, 1
	BTFSC      STATUS+0, 2
	INCF       _TestCount+1, 1
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck129
	MOVLW      25
	SUBWF      R1+0, 0
L__Buttoncheck129:
	BTFSC      STATUS+0, 0
	GOTO       L_Buttoncheck66
;Dimmer e Sensor.c,259 :: 		PercentOn = Maxbrt;
	MOVLW      253
	MOVWF      _PercentOn+0
	MOVLW      0
	MOVWF      _PercentOn+1
;Dimmer e Sensor.c,260 :: 		return;
	RETURN
;Dimmer e Sensor.c,261 :: 		}
L_Buttoncheck66:
;Dimmer e Sensor.c,262 :: 		while(TestCount++ < 30) //Turn off for a short period
	MOVF       _TestCount+0, 0
	MOVWF      R1+0
	MOVF       _TestCount+1, 0
	MOVWF      R1+1
	INCF       _TestCount+0, 1
	BTFSC      STATUS+0, 2
	INCF       _TestCount+1, 1
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck130
	MOVLW      30
	SUBWF      R1+0, 0
L__Buttoncheck130:
	BTFSC      STATUS+0, 0
	GOTO       L_Buttoncheck68
;Dimmer e Sensor.c,264 :: 		PercentOn = Maxdim;
	MOVF       _Maxdim+0, 0
	MOVWF      _PercentOn+0
	MOVF       _Maxdim+1, 0
	MOVWF      _PercentOn+1
;Dimmer e Sensor.c,265 :: 		return;
	RETURN
;Dimmer e Sensor.c,266 :: 		}
L_Buttoncheck68:
;Dimmer e Sensor.c,267 :: 		PercentOn = Maxdim;
	MOVF       _Maxdim+0, 0
	MOVWF      _PercentOn+0
	MOVF       _Maxdim+1, 0
	MOVWF      _PercentOn+1
;Dimmer e Sensor.c,268 :: 		TestCount = 0; //Reset to beggining of test sequence
	CLRF       _TestCount+0
	CLRF       _TestCount+1
;Dimmer e Sensor.c,269 :: 		if(++Outcount == 255) //Run 255 cycles of test mode
	INCF       _Outcount+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Outcount+1, 1
	MOVLW      0
	XORWF      _Outcount+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck131
	MOVLW      255
	XORWF      _Outcount+0, 0
L__Buttoncheck131:
	BTFSS      STATUS+0, 2
	GOTO       L_Buttoncheck69
;Dimmer e Sensor.c,271 :: 		TestCheck = 0; //Clear Test mode flag
	CLRF       _TestCheck+0
	CLRF       _TestCheck+1
;Dimmer e Sensor.c,272 :: 		DelayCnt = NotInTest;
	MOVLW      3
	MOVWF      _DelayCnt+0
	MOVLW      0
	MOVWF      _DelayCnt+1
;Dimmer e Sensor.c,273 :: 		Outcount = 0;
	CLRF       _Outcount+0
	CLRF       _Outcount+1
;Dimmer e Sensor.c,274 :: 		}
L_Buttoncheck69:
;Dimmer e Sensor.c,275 :: 		return;
	RETURN
;Dimmer e Sensor.c,276 :: 		}
L_Buttoncheck47:
;Dimmer e Sensor.c,277 :: 		if(TestCheck) //If Test mode not entered quickly,
	MOVF       _TestCheck+0, 0
	IORWF      _TestCheck+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Buttoncheck70
;Dimmer e Sensor.c,278 :: 		if(++Outcount == 0x60) // quit checking
	INCF       _Outcount+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Outcount+1, 1
	MOVLW      0
	XORWF      _Outcount+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck132
	MOVLW      96
	XORWF      _Outcount+0, 0
L__Buttoncheck132:
	BTFSS      STATUS+0, 2
	GOTO       L_Buttoncheck71
;Dimmer e Sensor.c,280 :: 		DelayCnt = NotInTest;
	MOVLW      3
	MOVWF      _DelayCnt+0
	MOVLW      0
	MOVWF      _DelayCnt+1
;Dimmer e Sensor.c,281 :: 		Outcount = 0;
	CLRF       _Outcount+0
	CLRF       _Outcount+1
;Dimmer e Sensor.c,282 :: 		TestCheck = 0;
	CLRF       _TestCheck+0
	CLRF       _TestCheck+1
;Dimmer e Sensor.c,283 :: 		}
L_Buttoncheck71:
L_Buttoncheck70:
;Dimmer e Sensor.c,284 :: 		if(!TestCheck && !Brtbut && !Dimbut) //Check bright & dim at same time
	MOVF       _TestCheck+0, 0
	IORWF      _TestCheck+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Buttoncheck74
	BTFSC      PORTA+0, 4
	GOTO       L_Buttoncheck74
	BTFSC      PORTC+0, 4
	GOTO       L_Buttoncheck74
L__Buttoncheck111:
;Dimmer e Sensor.c,285 :: 		TestCheck = 1; //If both pressed, set to look for next combo
	MOVLW      1
	MOVWF      _TestCheck+0
	MOVLW      0
	MOVWF      _TestCheck+1
L_Buttoncheck74:
;Dimmer e Sensor.c,286 :: 		if(TestCheck == 1 && !Brtbut && Dimbut) //Check for only bright button pressed
	MOVLW      0
	XORWF      _TestCheck+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck133
	MOVLW      1
	XORWF      _TestCheck+0, 0
L__Buttoncheck133:
	BTFSS      STATUS+0, 2
	GOTO       L_Buttoncheck77
	BTFSC      PORTA+0, 4
	GOTO       L_Buttoncheck77
	BTFSS      PORTC+0, 4
	GOTO       L_Buttoncheck77
L__Buttoncheck110:
;Dimmer e Sensor.c,287 :: 		TestCheck = 2; //If pressed, set to look for next combo
	MOVLW      2
	MOVWF      _TestCheck+0
	MOVLW      0
	MOVWF      _TestCheck+1
L_Buttoncheck77:
;Dimmer e Sensor.c,288 :: 		if(TestCheck == 2 && !Brtbut && !Dimbut) //Check for both pressed again
	MOVLW      0
	XORWF      _TestCheck+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck134
	MOVLW      2
	XORWF      _TestCheck+0, 0
L__Buttoncheck134:
	BTFSS      STATUS+0, 2
	GOTO       L_Buttoncheck80
	BTFSC      PORTA+0, 4
	GOTO       L_Buttoncheck80
	BTFSC      PORTC+0, 4
	GOTO       L_Buttoncheck80
L__Buttoncheck109:
;Dimmer e Sensor.c,290 :: 		TestCheck = 3; //Enable test mode
	MOVLW      3
	MOVWF      _TestCheck+0
	MOVLW      0
	MOVWF      _TestCheck+1
;Dimmer e Sensor.c,291 :: 		TestCount = 0;
	CLRF       _TestCount+0
	CLRF       _TestCount+1
;Dimmer e Sensor.c,292 :: 		PercentOn = Maxdim;
	MOVF       _Maxdim+0, 0
	MOVWF      _PercentOn+0
	MOVF       _Maxdim+1, 0
	MOVWF      _PercentOn+1
;Dimmer e Sensor.c,293 :: 		Outcount = 0;
	CLRF       _Outcount+0
	CLRF       _Outcount+1
;Dimmer e Sensor.c,294 :: 		}
L_Buttoncheck80:
;Dimmer e Sensor.c,295 :: 		if(!Dimbut && !Brtbut) //If both pressed
	BTFSC      PORTC+0, 4
	GOTO       L_Buttoncheck83
	BTFSC      PORTA+0, 4
	GOTO       L_Buttoncheck83
L__Buttoncheck108:
;Dimmer e Sensor.c,297 :: 		if(LastBoth == 0) //Don't flash if held
	MOVLW      0
	XORWF      _LastBoth+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck135
	MOVLW      0
	XORWF      _LastBoth+0, 0
L__Buttoncheck135:
	BTFSS      STATUS+0, 2
	GOTO       L_Buttoncheck84
;Dimmer e Sensor.c,299 :: 		LastBoth = 1;
	MOVLW      1
	MOVWF      _LastBoth+0
	MOVLW      0
	MOVWF      _LastBoth+1
;Dimmer e Sensor.c,301 :: 		if(PercentOn == Maxdim) //If full off...
	MOVF       _PercentOn+1, 0
	XORWF      _Maxdim+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck136
	MOVF       _Maxdim+0, 0
	XORWF      _PercentOn+0, 0
L__Buttoncheck136:
	BTFSS      STATUS+0, 2
	GOTO       L_Buttoncheck85
;Dimmer e Sensor.c,302 :: 		PercentOn = Maxbrt; // turn full on...
	MOVLW      253
	MOVWF      _PercentOn+0
	MOVLW      0
	MOVWF      _PercentOn+1
	GOTO       L_Buttoncheck86
L_Buttoncheck85:
;Dimmer e Sensor.c,304 :: 		PercentOn = Maxdim; // otherwise turn off
	MOVF       _Maxdim+0, 0
	MOVWF      _PercentOn+0
	MOVF       _Maxdim+1, 0
	MOVWF      _PercentOn+1
L_Buttoncheck86:
;Dimmer e Sensor.c,305 :: 		}
L_Buttoncheck84:
;Dimmer e Sensor.c,306 :: 		}
	GOTO       L_Buttoncheck87
L_Buttoncheck83:
;Dimmer e Sensor.c,308 :: 		LastBoth = 0;
	CLRF       _LastBoth+0
	CLRF       _LastBoth+1
L_Buttoncheck87:
;Dimmer e Sensor.c,309 :: 		if(!Brtbut && Dimbut) //Check for brighten cmd
	BTFSC      PORTA+0, 4
	GOTO       L_Buttoncheck90
	BTFSS      PORTC+0, 4
	GOTO       L_Buttoncheck90
L__Buttoncheck107:
;Dimmer e Sensor.c,311 :: 		if(sw_auto)
	BTFSS      _sw_auto+0, BitPos(_sw_auto+0)
	GOTO       L_Buttoncheck91
;Dimmer e Sensor.c,312 :: 		PercentOn = Maxbrt;
	MOVLW      253
	MOVWF      _PercentOn+0
	MOVLW      0
	MOVWF      _PercentOn+1
	GOTO       L_Buttoncheck92
L_Buttoncheck91:
;Dimmer e Sensor.c,314 :: 		PercentOn ++;
	INCF       _PercentOn+0, 1
	BTFSC      STATUS+0, 2
	INCF       _PercentOn+1, 1
L_Buttoncheck92:
;Dimmer e Sensor.c,315 :: 		}
L_Buttoncheck90:
;Dimmer e Sensor.c,316 :: 		if(Brtbut && !Dimbut) //Check for dim cmd
	BTFSS      PORTA+0, 4
	GOTO       L_Buttoncheck95
	BTFSC      PORTC+0, 4
	GOTO       L_Buttoncheck95
L__Buttoncheck106:
;Dimmer e Sensor.c,318 :: 		if(sw_auto)
	BTFSS      _sw_auto+0, BitPos(_sw_auto+0)
	GOTO       L_Buttoncheck96
;Dimmer e Sensor.c,319 :: 		PercentOn = Maxdim;
	MOVF       _Maxdim+0, 0
	MOVWF      _PercentOn+0
	MOVF       _Maxdim+1, 0
	MOVWF      _PercentOn+1
	GOTO       L_Buttoncheck97
L_Buttoncheck96:
;Dimmer e Sensor.c,321 :: 		PercentOn --;
	MOVLW      1
	SUBWF      _PercentOn+0, 1
	BTFSS      STATUS+0, 0
	DECF       _PercentOn+1, 1
L_Buttoncheck97:
;Dimmer e Sensor.c,322 :: 		}
L_Buttoncheck95:
;Dimmer e Sensor.c,324 :: 		if(sw_auto)
	BTFSS      _sw_auto+0, BitPos(_sw_auto+0)
	GOTO       L_Buttoncheck98
;Dimmer e Sensor.c,326 :: 		en0 = (int)sensor_out - (int)set_point;
	MOVF       _set_point+0, 0
	SUBWF      _sensor_out+0, 0
	MOVWF      R1+0
	MOVF       _set_point+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _sensor_out+1, 0
	MOVWF      R1+1
	MOVF       R1+0, 0
	MOVWF      _en0+0
	MOVF       R1+1, 0
	MOVWF      _en0+1
;Dimmer e Sensor.c,328 :: 		if(en0 > 0)
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck137
	MOVF       R1+0, 0
	SUBLW      0
L__Buttoncheck137:
	BTFSC      STATUS+0, 0
	GOTO       L_Buttoncheck99
;Dimmer e Sensor.c,330 :: 		PercentOn --;
	MOVLW      1
	SUBWF      _PercentOn+0, 1
	BTFSS      STATUS+0, 0
	DECF       _PercentOn+1, 1
;Dimmer e Sensor.c,331 :: 		}
L_Buttoncheck99:
;Dimmer e Sensor.c,332 :: 		if(en0 < 0)
	MOVLW      128
	XORWF      _en0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck138
	MOVLW      0
	SUBWF      _en0+0, 0
L__Buttoncheck138:
	BTFSC      STATUS+0, 0
	GOTO       L_Buttoncheck100
;Dimmer e Sensor.c,334 :: 		PercentOn ++;
	INCF       _PercentOn+0, 1
	BTFSC      STATUS+0, 2
	INCF       _PercentOn+1, 1
;Dimmer e Sensor.c,335 :: 		}
L_Buttoncheck100:
;Dimmer e Sensor.c,337 :: 		}
L_Buttoncheck98:
;Dimmer e Sensor.c,339 :: 		if(PercentOn > Maxbrt) //If greater than full bright
	MOVF       _PercentOn+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck139
	MOVF       _PercentOn+0, 0
	SUBLW      253
L__Buttoncheck139:
	BTFSC      STATUS+0, 0
	GOTO       L_Buttoncheck101
;Dimmer e Sensor.c,340 :: 		PercentOn = Maxbrt;
	MOVLW      253
	MOVWF      _PercentOn+0
	MOVLW      0
	MOVWF      _PercentOn+1
L_Buttoncheck101:
;Dimmer e Sensor.c,341 :: 		if(PercentOn < Maxdim) //If less than full dim
	MOVF       _Maxdim+1, 0
	SUBWF      _PercentOn+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Buttoncheck140
	MOVF       _Maxdim+0, 0
	SUBWF      _PercentOn+0, 0
L__Buttoncheck140:
	BTFSC      STATUS+0, 0
	GOTO       L_Buttoncheck102
;Dimmer e Sensor.c,342 :: 		PercentOn = Maxdim;
	MOVF       _Maxdim+0, 0
	MOVWF      _PercentOn+0
	MOVF       _Maxdim+1, 0
	MOVWF      _PercentOn+1
L_Buttoncheck102:
;Dimmer e Sensor.c,343 :: 		}
	RETURN
; end of _Buttoncheck
