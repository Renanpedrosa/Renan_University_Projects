#line 1 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/CT02_III.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for dspic/include/built_in.h"
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct02 - acelerômetro/programa ct02/ecan_ids.h"







long const FSM_ACCEL1 = 1000 ;
long const FSM_ACCEL2 = 1010 ;
long const FSM_GPIO1 = 1020 ;
long const FSM_GPIO2 = 1030 ;




long const FSM_CTRL = 1060 ;
long const LSM_ELET_1 = 2000 ;
long const LSM_ELET_2 = 2010 ;
long const LSM_PGA_1 = 2020 ;
long const LSM_PGA_2 = 2030 ;
long const BSM_ANA_1 = 3000 ;
long const BSM_ANA_2 = 3010 ;
long const BSM_ANA_3 = 3030 ;
long const BSM_DIG_1 = 3040 ;
long const BSM_DIG_2 = 3050 ;
long const BSM_GPS_1 = 3060 ;
long const BSM_GPS_2 = 3070 ;
long const BSM_GPS_3 = 3080 ;
long const BSM_GPS_4 = 3090 ;
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct02 - acelerômetro/programa ct02/ecan_defs.h"
#line 13 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct02 - acelerômetro/programa ct02/ecan_defs.h"
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
#line 57 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct02 - acelerômetro/programa ct02/ecan_defs.h"
unsigned dma ECAN1RamStartAddress = 0x4000;

__RxTxBuffer dma ECAN1RxTxRAMBuffer[ 16 ] absolute 0x4000;
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct02 - acelerômetro/programa ct02/inicializacoes_fsm.h"
#line 27 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct02 - acelerômetro/programa ct02/inicializacoes_fsm.h"
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









const char ID_FSM_ACCEL1[] = "$01,";
const char ID_FSM_ACCEL2[] = "$02,";
const char ID_FSM_GPIO1[] = "$03,";
const char ID_FSM_GPIO2[] = "$04,";
const char ID_FSM_CTRL[] = "$09,";
const char ID_LSM_ELET_1[] = "$10,";
const char ID_LSM_ELET_2[] = "$11,";
const char ID_LSM_PGA_1[] = "$12,";
const char ID_LSM_PGA_2[] = "$13,";
const char ID_BSM_ANA_1[] = "$14,";
const char ID_BSM_ANA_2[] = "$15,";
const char ID_BSM_ANA_3[] = "$16,";
const char ID_BSM_DIG_1[] = "$17,";
const char ID_BSM_DIG_2[] = "$18,";
const char ID_GPS_1[] = "$19,";
const char ID_GPS_2[] = "$20,";
const char ID_GPS_3[] = "$21,";
const char ID_GPS_TIME_1[] = "$22,";
const char ID_GPS_TIME_2[] = "$23,";

void InitClock();
void InitPorts();
void InitTimersCapture();
void InitCAN();
void InitMain();
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct02 - acelerômetro/programa ct02/funcoes_adxl.h"



void ADXL345_Write(unsigned short address, unsigned short data1);
unsigned short ADXL345_Read(unsigned short address);
void ADXL345_Read_Multiple(unsigned short address, char numBytes, char * buffer);
void ADXL345_Init();
void ADXL345_Read_XYZ(char * dados);
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct02 - acelerômetro/programa ct02/funcoes_radio.h"


void Write_UART_UDATA(char *ID, unsigned dado1, unsigned dado2, unsigned dado3, unsigned dado4);
#line 65 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/CT02_III.c"
unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;
unsigned int Rx_Data_Len;
char RxTx_Data[8];
unsigned int Msg_Rcvd;

unsigned long Rx_ID;

unsigned int t1, t2;

unsigned INT_ACCEL_X_FSM;
unsigned INT_ACCEL_Y_FSM;
unsigned INT_ACCEL_Z_FSM;
int AdxlX;
int AdxlY;
int AdxlZ;
unsigned ADXL_X_FSM;
unsigned ADXL_Y_FSM;
unsigned ADXL_Z_FSM;
unsigned ADXL_POS_NEG_FSM;
unsigned STATUS_ACCEL_FSM;
unsigned BOTAO_1_2_FSM;

