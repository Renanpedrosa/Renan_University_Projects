#line 1 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/Inicializacoes_FSM.c"
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct02 - acelerômetro/programa ct02/funcoes_adxl.h"



void ADXL345_Write(unsigned short address, unsigned short data1);
unsigned short ADXL345_Read(unsigned short address);
void ADXL345_Read_Multiple(unsigned short address, char numBytes, char * buffer);
void ADXL345_Init();
void ADXL345_Read_XYZ(char * dados);
#line 9 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/Inicializacoes_FSM.c"
sbit ADXL_CS at LATC5_bit;
sbit ADXL_CS_Direction at TRISC5_bit;

sbit Expander_CS at LATA8_bit;
sbit Expander_CS_Direction at TRISA8_bit;

sbit SPExpanderRST at RA9_bit;
sbit SPExpanderCS at RA8_bit;
sbit SPExpanderRST_Direction at TRISA9_bit;
sbit SPExpanderCS_Direction at TRISA8_bit;

sbit Mmc_Chip_Select at LATB8_bit;
sbit Mmc_Chip_Select_Direction at TRISB8_bit;

void InitClock()
{






 CLKDIV &= 0xFFE0;
 CLKDIV |= 0x0003;
 PLLFBD = 38;
 CLKDIV &= 0xFF3F;
#line 53 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/Inicializacoes_FSM.c"
 asm {
 ; Unlocking Assembly language code.
 MOV #0x743, w1 ;note memory address of OSSCONH address
 MOV.B #0b011, w0
 MOV #0x78, w2
 MOV #0x9A, w3
 MOV.B w2, [w1]
 MOV.B w3, [w1]
 MOV.B w0, [w1]

 MOV #0x742, w1 ;note memory address of OSSCONL address
 MOV.B #0x03, w0
 MOV #0x46, w2
 MOV #0x57, w3
 MOV.B w2, [w1]
 MOV.B w3, [w1]
 MOV.B w0, [w1]
 NOP
 NOP
 }




}

void InitPorts()
{

 AD1PCFGL = 0x01BE;


 TRISA10_bit = 0;
 TRISA7_bit = 0;
 TRISB2_bit = 0;
 TRISB4_bit = 1;
 TRISA4_bit = 1;
 TRISB1_bit = 1;
 TRISB0_bit = 1;
 TRISA1_bit = 1;
 TRISA2_bit = 1;
 TRISA3_bit = 0;


 TRISC0_bit = 1;
 TRISC1_bit = 1;
 TRISC2_bit = 1;
 TRISB3_bit = 1;
 TRISB15_bit = 1;
 TRISA0_bit = 1;
 TRISB14_bit = 1;
 TRISB12_bit = 1;
 TRISB13_bit = 1;


 ADXL_CS_Direction = 0;
 Mmc_Chip_Select_Direction = 0;
 SPExpanderRST_Direction = 0;
 SPExpanderCS_Direction = 0;
 TRISB5_bit = 0;
 TRISB6_bit = 1;
 TRISB7_bit = 0;
 TRISC8_bit = 0;
 TRISC7_bit = 1;
 TRISB9_bit = 0;
 TRISC6_bit = 1;
 TRISC3_bit = 0;
 TRISC4_bit = 1;
 ADXL_CS = 1;


 Unlock_IOLOCK();
 PPS_Mapping(5, _OUTPUT, _SCK1OUT);
 PPS_Mapping(6, _INPUT, _SDI1);
 PPS_Mapping(7, _OUTPUT, _SDO1);
 PPS_Mapping(24, _OUTPUT, _U1TX);
 PPS_Mapping(23, _INPUT, _U1RX);
 PPS_Mapping(9, _OUTPUT, _U2TX);
 PPS_Mapping(22, _INPUT, _U2RX);
 PPS_Mapping(19, _OUTPUT, _C1TX);
 PPS_Mapping(20, _INPUT, _CIRX);
 PPS_Mapping(17, _INPUT, _IC1);
 PPS_Mapping(18, _INPUT, _IC2);
 PPS_Mapping(3, _INPUT, _IC7);
 Lock_IOLOCK();
}



void InitTimersCapture()
{

 IEC0.F3 = 1;
 TMR1 = 0xE795;
 T1CON.F5 = 1;
 T1CON.F4 = 1;
 IFS0.F3 = 0;




 T1CON.F15 = 1;


 T5CONbits.TCKPS = 0b01;
 T5CONbits.TCS = 0;
 TMR5 = 0xF447;
 T5IE_bit = 1;
 T5IF_bit = 0;
 T5CONbits.TON = 1;


 T2CONbits.TCKPS = 0b11;
 T2CONbits.T32 = 0;
 T2CONbits.TCS = 0;
 T2CONbits.TON = 1;


 T3CONbits.TCKPS = 0b10;
 T3CONbits.TCS = 0;
 T3CONbits.TON = 1;


 IC1CONbits.ICM=0b00;
 IC1CONbits.ICTMR= 1;
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
 IC7CONbits.ICTMR= 0;
 IC7CONbits.ICI= 0b01;
 IC7CONbits.ICM= 0b011;


 IPC5bits.IC7IP = 1;
 IFS1bits.IC7IF = 0;
 IEC1bits.IC7IE = 1;

}

void InitMain()
{
 ADC1_Init_Advanced(_ADC_12bit, _ADC_INTERNAL_REF);

 UART1_Init(115200);
 Delay_ms(1000);

 UART1_Write_Text("Inicializando módulo...");
 UART1_Write(0X0D);
 UART1_Write(0X0A);

 UART2_Init(57600);
 U2MODEbits.UARTEN = 0;
 U2RXIF_bit = 0;
 IPC7bits.U2RXIP = 0;
 U2STAbits.URXISEL = 0b11;
 IFS1bits.U2TXIF = 0;
 IEC1bits.U2TXIE = 1;
 IFS1bits.U2RXIF = 0;
 IEC1bits.U2RXIE = 1;
 U2MODEbits.UARTEN = 1;
 Delay_ms(1000);



 UART2_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29");
 UART2_Write(0x0D);
 UART2_Write(0x0A);
 Delay_ms(500);

 UART2_Write_Text("$PMTK220,200*2C");
 UART2_Write(0x0D);
 UART2_Write(0x0A);
 Delay_ms(500);





 SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_8, _SPI_PRESCALE_PRI_4,_SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);

 ADXL345_Init();




}
