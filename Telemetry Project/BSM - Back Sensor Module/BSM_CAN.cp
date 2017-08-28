#line 1 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT03 - Backnode/Programa BSM/BSM_CAN.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for dspic/include/built_in.h"
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct03 - backnode/programa bsm/ecan_ids.h"







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
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct03 - backnode/programa bsm/inicializacoes_bsm.h"
#line 48 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct03 - backnode/programa bsm/inicializacoes_bsm.h"
void InitClock();
void InitPorts();
void InitCAN();
void InitTimersCapture();
void InitMain();
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct03 - backnode/programa bsm/__lib_ecan1_defs.h"
#line 13 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct03 - backnode/programa bsm/__lib_ecan1_defs.h"
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
#line 57 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct03 - backnode/programa bsm/__lib_ecan1_defs.h"
unsigned dma ECAN1RamStartAddress = 0x4000;

__RxTxBuffer dma ECAN1RxTxRAMBuffer[ 16 ] absolute 0x4000;
#line 61 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT03 - Backnode/Programa BSM/BSM_CAN.c"
unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;
unsigned int Rx_Data_Len;
char RxTx_Data[8];
char Msg_Rcvd;
unsigned long Rx_ID;

int OSCCON_LED;




unsigned t1, t2;



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
unsigned LATITUDE_INT_BSM;
unsigned LATITUDE_FRAC_BSM;
unsigned LONGITUDE_INT_BSM;
unsigned LONGITUDE_FRAC_BSM;
unsigned NORTH_SOUTH_BSM;
unsigned EAST_WEST_BSM;
unsigned N_S_E_W_BSM;
unsigned STATUS_GPS_A_V_BSM;
unsigned GPS_FIX_BSM;
unsigned CHECKSUM_BSM;
unsigned STATUS_CHECKSUM_BSM;
unsigned HORA_BSM;
unsigned MINUTO_BSM;
unsigned SEGUNDO_BSM;
unsigned MILISEGUNDO_BSM;
unsigned DIA_BSM;
unsigned MES_BSM;
unsigned ANO_BSM;
unsigned VEL_X100_BSM;
unsigned DIRECAO_X100_BSM;
unsigned HDOP_X100_BSM;
unsigned ALTITUDE_BSM;

char txt[30];
char inclin[6];
unsigned ready;
unsigned i;
char *string;
unsigned i2;

unsigned contagem;

unsigned SuspOvr[128];

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

 Can_Send_Flags = _ECAN_TX_PRIORITY_1 &
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
#line 195 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT03 - Backnode/Programa BSM/BSM_CAN.c"
void InputCapture1Int() iv IVT_ADDR_IC1INTERRUPT
{
 t1=IC1BUF;
 t2=IC1BUF;
 IC1IF_bit=0;
 if(t2>t1)
 DIG2_BSM = t2-t1;
 else
 DIG2_BSM = (PR3 - t1) + t2;
}

void InputCapture2Int() iv IVT_ADDR_IC2INTERRUPT
{
 t1=IC2BUF;
 t2=IC2BUF;
 IC2IF_bit=0;
 if(t2>t1)
 DIG3_BSM = t2-t1;
 else
 DIG3_BSM = (PR2 - t1) + t2;
}

void InputCapture7Int() iv IVT_ADDR_IC7INTERRUPT
{
 t1=IC7BUF;
 t2=IC7BUF;
 IC7IF_bit=0;
 if(t2>t1)
 DIG4_BSM = t2-t1;
 else
 DIG4_BSM = (PR3 - t1) + t2;
}

void C1Interrupt(void) org 0x005A
{

 IFS2bits.C1IF = 0;
 if(C1INTFbits.TBIF) {
 C1INTFbits.TBIF = 0;
  LATA8_bit  = 1;
 }

 if(C1INTFbits.RBIF) {
 C1INTFbits.RBIF = 0;
 }
}