unsigned GPIN0_FSM;
unsigned GPIN1_FSM;
unsigned GPIN2_FSM;
unsigned GPIN3_FSM;
unsigned GPIN4_FSM;
unsigned GPIN5_FSM;
unsigned GPIN6_FSM;



unsigned GPIN0_LSM;
unsigned GPIN1_LSM;
unsigned GPIN2_LSM;
unsigned GPIN3_LSM;
unsigned GPIN4_LSM;
unsigned GPIN5_LSM;
unsigned ICAN_BUS_LSM;
unsigned DIG1_LSM;
unsigned PGA0_LSM;
unsigned PGA1_LSM;
unsigned PGA2_LSM;
unsigned PGA3_LSM;
unsigned PGA4_LSM;
unsigned PGA5_LSM;
unsigned PGA6_LSM;
char PGA0_Gain_LSM;
char PGA1_Gain_LSM;
char PGA2_Gain_LSM;
char PGA3_Gain_LSM;
char PGA4_Gain_LSM;
char PGA5_Gain_LSM;
char PGA_01_Gain_LSM;
char PGA_23_Gain_LSM;
char PGA_45_Gain_LSM;
unsigned PGA_0123_GAIN_LSM;



unsigned ANA0_BSM;
unsigned ANA1_BSM;
unsigned ANA2_BSM;
unsigned ANA3_BSM;
unsigned ANA4_BSM;
unsigned ANA5_BSM;
unsigned ANA6_BSM;
unsigned ANA7_BSM;
unsigned ANA8_BSM;
unsigned ANA9_BSM;
unsigned ANA10_BSM;
unsigned ANA11_BSM;
unsigned DIG1_BSM;
unsigned DIG2_BSM;
unsigned DIG3_BSM;
unsigned DIG4_BSM;
unsigned DIG5_BSM;
unsigned DIG6_BSM;
unsigned DIG7_BSM;
unsigned DIG8_BSM;

char LATITUDE_INT_GPS[6];
char LATITUDE_FRAC_GPS[6];
char LONGITUDE_INT_GPS[6];
char LONGITUDE_FRAC_GPS[6];
char NORTH_SOUTH_GPS[6];
char EAST_WEST_GPS[6];
char N_S_E_W_GPS[6];
char STATUS_GPS_A_V_GPS[6];
char GPS_FIX_GPS[6];
char CHECKSUM_GPS[6];
char STATUS_CHECKSUM_GPS[6];
char HORA_GPS[6];
char MINUTO_GPS[6];
char SEGUNDO_GPS[6];
char MILISEGUNDO_GPS[6];
char DIA_GPS[6];
char MES_GPS[6];
char ANO_GPS[6];
char VEL_X100_GPS[6];
char DIRECAO_X100_GPS[6];
char HDOP_X100_GPS[6];
char ALTITUDE_GPS[6];



char txt[768];
signed int latitude, longitude;
char *string;
int t=0;
unsigned int tempo_msg;
unsigned int read_gps = 0;
unsigned int gps_ready=0;
char teste;
int cnt_gps;
int index_char;
int cnt_gps2;
int index_char2;
int cnt_gps3;
int index_char3;
char output[200];
unsigned int res;

unsigned int GPS_Parse(char *text);


unsigned temp;
char out[16];
char values[6];
int readings[3] = {0, 0, 0};
long int sumX,sumY,sumZ;
unsigned ready;
unsigned i;

