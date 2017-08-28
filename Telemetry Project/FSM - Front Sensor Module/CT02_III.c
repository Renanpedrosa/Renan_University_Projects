/*
 * Nome do Projeto:
     CT02_bateria
 * Autor:
     Mateus F. Fonseca
 * Versão:
     201108:
       - Versão inicial;
 * Descrição:
     Programa para controle do nó da bateria da telemetria do carro ES05;
 * Configuração de Teste:
     MCU:                        dsPIC3FJ64GP804-E/PT
     Placa do dispositivo:       CT02
     Oscillator:                 HS, 20.00000 MHz
     Módulo externo:             Nenhum.
     SW:                         mikroC PRO for dsPIC30/33 and PIC24

 * NOTAS:

   Configurando o oscilador para saída de 40MHz usando o PLL
   Fin = 20MHz
   Fout = 40MHz
   Fosc = Fin * ( M / (N1 * N2))

   Como
   0.8 < Fref < 8MHz
   100 < Fvco < 200MHz
   Fosc < 80MHz

   N1(2 - 33) = 5
   N2(2,4,8) = 4
   M(2 - 513) = 40


   PLLPRE = N1 - 2 = 0
   PLLPOST = N2/2 - 1 = 1
   PLLDIV = M - 2 = 78

  Logo
  Fosc = Fin * ( 80 / (2 * 4))
  Fosc = Fin * 10

 */


#include <built_in.h>
#include "ECAN_IDs.h"
#include "ECAN_Defs.h"
#include "Inicializacoes_FSM.h"
#include "Funcoes_ADXL.h"
#include "Funcoes_Radio.h"



//Vaiáveis do CAN
 // Definições para Velocidade CAN
 //               //Vel 500 kpbs      //Para 1Mbps usar esses:
 #define SJW      1                   //   4
 #define BRP      4                   //   1
 #define PHSEG1   3                   //   8
 #define PHSEG2   3                   //   6
 #define PROPSEG  1                   //   5

//Vaiáveis do CAN
unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;  // can flags
unsigned int Rx_Data_Len;                                    // received data length in bytes
char RxTx_Data[8];                                           // can rx/tx data buffer
unsigned int Msg_Rcvd;                                               // reception flag

unsigned long Rx_ID;

unsigned int t1, t2;  //Variaveis para medir o tempo entre as interrupções
//Sinais dos Sensores do FSM
unsigned INT_ACCEL_X_FSM;    //Saída X do Acelerômetro interno MMA2202
unsigned INT_ACCEL_Y_FSM;    //Saída Y do Acelerômetro interno MMA2202
unsigned INT_ACCEL_Z_FSM;    //Saída Z do Acelerômetro interno MMA1200
int AdxlX;             //Saída X do acelerômetro ADXL345 conectado dentro do módulo
int AdxlY;             //Saída Y do acelerômetro ADXL345 conectado dentro do módulo
int AdxlZ;             //Saída Z do acelerômetro ADXL345 conectado dentro do módulo
unsigned ADXL_X_FSM;    //Dados que serão enviados do acelerômetro Adxl345
unsigned ADXL_Y_FSM;    //Dados que serão enviados do acelerômetro Adxl345
unsigned ADXL_Z_FSM;    //Dados que serão enviados do acelerômetro Adxl345
unsigned ADXL_POS_NEG_FSM;
unsigned STATUS_ACCEL_FSM;
unsigned BOTAO_1_2_FSM;

unsigned GPIN0_FSM;     //Entrada analógica 0 geral do módulo FSM
unsigned GPIN1_FSM;     //Entrada Rotação 1 (Rodas) do módulo FSM
unsigned GPIN2_FSM;     //Entrada Rotação 2 (Rodas) do módulo FSM
unsigned GPIN3_FSM;     //Entrada Rotação 3 (RPM) do módulo FSM
unsigned GPIN4_FSM;     //Entrada analógica 4 geral do módulo FSM
unsigned GPIN5_FSM;     //Entrada digital 5 geral do módulo FSM
unsigned GPIN6_FSM;     //Entrada analógica 5 geral do módulo FSM


