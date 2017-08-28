/*
 * Nome do Projeto:
     Back Sesnor Module
 * Autor:
     Renan Pedrosa
 * Versão:
     2012 11 15:
       - Versão inicial;
 * Descrição:
     Acelerometro
 * Configuração de Teste:
     MCU:                        dsPIC3FJ64GP804-E/PT
     Placa do dispositivo:       CT01
     Oscillator:                 HS, 16.00000 MHz
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
 #include "Inicializacoes_BSM.h"
 #include "__Lib_ECAN1_Defs.h"
 

 //
 // Definições para Velocidade CAN
 //               //Vel 500 kpbs      //Para 1Mbps usar esses:
 #define SJW      1                   //   4
 #define BRP      4                   //   1
 #define PHSEG1   3                   //   8
 #define PHSEG2   3                   //   6
 #define PROPSEG  1                   //   5

//Variáveis do CAN
unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;  // can flags
unsigned int Rx_Data_Len;                                    // received data length in bytes
char RxTx_Data[8];                                           // can rx/tx data buffer
char Msg_Rcvd;                                               // reception flag
unsigned long Rx_ID;

int OSCCON_LED;



//Variáveis de input capture
unsigned t1, t2; //Variáveis para subtrair os tempos do input capture


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
unsigned LATITUDE_INT_BSM;  //Dado da parte inteira da latidude do GPS
unsigned LATITUDE_FRAC_BSM; //Dado da parte fracionaria da latidude do GPS
unsigned LONGITUDE_INT_BSM; //Dado da parte inteira da longitude do GPS
unsigned LONGITUDE_FRAC_BSM;//Dado da parte fracionaria da longitude do GPS
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
 /* Clear Interrupt Flags */

        IFS0=0;
        IFS1=0;
        IFS2=0;
        IFS3=0;
        IFS4=0;

  /* Enable ECAN1 Interrupt */

        IEC2bits.C1IE   = 1;                       // enable ECAN1 interrupt
        C1INTEbits.TBIE = 1;                       // enable ECAN1 tx interrupt
        C1INTEbits.RBIE = 1;                       // enable ECAN1 rx interrupt

  Can_Init_Flags = 0;                              //
  Can_Send_Flags = 0;                              // clear flags
  Can_Rcv_Flags  = 0;                              //

  Can_Send_Flags = _ECAN_TX_PRIORITY_1 &           // form value to be used
                   _ECAN_TX_XTD_FRAME &            // with CANSendMessage
                   _ECAN_TX_NO_RTR_FRAME;

  Can_Init_Flags = _ECAN_CONFIG_SAMPLE_THRICE &    // form value to be used
                   _ECAN_CONFIG_PHSEG2_PRG_ON &    // with CANInitialize
                   _ECAN_CONFIG_XTD_MSG &
                   _ECAN_CONFIG_MATCH_MSG_TYPE &
                   _ECAN_CONFIG_LINE_FILTER_OFF;

  ECAN1DmaChannelInit(0, 1, &ECAN1RxTxRAMBuffer);  // init dma channel 0 for
                                                   // dma to ECAN peripheral transfer
  ECAN1DmaChannelInit(2, 0, &ECAN1RxTxRAMBuffer);  // init dma channel 2 for
                                                   // ECAN peripheral to dma transfer
  ECAN1Initialize(SJW, BRP, PHSEG1, PHSEG2, PROPSEG, Can_Init_Flags);  // initialize ECAN 1Mbps
  ECAN1SetBufferSize(ECAN1RAMBUFFERSIZE);          // set number of rx+tx buffers in DMA RAM

  ECAN1SelectTxBuffers(0x00FF);                    // select transmit buffers
                                                   // 0x0FFF = buffers 0:11 are transmit buffers
  ECAN1SetOperationMode(_ECAN_MODE_CONFIG,0xFF);   // set CONFIGURATION mode

  ECAN1SetMask(_ECAN_MASK_0, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask1 bits to ones
  ECAN1SetMask(_ECAN_MASK_1, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask2 bits to ones
  ECAN1SetMask(_ECAN_MASK_2, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask3 bits to ones

  //ECAN1SetFilter(_ECAN_FILTER_10,FSM_CTRL, _ECAN_MASK_2, _ECAN_RX_BUFFER_7, _ECAN_CONFIG_XTD_MSG); // set id of filter10 to 1st node ID

                                                                                                 // assign buffer7 to filter10
  ECAN1SetOperationMode(_ECAN_MODE_NORMAL,0xFF);   // set NORMAL mode
}
  /*
void interrupt_uart1_rx() iv IVT_ADDR_U1RXINTERRUPT  { // interrupt is generated by UART receive
  txt[i++] = Uart1_Read();
  if (txt[i-1] == 0)
    i = 0;
  if (i == 30)
    i = 0;
  T1CON.F15 = 0;                     // Stop Timer 1
  TMR1 = 0x3CB0;                     // Timer1 starts counting from 15536
  T1CON.F15 = 1;                     // Start Timer 1
  IFS1.F8 = 0;                       // Clear UART receive interrupt flag
  IFS0.U1RXIF = 0;                   // Clear UART receive interrupt flag

}
   */
void InputCapture1Int() iv IVT_ADDR_IC1INTERRUPT //RPM
{
  t1=IC1BUF;
  t2=IC1BUF;
  IC1IF_bit=0;
  if(t2>t1)
  DIG2_BSM = t2-t1;
  else
  DIG2_BSM = (PR3 - t1) + t2;
}

void InputCapture2Int() iv IVT_ADDR_IC2INTERRUPT //(Velocidade)
{
  t1=IC2BUF;
  t2=IC2BUF;
  IC2IF_bit=0;
  if(t2>t1)
  DIG3_BSM = t2-t1;
  else
  DIG3_BSM = (PR2 - t1) + t2;
}

void InputCapture7Int() iv IVT_ADDR_IC7INTERRUPT //RPM
{
  t1=IC7BUF;
  t2=IC7BUF;
  IC7IF_bit=0;
  if(t2>t1)
  DIG4_BSM = t2-t1;
  else
  DIG4_BSM = (PR3 - t1) + t2;
}

void C1Interrupt(void) org 0x005A                            // ECAN event iterrupt
{

        IFS2bits.C1IF = 0;                                   // clear ECAN interrupt flag
        if(C1INTFbits.TBIF) {                                // was it tx interrupt?
        C1INTFbits.TBIF = 0;                             // if yes clear tx interrupt flag
        LED1 = 1;
  }

  if(C1INTFbits.RBIF) {                                      // was it rx interrupt?
                C1INTFbits.RBIF = 0;                         // if yes clear rx interrupt flag
        }
}

void main()
{

  
  InitPorts();
  InitClock();

  InitTimersCapture();
  InitCAN();
  LED1 = 1;
  //InitMain();
  //UART2_Init(19200);             // Initialize UART1 module at 19200 bps

  Delay_ms(1000);
  LED1 = 0;
  contagem = 14;

  while(1)
  {

      //contagem = rand();
      //contagem = contagem/2500;
      contagem --;
      if (contagem == 1)
      {
       contagem = 14;
      }
      VDelay_ms(contagem);
      
      LED1 = 0;
      
      ANA4_BSM =  ADC1_Read(ANA_4);
      ANA5_BSM =  ADC1_Read(ANA_5);
      ANA6_BSM =  ADC1_Read(ANA_6);
      ANA7_BSM =  ADC1_Read(ANA_7);
      
      ANA0_BSM =  ADC1_Read(ANA_0);
      ANA1_BSM =  ADC1_Read(ANA_1);
      ANA2_BSM =  ADC1_Read(ANA_2);
      ANA3_BSM =  ADC1_Read(ANA_3);


      ANA8_BSM =  ADC1_Read(ANA_8);
      ANA9_BSM =  ADC1_Read(ANA_9);
      ANA10_BSM =  ADC1_Read(ANA_10);
      ANA11_BSM =  ADC1_Read(ANA_11);
      
      DIG1_BSM = DIG_1;
      DIG5_BSM = DIG_5;
      DIG6_BSM = DIG_6;
      DIG8_BSM = DIG_8;
      DIG7_BSM = DIG_7;
      //DIG2,3,4 são entradas de rotação, sua atualização ocorre na interrupção

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

      //Enviando mensagens via CAN
      RxTx_Data[0] = Hi(ANA0_BSM);
      RxTx_Data[1] = Lo(ANA0_BSM);
      RxTx_Data[2] = Hi(ANA1_BSM);
      RxTx_Data[3] = Lo(ANA1_BSM);
      RxTx_Data[4] = Hi(ANA2_BSM);
      RxTx_Data[5] = Lo(ANA2_BSM);
      RxTx_Data[6] = Hi(ANA3_BSM);
      RxTx_Data[7] = Lo(ANA3_BSM);
      ECAN1Write(BSM_ANA_1, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados

      
      //Enviando mensagens via CAN
      RxTx_Data[0] = Hi(ANA4_BSM);
      RxTx_Data[1] = Lo(ANA4_BSM);
      RxTx_Data[2] = Hi(ANA5_BSM);
      RxTx_Data[3] = Lo(ANA5_BSM);
      RxTx_Data[4] = Hi(ANA6_BSM);
      RxTx_Data[5] = Lo(ANA6_BSM);
      RxTx_Data[6] = Hi(ANA7_BSM);
      RxTx_Data[7] = Lo(ANA7_BSM);
      ECAN1Write(BSM_ANA_2, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados

      //Enviando mensagens via CAN
      RxTx_Data[0] = Hi(ANA8_BSM);
      RxTx_Data[1] = Lo(ANA8_BSM);
      RxTx_Data[2] = Hi(ANA9_BSM);
      RxTx_Data[3] = Lo(ANA9_BSM);
      RxTx_Data[4] = Hi(ANA10_BSM);
      RxTx_Data[5] = Lo(ANA10_BSM);
      RxTx_Data[6] = Hi(ANA11_BSM);
      RxTx_Data[7] = Lo(ANA11_BSM);
      ECAN1Write(BSM_ANA_3, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados

      
      //Enviando mensagens via CAN
      RxTx_Data[0] = Hi(DIG1_BSM);
      RxTx_Data[1] = Lo(DIG1_BSM);
      RxTx_Data[2] = Hi(DIG2_BSM);
      RxTx_Data[3] = Lo(DIG2_BSM);
      RxTx_Data[4] = Hi(DIG3_BSM);
      RxTx_Data[5] = Lo(DIG3_BSM);
      RxTx_Data[6] = Hi(DIG4_BSM);
      RxTx_Data[7] = Lo(DIG4_BSM);
      ECAN1Write(BSM_DIG_1, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados

      //Enviando mensagens via CAN
      RxTx_Data[0] = Hi(DIG5_BSM);
      RxTx_Data[1] = Lo(DIG5_BSM);
      RxTx_Data[2] = Hi(DIG6_BSM);
      RxTx_Data[3] = Lo(DIG6_BSM);
      RxTx_Data[4] = HDOP_X100_BSM;
      RxTx_Data[5] = GPS_FIX_BSM;
      RxTx_Data[6] = Hi(ALTITUDE_BSM);
      RxTx_Data[7] = Lo(ALTITUDE_BSM);
      ECAN1Write(BSM_DIG_2, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados

            //Enviando mensagens via CAN
      RxTx_Data[0] = Hi(LATITUDE_INT_BSM);
      RxTx_Data[1] = Lo(LATITUDE_INT_BSM);
      RxTx_Data[2] = Hi(LATITUDE_FRAC_BSM);
      RxTx_Data[3] = Lo(LATITUDE_FRAC_BSM);
      RxTx_Data[4] = Hi(LONGITUDE_INT_BSM);
      RxTx_Data[5] = Lo(LONGITUDE_INT_BSM);
      RxTx_Data[6] = Hi(LONGITUDE_FRAC_BSM);
      RxTx_Data[7] = Lo(LONGITUDE_FRAC_BSM);
      ECAN1Write(BSM_GPS_1, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados

      RxTx_Data[0] = NORTH_SOUTH_BSM;
      RxTx_Data[1] = EAST_WEST_BSM;
      RxTx_Data[2] = Hi(VEL_X100_BSM);
      RxTx_Data[3] = Lo(VEL_X100_BSM);
      RxTx_Data[4] = Hi(DIRECAO_X100_BSM);
      RxTx_Data[5] = Lo(DIRECAO_X100_BSM);
      RxTx_Data[6] = STATUS_GPS_A_V_BSM;
      RxTx_Data[7] = CHECKSUM_BSM;
      ECAN1Write(BSM_GPS_2, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados

      RxTx_Data[0] = HORA_BSM;
      RxTx_Data[1] = MINUTO_BSM;
      RxTx_Data[2] = SEGUNDO_BSM;
      RxTx_Data[3] = Hi(MILISEGUNDO_BSM);
      RxTx_Data[4] = Lo(MILISEGUNDO_BSM);
      RxTx_Data[5] = DIA_BSM;
      RxTx_Data[6] = MES_BSM;
      RxTx_Data[7] = ANO_BSM;
      ECAN1Write(BSM_GPS_3, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados

  }
  
}