void InitCAN()
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

 ECAN1SelectTxBuffers(0x0003);

 ECAN1SetOperationMode(_ECAN_MODE_CONFIG,0xFF);

 ECAN1SetMask(_ECAN_MASK_0, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);
 ECAN1SetMask(_ECAN_MASK_1, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);
 ECAN1SetMask(_ECAN_MASK_2, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);
 ECAN1SetFilter(_ECAN_FILTER_0, LSM_ELET_1, _ECAN_MASK_0, _ECAN_RX_BUFFER_2, _ECAN_CONFIG_XTD_MSG);
 ECAN1SetFilter(_ECAN_FILTER_1, LSM_ELET_2, _ECAN_MASK_0, _ECAN_RX_BUFFER_3, _ECAN_CONFIG_XTD_MSG);
 ECAN1SetFilter(_ECAN_FILTER_2, LSM_PGA_1, _ECAN_MASK_0, _ECAN_RX_BUFFER_4, _ECAN_CONFIG_XTD_MSG);
 ECAN1SetFilter(_ECAN_FILTER_3, LSM_PGA_2, _ECAN_MASK_0, _ECAN_RX_BUFFER_5, _ECAN_CONFIG_XTD_MSG);
 ECAN1SetFilter(_ECAN_FILTER_4, BSM_ANA_1, _ECAN_MASK_0, _ECAN_RX_BUFFER_6, _ECAN_CONFIG_XTD_MSG);
 ECAN1SetFilter(_ECAN_FILTER_5, BSM_ANA_2, _ECAN_MASK_0, _ECAN_RX_BUFFER_7, _ECAN_CONFIG_XTD_MSG);
 ECAN1SetFilter(_ECAN_FILTER_6, BSM_ANA_3, _ECAN_MASK_0, _ECAN_RX_BUFFER_8, _ECAN_CONFIG_XTD_MSG);
 ECAN1SetFilter(_ECAN_FILTER_7, BSM_DIG_1, _ECAN_MASK_0, _ECAN_RX_BUFFER_9, _ECAN_CONFIG_XTD_MSG);
 ECAN1SetFilter(_ECAN_FILTER_8, BSM_DIG_2, _ECAN_MASK_1, _ECAN_RX_BUFFER_10, _ECAN_CONFIG_XTD_MSG);
#line 272 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/CT02_III.c"
 ECAN1SetOperationMode(_ECAN_MODE_NORMAL, 0xFF);
}



void C1Interrupt(void) org 0x005A
{
 IFS2bits.C1IF = 0;
 if(C1INTFbits.TBIF) {
 C1INTFbits.TBIF = 0;
 }
 if(C1INTFbits.RBIF)
 {

 C1INTFbits.RBIF = 0;
  LATA10_bit  = 1;
 }
}

void interrupt_timer1() iv IVT_ADDR_T1INTERRUPT {
 T1CON.F15 = 0;
 ready = 1;
 TMR1 = 0xE795;

 IFS0.F3 = 0;
 T1CON.F15 = 1;
 }

void interrupt_timer5() iv IVT_ADDR_T5INTERRUPT {

 T5CONbits.TON = 0;
 TMR5 = 0xF447;
 tempo_msg++;
 while(U2STAbits.URXDA == 1)
 {
  LATA10_bit  = 1;
 txt[t++] = U2RXREG;
 if (txt[t-1] == 0)
 {
 t = 0;
 }
 if (t == 768)
 {
 t = 0;

 }
 }

 if(tempo_msg == 5)
 {
 gps_ready = 1;
 tempo_msg = 0;

 }
 T5CONbits.TON = 1;
 T5IF_bit = 0;
}

void U2RXInterrupt(void) iv 0x0050 {

  LATA10_bit  = 1;
#line 362 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/CT02_III.c"
 U2RXIF_bit = 0;

}

void InputCapture1Int() iv IVT_ADDR_IC1INTERRUPT
{
 t1=IC1BUF;
 t2=IC1BUF;
 IC1IF_bit=0;
 if(t2>t1)
 GPIN1_FSM = t2-t1;
 else
 GPIN1_FSM = (PR2 - t1) + t2;
}

void InputCapture2Int() iv IVT_ADDR_IC2INTERRUPT
{
 t1=IC2BUF;
 t2=IC2BUF;
 IC2IF_bit=0;
 if(t2>t1)
 GPIN2_FSM = t2-t1;
 else
 GPIN2_FSM = (PR2 - t1) + t2;
}

void InputCapture7Int() iv IVT_ADDR_IC7INTERRUPT
{
 t1=IC7BUF;
 t2=IC7BUF;
 IC7IF_bit=0;
 if(t2>t1)
 GPIN3_FSM = t2-t1;
 else
 GPIN3_FSM = (PR3 - t1) + t2;
}

