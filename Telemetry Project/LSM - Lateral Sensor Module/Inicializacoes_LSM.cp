#line 1 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT01 - Medidor Bateria/CT01/Inicializacoes_LSM.c"
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct01 - medidor bateria/ct01/__lib_ecan1_defs.h"
#line 13 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct01 - medidor bateria/ct01/__lib_ecan1_defs.h"
typedef
 struct {
 struct {
 IDE : 1;
 SRR : 1;
 SID : 11;
 : 3;
 } CxTRBnSID;
 struct {
 EID17_6 : 12;
 : 4;
 } CxTRBnEID;
 struct {
 DLC : 4;
 RB0 : 1;
 : 3;
 RB1 : 1;
 RTR : 1;
 EID5_0 : 6;
 } CxTRBnDLC;
 struct d{
 char Data[8];
 } CxTRBnData;
 struct {
 : 8;
 FILHIT : 5;

 : 3;
 } CxTRBnSTAT;
 } __RxTxBuffer;
#line 57 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct01 - medidor bateria/ct01/__lib_ecan1_defs.h"
unsigned dma ECAN1RamStartAddress = 0x4000;

__RxTxBuffer dma ECAN1RxTxRAMBuffer[ 16 ] absolute 0x4000;
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct01 - medidor bateria/ct01/pga_drivers_lsm.h"


void PGA_Set_Gain(char ganho);
void PGA_Set_Channel(char canal);
#line 14 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT01 - Medidor Bateria/CT01/Inicializacoes_LSM.c"
unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;
unsigned int Rx_Data_Len;
char RxTx_Data[8];
char Msg_Rcvd;
unsigned long Rx_ID;

void InitClock()
{


 CLKDIV &= 0xFFE0;
 CLKDIV |= 0x0003;
 PLLFBD = 38;
 CLKDIV &= 0xFF3F;
#line 50 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT01 - Medidor Bateria/CT01/Inicializacoes_LSM.c"
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

 AD1PCFGL = 0x1800;


 TRISA0_bit = 1;
 TRISA1_bit = 1;
 TRISB0_bit = 1;
 TRISB1_bit = 1;
 TRISB2_bit = 1;
 TRISB3_bit = 1;
 TRISC0_bit = 1;
 TRISB15_bit = 1;


 TRISA8_bit = 0;
 TRISA9_bit = 1;
 TRISB7_bit = 1;
 TRISB10_bit = 0;
 TRISB11_bit = 0;
 TRISB12_bit = 0;
 TRISB13_bit = 1;
 TRISC3_bit = 0;
 TRISC4_bit = 0;
 TRISC5_bit = 0;
 TRISC8_bit = 0;
 TRISC9_bit = 1;

 Unlock_IOLOCK();
 PPS_Mapping(19, _OUTPUT, _SCK1OUT);
 PPS_Mapping(20, _OUTPUT, _SDO1);
 PPS_Mapping(11, _OUTPUT, _SDO2);
 PPS_Mapping(12, _OUTPUT, _SCK2OUT);
 PPS_Mapping(13, _INPUT, _SDI2);
 PPS_Mapping(7, _INPUT, _IC1);
 PPS_Mapping(24, _OUTPUT, _C1TX);
 PPS_Mapping(25, _INPUT, _CIRX);
 Lock_IOLOCK();
}





void InitCan()
{


 IFS0=0;
 IFS1=0;
 IFS2=0;
 IFS3=0;
 IFS4=0;



 IEC2bits.C1IE = 1;
 C1INTEbits.TBIE = 1;
 C1INTEbits.RBIE = 1;

 Can_Init_Flags = 0;
 Can_Send_Flags = 0;
 Can_Rcv_Flags = 0;

 Can_Send_Flags = _ECAN_TX_PRIORITY_0 &
 _ECAN_TX_XTD_FRAME &
 _ECAN_TX_NO_RTR_FRAME;

 Can_Init_Flags = _ECAN_CONFIG_SAMPLE_THRICE &
 _ECAN_CONFIG_PHSEG2_PRG_ON &
 _ECAN_CONFIG_XTD_MSG &
 _ECAN_CONFIG_MATCH_MSG_TYPE &
 _ECAN_CONFIG_LINE_FILTER_OFF;

 ECAN1DmaChannelInit(0, 1, &ECAN1RxTxRAMBuffer);

 ECAN1DmaChannelInit(2, 0, &ECAN1RxTxRAMBuffer);

 ECAN1Initialize( 1 ,  4 ,  3 ,  3 ,  1 , Can_Init_Flags);
 ECAN1SetBufferSize( 16 );

 ECAN1SelectTxBuffers(0x00FF);

 ECAN1SetOperationMode(_ECAN_MODE_CONFIG,0xFF);

 ECAN1SetMask(_ECAN_MASK_0, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);
 ECAN1SetMask(_ECAN_MASK_1, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);
 ECAN1SetMask(_ECAN_MASK_2, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);



 ECAN1SetOperationMode(_ECAN_MODE_NORMAL,0xFF);
}

void InitTimersCapture()
{

 T2CONbits.TCKPS = 0b11;
 T2CONbits.T32 = 0;
 T2CONbits.TCS = 0;
 T2CONbits.TON = 1;


 IC1CONbits.ICM=0b00;
 IC1CONbits.ICTMR= 1;
 IC1CONbits.ICI= 0b01;
 IC1CONbits.ICM= 0b011;


 IPC0bits.IC1IP = 2;
 IFS0bits.IC1IF = 0;
 IEC0bits.IC1IE = 1;

}
#line 211 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT01 - Medidor Bateria/CT01/Inicializacoes_LSM.c"
void InitMain()
{


 ADC1_Init_Advanced(_ADC_12bit, _ADC_INTERNAL_REF);


 SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_8, _SPI_PRESCALE_PRI_1, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_IDLE_2_ACTIVE);


 PGA_Set_Gain(1);

}
