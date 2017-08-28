#line 1 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT03 - Backnode/Programa BSM/Inicializacoes_BSM.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for dspic/include/built_in.h"
#line 7 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT03 - Backnode/Programa BSM/Inicializacoes_BSM.c"
void InitClock()
{
#line 20 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT03 - Backnode/Programa BSM/Inicializacoes_BSM.c"
 CLKDIV &= 0xFFE0;
 CLKDIV |= 0x0002;
 PLLFBD = 38;
 CLKDIV &= 0xFF3F;
#line 30 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT03 - Backnode/Programa BSM/Inicializacoes_BSM.c"
 asm{
 ;Unlocking Assembly language code.
 MOV #0x743, w1 ;note memory address of OSSCONH address
 MOV.B #0b011, w0
 MOV #0x78, w2
 MOV #0x9A, w3
 MOV.B w2, [w1]
 MOV.B w3, [w1]
 MOV.B w0, [w1]

 MOV #0x742, w1 ;note memory address of OSSCONL address
 MOV.B #0x01, w0
 MOV #0x46, w2
 MOV #0x57, w3
 MOV.B w2, [w1]
 MOV.B w3, [w1]
 MOV.B w0, [w1]
 NOP
 NOP
 }
 while(OSCCONbits.COSC != 0b011) {}



}


void InitPorts()
{

 AD1PCFGL = 0x1000;


 TRISA0_bit = 1;
 TRISA1_bit = 1;
 TRISB0_bit = 1;
 TRISB1_bit = 1;
 TRISB2_bit = 1;
 TRISB3_bit = 1;
 TRISC0_bit = 1;
 TRISC1_bit = 1;
 TRISC2_bit = 1;
 TRISB15_bit = 1;
 TRISB14_bit = 1;
 TRISB13_bit = 1;


 TRISB11_bit = 1;
 TRISB12_bit = 1;
 TRISB10_bit = 1;
 TRISC9_bit = 1;
 TRISB4_bit = 1;
 TRISA10_bit = 1;
 TRISB7_bit = 1;
 TRISA7_bit = 1;
 TRISA8_bit = 0;
 TRISA9_bit = 0;
 TRISC7_bit = 0;
 TRISC8_bit = 1;
 TRISC3_bit = 0;
 TRISC4_bit = 1;
 TRISB9_bit = 1;
 TRISB8_bit = 0;
 TRISA4_bit = 1;
 TRISC5_bit = 0;
 TRISC6_bit = 0;



 Unlock_IOLOCK();


 PPS_Mapping(12, _INPUT, _IC1);
 PPS_Mapping(10, _INPUT, _IC2);
 PPS_Mapping(25, _INPUT, _IC7);
 PPS_Mapping(23, _OUTPUT, _C1TX);
 PPS_Mapping(24, _INPUT, _CIRX);
 Lock_IOLOCK();
}





void InitTimersCapture()
{
#line 129 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT03 - Backnode/Programa BSM/Inicializacoes_BSM.c"
 T3CONbits.TCKPS = 0b10;
 T3CONbits.TCS = 0;
 T3CONbits.TON = 1;


 T2CONbits.TCKPS = 0b11;
 T2CONbits.T32 = 0;
 T2CONbits.TCS = 0;
 T2CONbits.TON = 1;



 IC1CONbits.ICM=0b00;
 IC1CONbits.ICTMR= 0;
 IC1CONbits.ICI= 0b01;
 IC1CONbits.ICM= 0b011;


 IPC0bits.IC1IP = 1;
 IFS0bits.IC1IF = 0;
 IEC0bits.IC1IE = 1;


 IC2CONbits.ICM=0b00;
 IC2CONbits.ICTMR= 1;
 IC2CONbits.ICI= 0b01;
 IC2CONbits.ICM= 0b011;


 IPC1bits.IC2IP = 1;
 IFS0bits.IC2IF = 0;
 IEC0bits.IC2IE = 1;


 IC7CONbits.ICM=0b00;
 IC7CONbits.ICTMR= 1;
 IC7CONbits.ICI= 0b01;
 IC7CONbits.ICM= 0b011;


 IPC5bits.IC7IP = 1;
 IFS1bits.IC7IF = 0;
 IEC1bits.IC7IE = 1;

}

void InitMain()
{




}