void main()
{
  LATA10_bit  = 1;
 InitClock();
 InitPorts();
 InitTimersCapture();
 InitCAN();
 InitMain();
 ready = 0;
 Delay_ms(1000);
  LATA10_bit  = 0;

 tempo_msg = 0;
 t = 0;

 while(1)
 {
 U2STA.F1 = 0;
 U2STA.F2 = 0;






 for( i = 0; i<=3; i++)
 {
 Msg_Rcvd = ECAN1Read(&Rx_ID , RxTx_Data , &Rx_Data_Len, &Can_Rcv_Flags);
 if(Msg_Rcvd)
 {
  LATA10_bit  = 1;
 switch(Rx_ID)
 {
 case LSM_ELET_1:
 {
  ((char *)&ICAN_BUS_LSM)[1]  = RxTx_Data[0];
  ((char *)&ICAN_BUS_LSM)[0]  = RxTx_Data[1];
  ((char *)&GPIN0_LSM)[1]  = RxTx_Data[2];
  ((char *)&GPIN0_LSM)[0]  = RxTx_Data[3];
  ((char *)&GPIN1_LSM)[1]  = RxTx_Data[4];
  ((char *)&GPIN1_LSM)[0]  = RxTx_Data[5];
  ((char *)&GPIN2_LSM)[1]  = RxTx_Data[6];
  ((char *)&GPIN2_LSM)[0]  = RxTx_Data[7];
  LATA10_bit  = 1;
 break;
 }
 case LSM_ELET_2:
 {
  ((char *)&GPIN3_LSM)[1]  = RxTx_Data[0];
  ((char *)&GPIN3_LSM)[0]  = RxTx_Data[1];
  ((char *)&GPIN4_LSM)[1]  = RxTx_Data[2];
  ((char *)&GPIN4_LSM)[0]  = RxTx_Data[3];
  ((char *)&GPIN5_LSM)[1]  = RxTx_Data[4];
  ((char *)&GPIN5_LSM)[0]  = RxTx_Data[5];
  ((char *)&DIG1_LSM)[1]  = RxTx_Data[6];
  ((char *)&DIG1_LSM)[0]  = RxTx_Data[7];
 break;
 }
 case LSM_PGA_1:
 {
  ((char *)&PGA0_LSM)[1]  = RxTx_Data[0];
  ((char *)&PGA0_LSM)[0]  = RxTx_Data[1];
  ((char *)&PGA1_LSM)[1]  = RxTx_Data[2];
  ((char *)&PGA1_LSM)[0]  = RxTx_Data[3];
  ((char *)&PGA2_LSM)[1]  = RxTx_Data[4];
  ((char *)&PGA2_LSM)[0]  = RxTx_Data[5];
  ((char *)&PGA3_LSM)[1]  = RxTx_Data[6];
  ((char *)&PGA3_LSM)[0]  = RxTx_Data[7];
 break;
 }
 case LSM_PGA_2:
 {
  ((char *)&PGA4_LSM)[1]  = RxTx_Data[0];
  ((char *)&PGA4_LSM)[0]  = RxTx_Data[1];
  ((char *)&PGA5_LSM)[1]  = RxTx_Data[2];
  ((char *)&PGA5_LSM)[0]  = RxTx_Data[3];
  ((char *)&PGA_0123_GAIN_LSM)[1]  = RxTx_Data[4];
  ((char *)&PGA_0123_GAIN_LSM)[0]  = RxTx_Data[5];
 PGA_45_GAIN_LSM = RxTx_Data[6];
 break;
 }
#line 578 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/CT02_III.c"
 }

 }
 }
#line 603 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/CT02_III.c"
 if(gps_ready == 1)
 {
 gps_ready = 0;
 res = GPS_Parse(&txt);
 }



 if(ready == 1){

 GPIN0_FSM = ADC1_Get_Sample( 6 );
 GPIN4_FSM = ADC1_Get_Sample( 9 );
 GPIN5_FSM = RC9_bit;
 GPIN6_FSM = ADC1_Get_Sample( 0 );

 BOTAO_1_2_FSM = 0;

 INT_ACCEL_X_FSM = ADC1_Get_Sample( 10 );
 INT_ACCEL_Y_FSM = ADC1_Get_Sample( 12 );
 INT_ACCEL_Z_FSM = ADC1_Get_Sample( 11 );

 ADXL_POS_NEG_FSM = 0;

 ADXL345_Read_XYZ(&values);

 AdxlX = ((int)values[1]<<8)|(int)values[0];

 AdxlY = ((int)values[3]<<8)|(int)values[2];

 AdxlZ = ((int)values[5]<<8)|(int)values[4];

 if((AdxlX==0)&&(AdxlY==0)&&(AdxlZ==0))
 {

 ADXL345_Init();

 ADXL345_Read_XYZ(&values);



 AdxlX = ((int)values[1]<<8)|(int)values[0];

 AdxlY = ((int)values[3]<<8)|(int)values[2];

 AdxlZ = ((int)values[5]<<8)|(int)values[4];

 STATUS_ACCEL_FSM = 0;
 }
 else
 {
 STATUS_ACCEL_FSM = 1;
 }

 if(AdxlX < 0)
 {
 ADXL_X_FSM = abs(AdxlX);
 ADXL_POS_NEG_FSM |= 0b001;
 }
 else
 {
 ADXL_X_FSM = AdxlX;
 }

 if(AdxlY < 0)
 {
 ADXL_Y_FSM = abs(AdxlY);
 ADXL_POS_NEG_FSM |= 0b010;
 }
 else
 {
 ADXL_Y_FSM = AdxlY;
 }

 if(AdxlZ < 0)
 {
 ADXL_Z_FSM = abs(AdxlZ);
 ADXL_POS_NEG_FSM |= 0b100;
 }
 else
 {
 ADXL_Z_FSM = AdxlZ;
 }



  LATA10_bit  = 0;
 Write_UART_UDATA(ID_FSM_ACCEL1, ADXL_X_FSM, ADXL_Y_FSM, ADXL_Z_FSM, ADXL_POS_NEG_FSM);
 Write_UART_UDATA(ID_FSM_ACCEL2, INT_ACCEL_X_FSM, INT_ACCEL_Y_FSM, INT_ACCEL_Z_FSM, STATUS_ACCEL_FSM);
 Write_UART_UDATA(ID_FSM_GPIO1, GPIN0_FSM, GPIN1_FSM, GPIN2_FSM, GPIN3_FSM);
 Write_UART_UDATA(ID_FSM_GPIO2, GPIN4_FSM, GPIN5_FSM, GPIN6_FSM, BOTAO_1_2_FSM);
 Write_UART_UDATA(ID_LSM_ELET_1, ICAN_BUS_LSM, GPIN0_LSM, GPIN1_LSM, GPIN2_LSM);
 Write_UART_UDATA(ID_LSM_ELET_2, GPIN3_LSM, GPIN4_LSM, GPIN5_LSM, DIG1_LSM);
 Write_UART_UDATA(ID_LSM_PGA_1, PGA0_LSM, PGA1_LSM, PGA2_LSM, PGA3_LSM);
 Write_UART_UDATA(ID_LSM_PGA_2, PGA5_LSM, PGA6_LSM, PGA_0123_GAIN_LSM, PGA_45_GAIN_LSM);
#line 702 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/CT02_III.c"
 if(res == 1)
 {
 UART1_Write_Text(ID_GPS_1);
 UART1_Write_Text(LATITUDE_INT_GPS);
 UART1_Write(',');
 UART1_Write_Text(LATITUDE_FRAC_GPS);
 UART1_Write(',');
 UART1_Write_Text(LONGITUDE_INT_GPS);
 UART1_Write(',');
 UART1_Write_Text(LONGITUDE_FRAC_GPS);
 UART1_Write(';');
 UART1_Write(0X0D);
 UART1_Write(0X0A);

 UART1_Write_Text(ID_GPS_2);
 UART1_Write_Text(N_S_E_W_GPS);
 UART1_Write(',');
 UART1_Write_Text(VEL_X100_GPS);
 UART1_Write(',');
 UART1_Write_Text(DIRECAO_X100_GPS);
 UART1_Write(',');
 UART1_Write_Text(STATUS_CHECKSUM_GPS);
 UART1_Write(';');
 UART1_Write(0X0D);
 UART1_Write(0X0A);
#line 740 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/CT02_III.c"
 UART1_Write_Text(ID_GPS_TIME_1);
 UART1_Write_Text(DIA_GPS);
 UART1_Write(',');
 UART1_Write_Text(MES_GPS);
 UART1_Write(',');
 UART1_Write_Text(ANO_GPS);
 UART1_Write(',');
 UART1_Write_Text(HORA_GPS);
 UART1_Write(';');
 UART1_Write(0X0D);
 UART1_Write(0X0A);

 UART1_Write_Text(ID_GPS_TIME_2);
 UART1_Write_Text(MINUTO_GPS);
 UART1_Write(',');
 UART1_Write_Text(SEGUNDO_GPS);
 UART1_Write(',');
 UART1_Write_Text(MILISEGUNDO_GPS);
 UART1_Write(',');
 UART1_Write_Text("00000");
 UART1_Write(';');
 UART1_Write(0X0D);
 UART1_Write(0X0A);


 res = 0;
 }
 ready = 0;

 }


 }
}

