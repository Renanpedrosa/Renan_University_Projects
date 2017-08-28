#line 1 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT01 - Medidor Bateria/CT01/CT01.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for dspic/include/built_in.h"
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct01 - medidor bateria/ct01/ecan_ids.h"








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
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct01 - medidor bateria/ct01/inicializacoes_lsm.h"
#line 44 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct01 - medidor bateria/ct01/inicializacoes_lsm.h"
unsigned GPIN0;
unsigned GPIN1;
unsigned GPIN2;
unsigned GPIN3;
unsigned GPIN4;
unsigned GPIN5;
unsigned ICAN_BUS;
unsigned DIG1;
unsigned PGA0;
unsigned PGA1;
unsigned PGA2;
unsigned PGA3;
unsigned PGA4;
unsigned PGA5;


char PGA0_Gain;
char PGA1_Gain;
char PGA2_Gain;
char PGA3_Gain;
char PGA4_Gain;
char PGA5_Gain;


char PGA_01_Gain;
char PGA_23_Gain;
char PGA_45_Gain;


void InitClock();
void InitPorts();
void InitTimersCapture();
void InitCAN();
void InitMain();
#line 1 "c:/users/renan/documents/my dropbox/fórmula eng 3/engenharia 3/ct01 - medidor bateria/ct01/pga_drivers_lsm.h"


void PGA_Set_Gain(char ganho);
void PGA_Set_Channel(char canal);
#line 61 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT01 - Medidor Bateria/CT01/CT01.c"
int OSCCON_LED;


extern unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;
extern unsigned int Rx_Data_Len;
extern char RxTx_Data[8];
extern char Msg_Rcvd;
extern unsigned long Rx_ID;

unsigned t1,t2;

unsigned contagem;

unsigned SuspOvr[128];


void InputCapture1Int() iv IVT_ADDR_IC1INTERRUPT
{
 t1=IC1BUF;
 t2=IC1BUF;
 IC1IF_bit=0;
 if(t2>t1)
 DIG1 = t2-t1;
 else
 DIG1 = (PR2 - t1) + t2;
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
  LATA8_bit  = 1;
 InitClock();
 InitPorts();
 InitTimersCapture();
 InitCAN();
 InitMain();
  LATA8_bit  = 0;

 Delay_ms(100);
  LATA8_bit  = 1;
 Delay_ms(1000);
  LATA8_bit  = 0;

 Can_Send_Flags = _ECAN_TX_PRIORITY_0 &
 _ECAN_TX_XTD_FRAME &
 _ECAN_TX_NO_RTR_FRAME;
 Delay_ms(100);

 while(1)
 {
#line 128 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT01 - Medidor Bateria/CT01/CT01.c"
 contagem ++;
 if (contagem >=14)
 {
 contagem = 8;
 }
 VDelay_ms(contagem);


 ICAN_BUS = ADC1_Get_Sample( 6 );
 GPIN0 = ADC1_Get_Sample( 0 );
 GPIN1 = ADC1_Get_Sample( 1 );
 GPIN2 = ADC1_Get_Sample( 2 );
 GPIN3 = ADC1_Get_Sample( 3 );
 GPIN4 = ADC1_Get_Sample( 4 );
 GPIN5 = ADC1_Get_Sample( 5 );


 PGA_Set_Channel( 0x00 );
 PGA0 = ADC1_Get_Sample( 9 );
 PGA0_Gain = 0;

 PGA_Set_Channel( 0x01 );
 PGA1 = ADC1_Get_Sample( 9 );
 PGA1_Gain = 0;

 PGA_Set_Channel( 0x02 );
 PGA2 = ADC1_Get_Sample( 9 );
 PGA2_Gain = 0;

 PGA_Set_Channel( 0x03 );
 PGA3 = ADC1_Get_Sample( 9 );
 PGA3_Gain = 0;

 PGA_Set_Channel( 0x04 );
 PGA4 = ADC1_Get_Sample( 9 );
 PGA4_Gain = 0;

 PGA_Set_Channel( 0x05 );
 PGA5 = ADC1_Get_Sample( 9 );
 PGA5_Gain = 0;








 PGA_01_Gain = 1;
 PGA_23_Gain = 1;
 PGA_45_Gain = 1;


  LATA8_bit  = 0;

 RxTx_Data[0] =  ((char *)&ICAN_BUS)[1] ;
 RxTx_Data[1] =  ((char *)&ICAN_BUS)[0] ;
 RxTx_Data[2] =  ((char *)&GPIN0)[1] ;
 RxTx_Data[3] =  ((char *)&GPIN0)[0] ;
 RxTx_Data[4] =  ((char *)&GPIN1)[1] ;
 RxTx_Data[5] =  ((char *)&GPIN1)[0] ;
 RxTx_Data[6] =  ((char *)&GPIN2)[1] ;
 RxTx_Data[7] =  ((char *)&GPIN2)[0] ;
 ECAN1Write(LSM_ELET_1, RxTx_Data, 8, Can_Send_Flags);


 RxTx_Data[0] =  ((char *)&GPIN3)[1] ;
 RxTx_Data[1] =  ((char *)&GPIN3)[0] ;
 RxTx_Data[2] =  ((char *)&GPIN4)[1] ;
 RxTx_Data[3] =  ((char *)&GPIN4)[0] ;
 RxTx_Data[4] =  ((char *)&GPIN5)[1] ;
 RxTx_Data[5] =  ((char *)&GPIN5)[0] ;
 RxTx_Data[6] =  ((char *)&DIG1)[1] ;
 RxTx_Data[7] =  ((char *)&DIG1)[0] ;
 ECAN1Write(LSM_ELET_2, RxTx_Data, 8, Can_Send_Flags);


 RxTx_Data[0] =  ((char *)&PGA0)[1] ;
 RxTx_Data[1] =  ((char *)&PGA0)[0] ;
 RxTx_Data[2] =  ((char *)&PGA1)[1] ;
 RxTx_Data[3] =  ((char *)&PGA1)[0] ;
 RxTx_Data[4] =  ((char *)&PGA2)[1] ;
 RxTx_Data[5] =  ((char *)&PGA2)[0] ;
 RxTx_Data[6] =  ((char *)&PGA3)[1] ;
 RxTx_Data[7] =  ((char *)&PGA3)[0] ;
 ECAN1Write(LSM_PGA_1, RxTx_Data, 8, Can_Send_Flags);



 RxTx_Data[0] =  ((char *)&PGA4)[1] ;
 RxTx_Data[1] =  ((char *)&PGA4)[0] ;
 RxTx_Data[2] =  ((char *)&PGA5)[1] ;
 RxTx_Data[3] =  ((char *)&PGA5)[0] ;
 RxTx_Data[4] = PGA_01_Gain;
 RxTx_Data[5] = PGA_23_Gain;
 RxTx_Data[6] = PGA_45_Gain;
 ECAN1Write(LSM_PGA_2, RxTx_Data, 7, Can_Send_Flags);







 }
}