//Sinais dos Sensores do LSM
unsigned GPIN0_LSM;     //Entrada analógica 0 12V do módulo LSM
unsigned GPIN1_LSM;     //Entrada analógica 1 5V do módulo LSM
unsigned GPIN2_LSM;     //Entrada analógica 2 5V do módulo LSM
unsigned GPIN3_LSM;     //Entrada analógica 3 5V do módulo LSM
unsigned GPIN4_LSM;     //Entrada analógica 4 5V do módulo LSM
unsigned GPIN5_LSM;     //Entrada analógica 5 5V do módulo LSM
unsigned ICAN_BUS_LSM;  //Corrente do Barramento CAN
unsigned DIG1_LSM;      //Entrada de rotação
unsigned PGA0_LSM;      //Entradas do PGA. resultado da conversão A/D - 3,3V
unsigned PGA1_LSM;      //
unsigned PGA2_LSM;      //
unsigned PGA3_LSM;      //
unsigned PGA4_LSM;      //
unsigned PGA5_LSM;      //
unsigned PGA6_LSM;      //
char PGA0_Gain_LSM;     // Ganho do PGA no momento da aquisição do canal 0 (CH0)
char PGA1_Gain_LSM;     // Ganho do PGA no momento da aquisição do canal 1 (CH1)
char PGA2_Gain_LSM;     // Ganho do PGA no momento da aquisição do canal 2 (CH2)
char PGA3_Gain_LSM;     // Ganho do PGA no momento da aquisição do canal 3 (CH3)
char PGA4_Gain_LSM;     // Ganho do PGA no momento da aquisição do canal 4 (CH4)
char PGA5_Gain_LSM;     // Ganho do PGA no momento da aquisição do canal 5 (CH5)
char PGA_01_Gain_LSM;   //Ganho do PGA dos canais 0 e 1. No high nibble está o canal 0, no low nibble está o canal 1
char PGA_23_Gain_LSM;   //Ganho do PGA dos canais 2 e 3. No high nibble está o canal 2, no low nibble está o canal 3
char PGA_45_Gain_LSM;   //Ganho do PGA dos canais 4 e 5. No high nibble está o canal 4, no low nibble está o canal 5
unsigned PGA_0123_GAIN_LSM;


//Sinais dos Sensores do BSM
unsigned ANA0_BSM;      //Entrada analógica 0 3,3V do módulo BSM
unsigned ANA1_BSM;      //Entrada analógica 1 3,3V do módulo BSM
unsigned ANA2_BSM;      //Entrada analógica 2 3,3V do módulo BSM
unsigned ANA3_BSM;      //Entrada analógica 3 3,3V do módulo BSM
unsigned ANA4_BSM;      //Entrada analógica 4 5V do módulo BSM
unsigned ANA5_BSM;      //Entrada analógica 5 5V do módulo BSM
unsigned ANA6_BSM;      //Entrada analógica 6 5V do módulo BSM
unsigned ANA7_BSM;      //Entrada analógica 7 5V do módulo BSM
unsigned ANA8_BSM;      //Entrada analógica 8 5V do módulo BSM
unsigned ANA9_BSM;      //Entrada analógica 9 12V do módulo BSM
unsigned ANA10_BSM;     //Entrada analógica 10 5V do módulo BSM
unsigned ANA11_BSM;     //Entrada analógica 11 5V do módulo BSM
unsigned DIG1_BSM;      //Entrada digital 1 geral do módulo BSM
unsigned DIG2_BSM;      //Entrada digital 2 de rotação do módulo BSM
unsigned DIG3_BSM;      //Entrada digital 3 de rotação do módulo BSM
unsigned DIG4_BSM;      //Entrada digital 4 de rotação do módulo BSM
unsigned DIG5_BSM;      //Entrada digital 5 binária do módulo BSM
unsigned DIG6_BSM;      //Entrada digital 6 binária do módulo BSM
unsigned DIG7_BSM;      //Entrada digital 7 binária do módulo BSM
unsigned DIG8_BSM;      //Entrada digital 8 binária do módulo BSM