void main()
{


 InitPorts();
 InitClock();

 InitTimersCapture();
 InitCAN();
  LATA8_bit  = 1;



 Delay_ms(1000);
  LATA8_bit  = 0;
 contagem = 14;

 while(1)
 {



 contagem --;
 if (contagem == 1)
 {
 contagem = 14;
 }
 VDelay_ms(contagem);

  LATA8_bit  = 0;

 ANA4_BSM = ADC1_Read( 4 );
 ANA5_BSM = ADC1_Read( 3 );
 ANA6_BSM = ADC1_Read( 2 );
 ANA7_BSM = ADC1_Read( 1 );

 ANA0_BSM = ADC1_Read( 8 );
 ANA1_BSM = ADC1_Read( 7 );
 ANA2_BSM = ADC1_Read( 6 );
 ANA3_BSM = ADC1_Read( 5 );


 ANA8_BSM = ADC1_Read( 0 );
 ANA9_BSM = ADC1_Read( 9 );
 ANA10_BSM = ADC1_Read( 11 );
 ANA11_BSM = ADC1_Read( 10 );

 DIG1_BSM =  RB11_bit ;
 DIG5_BSM =  RB4_bit ;
 DIG6_BSM =  RA10_bit ;
 DIG8_BSM =  RA7_bit ;
 DIG7_BSM =  RB7_bit ;


 LATITUDE_INT_BSM = 0;
 LATITUDE_FRAC_BSM = 0;
 LONGITUDE_INT_BSM = 0;
 LONGITUDE_FRAC_BSM = 0;
 NORTH_SOUTH_BSM = 0;
 EAST_WEST_BSM = 0;
 VEL_X100_BSM = 0;
 DIRECAO_X100_BSM = 0;
 STATUS_GPS_A_V_BSM = 0;
 CHECKSUM_BSM = 0;

 HORA_BSM = 0;
 MINUTO_BSM = 0;
 SEGUNDO_BSM = 0;
 MILISEGUNDO_BSM = 0;
 DIA_BSM = 0;
 MES_BSM = 0;
 ANO_BSM = 0;

 HDOP_X100_BSM = 0;
 GPS_FIX_BSM = 0;
 ALTITUDE_BSM = 0;


 RxTx_Data[0] =  ((char *)&ANA0_BSM)[1] ;
 RxTx_Data[1] =  ((char *)&ANA0_BSM)[0] ;
 RxTx_Data[2] =  ((char *)&ANA1_BSM)[1] ;
 RxTx_Data[3] =  ((char *)&ANA1_BSM)[0] ;
 RxTx_Data[4] =  ((char *)&ANA2_BSM)[1] ;
 RxTx_Data[5] =  ((char *)&ANA2_BSM)[0] ;
 RxTx_Data[6] =  ((char *)&ANA3_BSM)[1] ;
 RxTx_Data[7] =  ((char *)&ANA3_BSM)[0] ;
 ECAN1Write(BSM_ANA_1, RxTx_Data, 8, Can_Send_Flags);



 RxTx_Data[0] =  ((char *)&ANA4_BSM)[1] ;
 RxTx_Data[1] =  ((char *)&ANA4_BSM)[0] ;
 RxTx_Data[2] =  ((char *)&ANA5_BSM)[1] ;
 RxTx_Data[3] =  ((char *)&ANA5_BSM)[0] ;
 RxTx_Data[4] =  ((char *)&ANA6_BSM)[1] ;
 RxTx_Data[5] =  ((char *)&ANA6_BSM)[0] ;
 RxTx_Data[6] =  ((char *)&ANA7_BSM)[1] ;
 RxTx_Data[7] =  ((char *)&ANA7_BSM)[0] ;
 ECAN1Write(BSM_ANA_2, RxTx_Data, 8, Can_Send_Flags);


 RxTx_Data[0] =  ((char *)&ANA8_BSM)[1] ;
 RxTx_Data[1] =  ((char *)&ANA8_BSM)[0] ;
 RxTx_Data[2] =  ((char *)&ANA9_BSM)[1] ;
 RxTx_Data[3] =  ((char *)&ANA9_BSM)[0] ;
 RxTx_Data[4] =  ((char *)&ANA10_BSM)[1] ;
 RxTx_Data[5] =  ((char *)&ANA10_BSM)[0] ;
 RxTx_Data[6] =  ((char *)&ANA11_BSM)[1] ;
 RxTx_Data[7] =  ((char *)&ANA11_BSM)[0] ;
 ECAN1Write(BSM_ANA_3, RxTx_Data, 8, Can_Send_Flags);



 RxTx_Data[0] =  ((char *)&DIG1_BSM)[1] ;
 RxTx_Data[1] =  ((char *)&DIG1_BSM)[0] ;
 RxTx_Data[2] =  ((char *)&DIG2_BSM)[1] ;
 RxTx_Data[3] =  ((char *)&DIG2_BSM)[0] ;
 RxTx_Data[4] =  ((char *)&DIG3_BSM)[1] ;
 RxTx_Data[5] =  ((char *)&DIG3_BSM)[0] ;
 RxTx_Data[6] =  ((char *)&DIG4_BSM)[1] ;
 RxTx_Data[7] =  ((char *)&DIG4_BSM)[0] ;
 ECAN1Write(BSM_DIG_1, RxTx_Data, 8, Can_Send_Flags);


 RxTx_Data[0] =  ((char *)&DIG5_BSM)[1] ;
 RxTx_Data[1] =  ((char *)&DIG5_BSM)[0] ;
 RxTx_Data[2] =  ((char *)&DIG6_BSM)[1] ;
 RxTx_Data[3] =  ((char *)&DIG6_BSM)[0] ;
 RxTx_Data[4] = HDOP_X100_BSM;
 RxTx_Data[5] = GPS_FIX_BSM;
 RxTx_Data[6] =  ((char *)&ALTITUDE_BSM)[1] ;
 RxTx_Data[7] =  ((char *)&ALTITUDE_BSM)[0] ;
 ECAN1Write(BSM_DIG_2, RxTx_Data, 8, Can_Send_Flags);


 RxTx_Data[0] =  ((char *)&LATITUDE_INT_BSM)[1] ;
 RxTx_Data[1] =  ((char *)&LATITUDE_INT_BSM)[0] ;
 RxTx_Data[2] =  ((char *)&LATITUDE_FRAC_BSM)[1] ;
 RxTx_Data[3] =  ((char *)&LATITUDE_FRAC_BSM)[0] ;
 RxTx_Data[4] =  ((char *)&LONGITUDE_INT_BSM)[1] ;
 RxTx_Data[5] =  ((char *)&LONGITUDE_INT_BSM)[0] ;
 RxTx_Data[6] =  ((char *)&LONGITUDE_FRAC_BSM)[1] ;
 RxTx_Data[7] =  ((char *)&LONGITUDE_FRAC_BSM)[0] ;
 ECAN1Write(BSM_GPS_1, RxTx_Data, 8, Can_Send_Flags);

 RxTx_Data[0] = NORTH_SOUTH_BSM;
 RxTx_Data[1] = EAST_WEST_BSM;
 RxTx_Data[2] =  ((char *)&VEL_X100_BSM)[1] ;
 RxTx_Data[3] =  ((char *)&VEL_X100_BSM)[0] ;
 RxTx_Data[4] =  ((char *)&DIRECAO_X100_BSM)[1] ;
 RxTx_Data[5] =  ((char *)&DIRECAO_X100_BSM)[0] ;
 RxTx_Data[6] = STATUS_GPS_A_V_BSM;
 RxTx_Data[7] = CHECKSUM_BSM;
 ECAN1Write(BSM_GPS_2, RxTx_Data, 8, Can_Send_Flags);

 RxTx_Data[0] = HORA_BSM;
 RxTx_Data[1] = MINUTO_BSM;
 RxTx_Data[2] = SEGUNDO_BSM;
 RxTx_Data[3] =  ((char *)&MILISEGUNDO_BSM)[1] ;
 RxTx_Data[4] =  ((char *)&MILISEGUNDO_BSM)[0] ;
 RxTx_Data[5] = DIA_BSM;
 RxTx_Data[6] = MES_BSM;
 RxTx_Data[7] = ANO_BSM;
 ECAN1Write(BSM_GPS_3, RxTx_Data, 8, Can_Send_Flags);

 }

}