unsigned int GPS_Parse(char *text)
{
 if((t>120)&&(t<680))
 {
 string = strstr(text[t-80],"$GPRMC");
 }
 else
 {
 string = strstr(text,"$GPRMC");
 }

 if(string != 0)
 {
 if((string[7] != ',')&&(string[18] == 'A'))
 {



 HORA_GPS[0] = '0';
 HORA_GPS[1] = '0';
 HORA_GPS[2] = '0';
 HORA_GPS[3] = string[7];
 HORA_GPS[4] = string[8];
 HORA_GPS[5] = '\0';

 MINUTO_GPS[0] = '0';
 MINUTO_GPS[1] = '0';
 MINUTO_GPS[2] = '0';
 MINUTO_GPS[3] = string[9];
 MINUTO_GPS[4] = string[10];
 MINUTO_GPS[5] = '\0';

 SEGUNDO_GPS[0] = '0';
 SEGUNDO_GPS[1] = '0';
 SEGUNDO_GPS[2] = '0';
 SEGUNDO_GPS[3] = string[11];
 SEGUNDO_GPS[4] = string[12];
 SEGUNDO_GPS[5] = '\0';

 MILISEGUNDO_GPS[0] = '0';
 MILISEGUNDO_GPS[1] = '0';
 MILISEGUNDO_GPS[2] = string[14];
 MILISEGUNDO_GPS[3] = string[15];
 MILISEGUNDO_GPS[4] = string[16];
 MILISEGUNDO_GPS[5] = '\0';

 LATITUDE_INT_GPS[0] = '0';
 LATITUDE_INT_GPS[1] = string[20];
 LATITUDE_INT_GPS[2] = string[21];
 LATITUDE_INT_GPS[3] = string[22];
 LATITUDE_INT_GPS[4] = string[23];
 LATITUDE_INT_GPS[5] = '\0';

 LATITUDE_FRAC_GPS[0] = string[25];
 LATITUDE_FRAC_GPS[1] = string[26];
 LATITUDE_FRAC_GPS[2] = string[27];
 LATITUDE_FRAC_GPS[3] = string[28];
 LATITUDE_FRAC_GPS[4] = '0';
 LATITUDE_FRAC_GPS[5] = '\0';

 LONGITUDE_INT_GPS[0] = string[32];
 LONGITUDE_INT_GPS[1] = string[33];
 LONGITUDE_INT_GPS[2] = string[34];
 LONGITUDE_INT_GPS[3] = string[35];
 LONGITUDE_INT_GPS[4] = string[36];
 LONGITUDE_INT_GPS[5] = '\0';

 LONGITUDE_FRAC_GPS[0] = string[38];
 LONGITUDE_FRAC_GPS[1] = string[39];
 LONGITUDE_FRAC_GPS[2] = string[40];
 LONGITUDE_FRAC_GPS[3] = string[41];
 LONGITUDE_FRAC_GPS[4] = '0';
 LONGITUDE_FRAC_GPS[5] = '\0';

 N_S_E_W_GPS[0] = '0';
 N_S_E_W_GPS[1] = '0';
 N_S_E_W_GPS[2] = '0';
 if(string[30] == 'S')
 {
 N_S_E_W_GPS[3] = '0';
 }
 else if(string[30] == 'N')
 {
 N_S_E_W_GPS[3] = '1';
 }
 if(string[43] == 'W')
 {
 N_S_E_W_GPS[4] = '1';
 }
 else if(string[43] == 'E')
 {
 N_S_E_W_GPS[4] = '0';
 }
 N_S_E_W_GPS[5] = '\0';

 index_char = 45;
 cnt_gps = 0;
 while(string[index_char++] != ',')
 {
 cnt_gps++;
 }
 switch (cnt_gps)
 {
 case 4: VEL_X100_GPS[0] = '0';
 VEL_X100_GPS[1] = '0';
 VEL_X100_GPS[2] = string[45];
 VEL_X100_GPS[3] = string[47];
 VEL_X100_GPS[4] = string[48];
 VEL_X100_GPS[5] = '\0';
 break;

 case 5: VEL_X100_GPS[0] = '0';
 VEL_X100_GPS[1] = string[45];
 VEL_X100_GPS[2] = string[46];
 VEL_X100_GPS[3] = string[48];
 VEL_X100_GPS[4] = string[49];
 VEL_X100_GPS[5] = '\0';
 break;

 case 6: VEL_X100_GPS[0] = string[45];
 VEL_X100_GPS[1] = string[46];
 VEL_X100_GPS[2] = string[47];
 VEL_X100_GPS[3] = string[49];
 VEL_X100_GPS[4] = string[50];
 VEL_X100_GPS[5] = '\0';
 break;
 }

 index_char2 = index_char;
 cnt_gps2 = 0;
 while(string[index_char2++] != ',')
 {
 cnt_gps2++;
 }
 switch(cnt_gps2)
 {
 case 4: DIRECAO_X100_GPS[0] = '0';
 DIRECAO_X100_GPS[1] = '0';
 DIRECAO_X100_GPS[2] = string[index_char];
 DIRECAO_X100_GPS[3] = string[index_char+2];
 DIRECAO_X100_GPS[4] = string[index_char+3];
 DIRECAO_X100_GPS[5] = '\0';
 break;

 case 5: DIRECAO_X100_GPS[0] = '0';
 DIRECAO_X100_GPS[1] = string[index_char];
 DIRECAO_X100_GPS[2] = string[index_char+1];
 DIRECAO_X100_GPS[3] = string[index_char+3];
 DIRECAO_X100_GPS[4] = string[index_char+4];
 DIRECAO_X100_GPS[5] = '\0';
 break;

 case 6: DIRECAO_X100_GPS[0] = string[index_char];
 DIRECAO_X100_GPS[1] = string[index_char+1];
 DIRECAO_X100_GPS[2] = string[index_char+2];
 DIRECAO_X100_GPS[3] = string[index_char+4];
 DIRECAO_X100_GPS[4] = string[index_char+5];
 DIRECAO_X100_GPS[5] = '\0';
 break;
 }
 index_char3 = index_char2;
 DIA_GPS[0] = '0';
 DIA_GPS[1] = '0';
 DIA_GPS[2] = '0';
 DIA_GPS[3] = string[index_char3];
 DIA_GPS[4] = string[index_char3+1];
 DIA_GPS[5] = '\0';

 MES_GPS[0] = '0';
 MES_GPS[1] = '0';
 MES_GPS[2] = '0';
 MES_GPS[3] = string[index_char3+2];
 MES_GPS[4] = string[index_char3+3];
 MES_GPS[5] = '\0';

 ANO_GPS[0] = '0';
 ANO_GPS[1] = '0';
 ANO_GPS[2] = '0';
 ANO_GPS[3] = string[index_char3+4];
 ANO_GPS[4] = string[index_char3+5];
 ANO_GPS[5] = '\0';

 STATUS_CHECKSUM_GPS[0] = '0';
 STATUS_CHECKSUM_GPS[1] = '1';
 STATUS_CHECKSUM_GPS[2] = '0';
 STATUS_CHECKSUM_GPS[3] = '0';
 STATUS_CHECKSUM_GPS[4] = '0';
 STATUS_CHECKSUM_GPS[5] = '\0';

 res = 1;
 return res;
 }
 else
 {
 res = 2;
 return res;
 }

 }
 else
 {
 res = 0;
 return res;
 }

}