char LATITUDE_INT_GPS[6];  //Dado da parte inteira da latidude do GPS
char LATITUDE_FRAC_GPS[6]; //Dado da parte fracionaria da latidude do GPS
char LONGITUDE_INT_GPS[6]; //Dado da parte inteira da longitude do GPS
char LONGITUDE_FRAC_GPS[6];//Dado da parte fracionaria da longitude do GPS
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


//Variáveis para uso do GPS
char txt[768];
signed int latitude, longitude;
char *string;
int t=0;
unsigned int tempo_msg;      //Tempo para ter uma mensagem completa
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
int readings[3] = {0, 0, 0};                       // X, Y and Z
long int sumX,sumY,sumZ;
unsigned ready;
unsigned i;

void InitCAN()
{
    //
  //Inicialização do CAN
  //

  /* Clear Interrupt Flags */

        IFS0=0;
        IFS1=0;
        IFS2=0;
        IFS3=0;
        IFS4=0;

  /* Enable ECAN1 Interrupt */

        IEC2bits.C1IE   = 1;                       // enable ECAN1 interrupts

        C1INTEbits.TBIE = 1;                       // enable ECAN1 tx interrupt
        C1INTEbits.RBIE = 1;                       // enable ECAN1 rx interrupt

  Can_Init_Flags = 0;                              //
  Can_Send_Flags = 0;                              // clear flags
  Can_Rcv_Flags  = 0;                              //

  Can_Send_Flags = _ECAN_TX_PRIORITY_0 &           // form value to be used
                   _ECAN_TX_XTD_FRAME &            // with CANSendMessage
                   _ECAN_TX_NO_RTR_FRAME;

  Can_Init_Flags = _ECAN_CONFIG_SAMPLE_THRICE &    // form value to be used
                   _ECAN_CONFIG_PHSEG2_PRG_ON &    // with CANInitialize
                   _ECAN_CONFIG_XTD_MSG &
                   _ECAN_CONFIG_MATCH_MSG_TYPE &
                   _ECAN_CONFIG_LINE_FILTER_OFF;

  //RxTx_Data[0] = 9;                                // set initial data to be sent
  ECAN1DmaChannelInit(0, 1, &ECAN1RxTxRAMBuffer);  // init dma channel 0 for
                                                   // dma to ECAN peripheral transfer
  ECAN1DmaChannelInit(2, 0, &ECAN1RxTxRAMBuffer);  // init dma channel 2 for
                                                   // ECAN peripheral to dma transfer

  ECAN1Initialize(SJW, BRP, PHSEG1, PHSEG2, PROPSEG, Can_Init_Flags);  // initialize ECAN 1Mbps
  ECAN1SetBufferSize(ECAN1RAMBUFFERSIZE);          // set number of rx+tx buffers in DMA RAM

  ECAN1SelectTxBuffers(0x0003);                    // select transmit buffers
                                                   // 0x000F = buffers 0:2 are transmit buffers
  ECAN1SetOperationMode(_ECAN_MODE_CONFIG,0xFF);   // set CONFIGURATION mode

  ECAN1SetMask(_ECAN_MASK_0, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);         // set all mask1 bits to ones
  ECAN1SetMask(_ECAN_MASK_1, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);         // set all mask2 bits to ones
  ECAN1SetMask(_ECAN_MASK_2, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);         // set all mask3 bits to ones
  ECAN1SetFilter(_ECAN_FILTER_0, LSM_ELET_1, _ECAN_MASK_0, _ECAN_RX_BUFFER_2, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  ECAN1SetFilter(_ECAN_FILTER_1, LSM_ELET_2, _ECAN_MASK_0, _ECAN_RX_BUFFER_3, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  ECAN1SetFilter(_ECAN_FILTER_2, LSM_PGA_1, _ECAN_MASK_0, _ECAN_RX_BUFFER_4, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  ECAN1SetFilter(_ECAN_FILTER_3, LSM_PGA_2, _ECAN_MASK_0, _ECAN_RX_BUFFER_5, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  ECAN1SetFilter(_ECAN_FILTER_4, BSM_ANA_1, _ECAN_MASK_0, _ECAN_RX_BUFFER_6, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  ECAN1SetFilter(_ECAN_FILTER_5, BSM_ANA_2, _ECAN_MASK_0, _ECAN_RX_BUFFER_7, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  ECAN1SetFilter(_ECAN_FILTER_6, BSM_ANA_3, _ECAN_MASK_0, _ECAN_RX_BUFFER_8, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  ECAN1SetFilter(_ECAN_FILTER_7, BSM_DIG_1, _ECAN_MASK_0, _ECAN_RX_BUFFER_9, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  ECAN1SetFilter(_ECAN_FILTER_8, BSM_DIG_2, _ECAN_MASK_1, _ECAN_RX_BUFFER_10, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  //ECAN1SetFilter(_ECAN_FILTER_9, BSM_GPS_1, _ECAN_MASK_1, _ECAN_RX_BUFFER_11, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  //ECAN1SetFilter(_ECAN_FILTER_10, BSM_GPS_2, _ECAN_MASK_1, _ECAN_RX_BUFFER_12, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  //ECAN1SetFilter(_ECAN_FILTER_11, BSM_GPS_3, _ECAN_MASK_1, _ECAN_RX_BUFFER_13, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID

                                                                             // assign mask2 to filter10
                                                                                              // assign buffer7 to filter10
/*
  ECAN1SetFilter(_ECAN_FILTER_11, LSM_ELET_1, _ECAN_MASK_2, _ECAN_RX_BUFFER_8, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  ECAN1SetFilter(_ECAN_FILTER_12, LSM_ELET_2, _ECAN_MASK_2, _ECAN_RX_BUFFER_9, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  ECAN1SetFilter(_ECAN_FILTER_13, LSM_PGA_1, _ECAN_MASK_2, _ECAN_RX_BUFFER_10, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  ECAN1SetFilter(_ECAN_FILTER_14, LSM_PGA_2, _ECAN_MASK_2, _ECAN_RX_BUFFER_11, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
 // ECAN1SetFilter(_ECAN_FILTER_15, ID_Temp2, _ECAN_MASK_2, _ECAN_RX_BUFFER_12, _ECAN_CONFIG_XTD_MSG);  // set id of filter10 to 2nd node ID
  */
  ECAN1SetOperationMode(_ECAN_MODE_NORMAL, 0xFF);  // set NORMAL mode
}



void C1Interrupt(void) org 0x005A                            // ECAN event iterrupt
{
     IFS2bits.C1IF = 0;                                   // clear ECAN interrupt flag
     if(C1INTFbits.TBIF) {                                // was it tx interrupt?
         C1INTFbits.TBIF = 0;                             // if yes clear tx interrupt flag
         }
     if(C1INTFbits.RBIF) 
     {                                      // was it rx interrupt?
        //LED = 1;
        C1INTFbits.RBIF = 0;                         // if yes clear rx interrupt flag
        LED = 1;
         }
}

void interrupt_timer1() iv IVT_ADDR_T1INTERRUPT {   // interrupt is generated by Timer1
  T1CON.F15 = 0;                     // Stop Timer 1
  ready = 1;                         // Colocar o flag para enviar os dados pela porta serial
  TMR1 = 0xE795;                      //Valor anterior 0xE795
  //i = 0;                             // reset array counter
  IFS0.F3 = 0;                       // Clear Timer1 interrupt flag
  T1CON.F15 = 1;                     //Começar novamente o Timer1
  }

void interrupt_timer5() iv IVT_ADDR_T5INTERRUPT {   // interrupt is generated by Timer5 - GPS

  T5CONbits.TON = 0;                     // Stop Timer 5
  TMR5 = 0xF447;
  tempo_msg++;
  while(U2STAbits.URXDA == 1)
  {
    LED = 1;
    txt[t++] = U2RXREG;
    if (txt[t-1] == 0)
    {
       t = 0;
    }
    if (t == 768)
    {
       t = 0;
       //LED = 0;
    }
  }
  //t = 0;                             // reset array counter
  if(tempo_msg == 5)
  {
    gps_ready = 1;
    tempo_msg = 0;
    //t = 0;
  }
  T5CONbits.TON = 1;                     // Start Timer 5
  T5IF_bit = 0;                       // Clear Timer5 interrupt flag
}

void U2RXInterrupt(void) iv 0x0050   { // interrupt is generated by UART receive
 // UART_Set_Active(&UART2_Read, &UART2_Write, &UART2_Data_Ready, &UART2_Tx_Idle); // set UART2 active
  LED = 1;
 /*
  txt[t++] = U2RXREG;
  if (txt[t-1] == 0)
    t = 0;
  if (t == 768)
    t = 0; */
/*  T5CON.TON = 0;                     // Stop Timer 5
  TMR5 = 0x3DB0;                     // Timer5 starts counting from 15792 (30ms)
  T5CON.TON = 1;                     // Start Timer 5
  */
  /*
  while(UART2_Data_Ready())
  {
     LED = 1;
     teste = UART2_Read();
     UART1_Write(teste);
     LED = 0;
  } */
 /*while(U2STAbits.URXDA == 1)
   {
       // LED = 1;
        teste = U2RXREG;
        UART1_Write(teste);
        //Delay_ms(20);
        LED = 0;
   } */
  //teste = U2RXREG;
  //UART1_Write(teste);
  
  U2RXIF_bit = 0;                       // Clear UART receive interrupt flag

}

void InputCapture1Int() iv IVT_ADDR_IC1INTERRUPT //RPM
{
  t1=IC1BUF;
  t2=IC1BUF;
  IC1IF_bit=0;
  if(t2>t1)
  GPIN1_FSM = t2-t1;
  else
  GPIN1_FSM = (PR2 - t1) + t2;
}

void InputCapture2Int() iv IVT_ADDR_IC2INTERRUPT //(Velocidade)
{
  t1=IC2BUF;
  t2=IC2BUF;
  IC2IF_bit=0;
  if(t2>t1)
  GPIN2_FSM = t2-t1;
  else
  GPIN2_FSM = (PR2 - t1) + t2;
}

void InputCapture7Int() iv IVT_ADDR_IC7INTERRUPT //RPM
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
  LED = 1;
  InitClock();
  InitPorts();
  InitTimersCapture();
  InitCAN();
  InitMain();
  ready = 0;
  Delay_ms(1000);
  LED = 0;
  
   tempo_msg = 0;
   t = 0;
  //LED = 1;
  while(1)
  {
    U2STA.F1 = 0;                  // Set OERR to 0
    U2STA.F2 = 0;                  // Set FERR to 0
    
    //U1STA.F1 = 0;                  // Set OERR to 0
    //U1STA.F2 = 0;                  // Set FERR to 0
    //LED = 0;
    //Delay_ms(20);

        for( i = 0; i<=3; i++)
        {
        Msg_Rcvd = ECAN1Read(&Rx_ID , RxTx_Data , &Rx_Data_Len, &Can_Rcv_Flags);  // receive message
        if(Msg_Rcvd)
        {
          LED = 1;
          switch(Rx_ID)
          {
            case LSM_ELET_1:
            {
              Hi(ICAN_BUS_LSM) = RxTx_Data[0];
              Lo(ICAN_BUS_LSM) = RxTx_Data[1];
              Hi(GPIN0_LSM) = RxTx_Data[2];
              Lo(GPIN0_LSM) = RxTx_Data[3];
              Hi(GPIN1_LSM) = RxTx_Data[4];
              Lo(GPIN1_LSM) = RxTx_Data[5];
              Hi(GPIN2_LSM) = RxTx_Data[6];
              Lo(GPIN2_LSM) = RxTx_Data[7];
              LED = 1;
              break;
            }
            case LSM_ELET_2:
            {
              Hi(GPIN3_LSM) = RxTx_Data[0];
              Lo(GPIN3_LSM) = RxTx_Data[1];
              Hi(GPIN4_LSM) = RxTx_Data[2];
              Lo(GPIN4_LSM) = RxTx_Data[3];
              Hi(GPIN5_LSM) = RxTx_Data[4];
              Lo(GPIN5_LSM) = RxTx_Data[5];
              Hi(DIG1_LSM) = RxTx_Data[6];
              Lo(DIG1_LSM) = RxTx_Data[7];
              break;
            }
            case LSM_PGA_1:
            {
              Hi(PGA0_LSM) = RxTx_Data[0];
              Lo(PGA0_LSM) = RxTx_Data[1];
              Hi(PGA1_LSM) = RxTx_Data[2];
              Lo(PGA1_LSM) = RxTx_Data[3];
              Hi(PGA2_LSM) = RxTx_Data[4];
              Lo(PGA2_LSM) = RxTx_Data[5];
              Hi(PGA3_LSM) = RxTx_Data[6];
              Lo(PGA3_LSM) = RxTx_Data[7];
              break;
            }
            case LSM_PGA_2:
            {
              Hi(PGA4_LSM) = RxTx_Data[0];
              Lo(PGA4_LSM) = RxTx_Data[1];
              Hi(PGA5_LSM) = RxTx_Data[2];
              Lo(PGA5_LSM) = RxTx_Data[3];
              Hi(PGA_0123_GAIN_LSM) = RxTx_Data[4];
              Lo(PGA_0123_GAIN_LSM) = RxTx_Data[5];
              PGA_45_GAIN_LSM = RxTx_Data[6];
              break;
            }
            /*
            case BSM_ANA_1:
            {
              Hi(ANA0_BSM) = RxTx_Data[0];
              Lo(ANA0_BSM) = RxTx_Data[1];
              Hi(ANA1_BSM) = RxTx_Data[2];
              Lo(ANA1_BSM) = RxTx_Data[3];
              Hi(ANA2_BSM) = RxTx_Data[4];
              Lo(ANA2_BSM) = RxTx_Data[5];
              Hi(ANA3_BSM) = RxTx_Data[6];
              Lo(ANA3_BSM) = RxTx_Data[7];

              break;
            }
            case BSM_ANA_2:
            {
              Hi(ANA4_BSM) = RxTx_Data[0];
              Lo(ANA4_BSM) = RxTx_Data[1];
              Hi(ANA5_BSM) = RxTx_Data[2];
              Lo(ANA5_BSM) = RxTx_Data[3];
              Hi(ANA6_BSM) = RxTx_Data[4];
              Lo(ANA6_BSM) = RxTx_Data[5];
              Hi(ANA7_BSM) = RxTx_Data[6];
              Lo(ANA7_BSM) = RxTx_Data[7];
              break;
            }
            case BSM_ANA_3:
            {
              Hi(ANA8_BSM) = RxTx_Data[0];
              Lo(ANA8_BSM) = RxTx_Data[1];
              Hi(ANA9_BSM) = RxTx_Data[2];
              Lo(ANA9_BSM) = RxTx_Data[3];
              Hi(ANA10_BSM) = RxTx_Data[4];
              Lo(ANA10_BSM) = RxTx_Data[5];
              Hi(ANA11_BSM) = RxTx_Data[6];
              Lo(ANA11_BSM) = RxTx_Data[7];
              break;
            }
            case BSM_DIG_1:
            {
              Hi(DIG1_BSM) = RxTx_Data[0];
              Lo(DIG1_BSM) = RxTx_Data[1];
              Hi(DIG2_BSM) = RxTx_Data[2];
              Lo(DIG2_BSM) = RxTx_Data[3];
              Hi(DIG3_BSM) = RxTx_Data[4];
              Lo(DIG3_BSM) = RxTx_Data[5];
              Hi(DIG4_BSM) = RxTx_Data[6];
              Lo(DIG4_BSM) = RxTx_Data[7];
              break;
            }
            case BSM_DIG_2:
            {
              Hi(DIG5_BSM) = RxTx_Data[0];
              Lo(DIG5_BSM) = RxTx_Data[1];
              Hi(DIG6_BSM) = RxTx_Data[2];
              Lo(DIG6_BSM) = RxTx_Data[3];
              HDOP_X100_BSM = RxTx_Data[4];
              GPS_FIX_BSM = RxTx_Data[5];
              Hi(ALTITUDE_BSM) = RxTx_Data[6];
              Lo(ALTITUDE_BSM) = RxTx_Data[7];
              break;
            }
            case BSM_GPS_1:
            {
              Hi(LATITUDE_INT_BSM) = RxTx_Data[0];
              Lo(LATITUDE_INT_BSM) = RxTx_Data[1];
              Hi(LATITUDE_FRAC_BSM) = RxTx_Data[2];
              Lo(LATITUDE_FRAC_BSM) = RxTx_Data[3];
              Hi(LONGITUDE_INT_BSM) = RxTx_Data[4];
              Lo(LONGITUDE_INT_BSM) = RxTx_Data[5];
              Hi(LONGITUDE_FRAC_BSM) = RxTx_Data[6];
              Lo(LONGITUDE_FRAC_BSM) = RxTx_Data[7];
              break;
            }
            case BSM_GPS_2:
            {
              Hi(N_S_E_W_BSM) = RxTx_Data[0];
              Lo(N_S_E_W_BSM) = RxTx_Data[1];
              Hi(VEL_X100_BSM) = RxTx_Data[2];
              Lo(VEL_X100_BSM) = RxTx_Data[3];
              Hi(DIRECAO_X100_BSM) = RxTx_Data[4];
              Lo(DIRECAO_X100_BSM) = RxTx_Data[5];
              STATUS_GPS_A_V_BSM = RxTx_Data[6];
              CHECKSUM_BSM = RxTx_Data[7];
              break;
            }
            case BSM_GPS_3:
            {
              HORA_BSM = RxTx_Data[0];
              MINUTO_BSM = RxTx_Data[1];
              SEGUNDO_BSM = RxTx_Data[2];
              Hi(MILISEGUNDO_BSM) = RxTx_Data[3];
              Lo(MILISEGUNDO_BSM) = RxTx_Data[4];
              DIA_BSM = RxTx_Data[5];
              MES_BSM = RxTx_Data[6];
              ANO_BSM = RxTx_Data[7];
              break;
            }*/
           }
           //LED = 0;
         }
        }

      //UART2_Read_Text(output, "*", 200);
     // UART1_Write_Text(output);
      /*
      if(t == 700)
      {
        UART2_Write_Text(txt);
        t = 0;
        LED = 0;
      } */
    /*  while(UART1_Data_Ready())
      {
        // LED = 1;
         teste = UART1_Read();
         UART2_Write(teste);
         //UART1_Write(teste);

      }

      */
    
     if(gps_ready == 1)                 // if the data in txt array is ready do
     {
        gps_ready = 0;
        res = GPS_Parse(&txt);
     }

    //LED = 1;
    //Caso tenha dado o tempo, aquisitar as variáveis deste módulo e enviar via CAN. //6250
     if(ready == 1){
      //LED = 0;
      GPIN0_FSM = ADC1_Get_Sample(GPIN_0);    // 0 a 5V  (mistura rica/pobre)
      GPIN4_FSM = ADC1_Get_Sample(GPIN_4);    // 0 a 3,3V
      GPIN5_FSM = RC9_bit;                    // 0/12V Digital
      GPIN6_FSM = ADC1_Get_Sample(GPIN_6);   // 0 a 3,3V
      
      BOTAO_1_2_FSM =  0;

      INT_ACCEL_X_FSM = ADC1_Get_Sample(ACCEL_X);
      INT_ACCEL_Y_FSM = ADC1_Get_Sample(ACCEL_Y);
      INT_ACCEL_Z_FSM = ADC1_Get_Sample(ACCEL_Z);

      ADXL_POS_NEG_FSM = 0;

      ADXL345_Read_XYZ(&values);

      AdxlX = ((int)values[1]<<8)|(int)values[0];
      //The Y value is stored in values[2] and values[3].
      AdxlY = ((int)values[3]<<8)|(int)values[2];
      //The Z value is stored in values[4] and values[5].
      AdxlZ = ((int)values[5]<<8)|(int)values[4];

      if((AdxlX==0)&&(AdxlY==0)&&(AdxlZ==0))
      {

          ADXL345_Init();

          ADXL345_Read_XYZ(&values);

          //The ADXL345 gives 10-bit acceleration values, but they are stored as bytes (8-bits). To get the full value, two bytes must be combined for each axis.
          //The X value is stored in values[0] and values[1].
          AdxlX = ((int)values[1]<<8)|(int)values[0];
          //The Y value is stored in values[2] and values[3].
          AdxlY = ((int)values[3]<<8)|(int)values[2];
          //The Z value is stored in values[4] and values[5].
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


      //Enviando dados pela porta serial. Esta função converte para uma string, para depois enviar para usart utilizando o protocolo descrito no arquivo Datasheet Telemetria CEFAST v3.xlsx
      LED = 0;
      Write_UART_UDATA(ID_FSM_ACCEL1, ADXL_X_FSM, ADXL_Y_FSM, ADXL_Z_FSM, ADXL_POS_NEG_FSM);
      Write_UART_UDATA(ID_FSM_ACCEL2, INT_ACCEL_X_FSM, INT_ACCEL_Y_FSM, INT_ACCEL_Z_FSM, STATUS_ACCEL_FSM);
      Write_UART_UDATA(ID_FSM_GPIO1, GPIN0_FSM, GPIN1_FSM, GPIN2_FSM, GPIN3_FSM);
      Write_UART_UDATA(ID_FSM_GPIO2, GPIN4_FSM, GPIN5_FSM, GPIN6_FSM, BOTAO_1_2_FSM);
      Write_UART_UDATA(ID_LSM_ELET_1, ICAN_BUS_LSM, GPIN0_LSM, GPIN1_LSM, GPIN2_LSM);
      Write_UART_UDATA(ID_LSM_ELET_2, GPIN3_LSM, GPIN4_LSM, GPIN5_LSM, DIG1_LSM);
      Write_UART_UDATA(ID_LSM_PGA_1, PGA0_LSM, PGA1_LSM, PGA2_LSM, PGA3_LSM);
      Write_UART_UDATA(ID_LSM_PGA_2, PGA5_LSM, PGA6_LSM, PGA_0123_GAIN_LSM, PGA_45_GAIN_LSM);
/*      Write_UART_UDATA(ID_BSM_ANA_1, ANA0_BSM, ANA1_BSM, ANA2_BSM, ANA3_BSM);
      Write_UART_UDATA(ID_BSM_ANA_2, ANA4_BSM, ANA5_BSM, ANA6_BSM, ANA7_BSM);
      Write_UART_UDATA(ID_BSM_ANA_3, ANA8_BSM, ANA9_BSM, ANA10_BSM, ANA11_BSM);
      Write_UART_UDATA(ID_BSM_DIG_1, DIG1_BSM, DIG2_BSM, DIG3_BSM, DIG4_BSM);
      Write_UART_UDATA(ID_BSM_DIG_2, DIG5_BSM, DIG6_BSM, DIG7_BSM, DIG8_BSM);   */
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

      /*  UART1_Write_Text(ID_GPS_3);
          UART1_Write_Text(HDOP_X100_GPS);
          UART1_Write(',');
          UART1_Write_Text(ALTITUDE);
          UART1_Write(',');
          UART1_Write_Text("00000");
          UART1_Write(',');
          UART1_Write_Text("00000");
          UART1_Write(';');
          UART1_Write(0X0D);
          UART1_Write(0X0A);
        */
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
          //UART1_Write_Text(string);
         // LED = 0;
          res = 0;
        }
      ready = 0;
      //LED = 1;
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
  
  if(string != 0)                                   // If txt array contains "$GPRMC" string we proceed...
  {
    if((string[7] != ',')&&(string[18] == 'A'))     // if "$GPRMC" NMEA message does not have ',' sign in the 8-th
    {                                                //position it means that tha GPS receiver does not have FIXed position!
                                                   //44
      //$GPRMC,073044.000,A,1956.3776,S,04400.0265,W,0.73,298.61,020213,,,D*6D
      
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
      while(string[index_char++] != ',')  //Contar quando algarismos tem a velocidade
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
      while(string[index_char2++] != ',')  //Contar quando algarismos tem a direção
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
      STATUS_CHECKSUM_GPS[3] = '0';        //string[index_char3+11];
      STATUS_CHECKSUM_GPS[4] = '0';        //string[index_char3+12];
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
    //$GPRMC,183018.000,A,1956.4471,S,04359.9573,W,0.81,074.60,181112,,,A*6B
}