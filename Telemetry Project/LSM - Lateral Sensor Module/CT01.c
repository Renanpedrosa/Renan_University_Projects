/*
 * Nome do Projeto:
     Acelerometro
 * Autor:
     Willian Daniel Menezes Xavier
 * Versão:
     201203:
       - Versão inicial;
 * Descrição:
     Acelerometro
 * Configuração de Teste:
     MCU:                        dsPIC3FJ64GP804-E/PT
     Placa do dispositivo:       CT01
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
 #include "Inicializacoes_LSM.h"
 #include "PGA_Drivers_LSM.h"






 #define CR 0x0D   //Carriage return: posiciona o cursor no início da linha
 #define LF 0x0A   //Linefeed: equivalente a pressionar ENTER em um editor


 
int OSCCON_LED;

//Variáveis do CAN - Usados para fazer o exemplo de comunicação CAN funcionar.
extern unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;  // can flags
extern unsigned int Rx_Data_Len;                                    // received data length in bytes
extern char RxTx_Data[8];                                           // can rx/tx data buffer
extern char Msg_Rcvd;                                               // reception flag
extern unsigned long Rx_ID;

unsigned t1,t2;

unsigned contagem;

unsigned SuspOvr[128];

//Retirado da página 9 do Manual do Input Capture do dsPIC33F - Section 12. Input Capture
void InputCapture1Int() iv IVT_ADDR_IC1INTERRUPT //Roda transmissão ou outra roda
{
  t1=IC1BUF;
  t2=IC1BUF;
  IC1IF_bit=0;
  if(t2>t1)
  DIG1 = t2-t1;
  else
  DIG1 = (PR2 - t1) + t2;
}

void C1Interrupt(void) org 0x005A                            // ECAN event iterrupt
{

        IFS2bits.C1IF = 0;                                   // clear ECAN interrupt flag
        if(C1INTFbits.TBIF) {                                // was it tx interrupt?
            C1INTFbits.TBIF = 0;                             // if yes clear tx interrupt flag
            LED = 1;
  }

  if(C1INTFbits.RBIF) {                                      // was it rx interrupt?
                C1INTFbits.RBIF = 0;                         // if yes clear rx interrupt flag
        }
}

void main()
{
  LED = 1;
  InitClock();
  InitPorts();
  InitTimersCapture();
  InitCAN();
  InitMain();
  LED = 0;   //Se terminar de inicializar apaga o LED
  
  Delay_ms(100);
  LED = 1;
  Delay_ms(1000);
  LED = 0;
  
  Can_Send_Flags = _ECAN_TX_PRIORITY_0 &           // form value to be used
                   _ECAN_TX_XTD_FRAME &            // with CANSendMessage
                   _ECAN_TX_NO_RTR_FRAME;
  Delay_ms(100);

  while(1)
  {

      /*
      contagem = rand();
      contagem = contagem % 16;*/
      contagem ++;
      if (contagem >=14)
      {
       contagem = 8;
      }
      VDelay_ms(contagem);

      ///Fazendo a aquisição de todos os canais analógicos do LSM
      ICAN_BUS = ADC1_Get_Sample(AN_ICAN_BUS);
      GPIN0 = ADC1_Get_Sample(AN_GPIN0);
      GPIN1 = ADC1_Get_Sample(AN_GPIN1);
      GPIN2 = ADC1_Get_Sample(AN_GPIN2);
      GPIN3 = ADC1_Get_Sample(AN_GPIN3);
      GPIN4 = ADC1_Get_Sample(AN_GPIN4);
      GPIN5 = ADC1_Get_Sample(AN_GPIN5);
      
      //Fazendo aquisição dos canais do PGA
      PGA_Set_Channel(PGA_CH0);                //Canal 0
      PGA0 = ADC1_Get_Sample(AN_PGA);
      PGA0_Gain = 0;
      
      PGA_Set_Channel(PGA_CH1);                //Canal 1
      PGA1 = ADC1_Get_Sample(AN_PGA);
      PGA1_Gain = 0;
      
      PGA_Set_Channel(PGA_CH2);                //Canal 2
      PGA2 = ADC1_Get_Sample(AN_PGA);
      PGA2_Gain = 0;
      
      PGA_Set_Channel(PGA_CH3);                //Canal 3
      PGA3 = ADC1_Get_Sample(AN_PGA);
      PGA3_Gain = 0;
      
      PGA_Set_Channel(PGA_CH4);                //Canal 4
      PGA4 = ADC1_Get_Sample(AN_PGA);
      PGA4_Gain = 0;
      
      PGA_Set_Channel(PGA_CH5);                //Canal 5
      PGA5 = ADC1_Get_Sample(AN_PGA);
      PGA5_Gain = 0;
      
      //PGA_Set_Channel(PGA_CH6);                //Canal 6
      //PGA6 = ADC1_Get_Sample(AN_PGA);
      //PGA6_Gain = 0;
      //PGA_Set_Channel(PGA_CH7);                //Canal 7
      //PGA7 = ADC1_Get_Sample(AN_PGA);
      //PGA7_Gain = 0;
      
      PGA_01_Gain = 1;
      PGA_23_Gain = 1;
      PGA_45_Gain = 1;
      //PGA_67_Gain = 0;
      
      LED = 0;
      //Enviando mensagens via CAN
      RxTx_Data[0] = Hi(ICAN_BUS);
      RxTx_Data[1] = Lo(ICAN_BUS);
      RxTx_Data[2] = Hi(GPIN0);
      RxTx_Data[3] = Lo(GPIN0);
      RxTx_Data[4] = Hi(GPIN1);
      RxTx_Data[5] = Lo(GPIN1);
      RxTx_Data[6] = Hi(GPIN2);
      RxTx_Data[7] = Lo(GPIN2);
      ECAN1Write(LSM_ELET_1, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
    //  Delay_ms(1);
      //Enviando mensagens via CAN
      RxTx_Data[0] = Hi(GPIN3);
      RxTx_Data[1] = Lo(GPIN3);
      RxTx_Data[2] = Hi(GPIN4);
      RxTx_Data[3] = Lo(GPIN4);
      RxTx_Data[4] = Hi(GPIN5);
      RxTx_Data[5] = Lo(GPIN5);
      RxTx_Data[6] = Hi(DIG1);
      RxTx_Data[7] = Lo(DIG1);
      ECAN1Write(LSM_ELET_2, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
     // Delay_us(500);
      //Enviando mensagens via CAN
      RxTx_Data[0] = Hi(PGA0);
      RxTx_Data[1] = Lo(PGA0);
      RxTx_Data[2] = Hi(PGA1);
      RxTx_Data[3] = Lo(PGA1);
      RxTx_Data[4] = Hi(PGA2);
      RxTx_Data[5] = Lo(PGA2);
      RxTx_Data[6] = Hi(PGA3);
      RxTx_Data[7] = Lo(PGA3);
      ECAN1Write(LSM_PGA_1, RxTx_Data, 8, Can_Send_Flags);    // Enviar dados capturados
   //   Delay_ms(1);
      
      //Enviando mensagens via CAN
      RxTx_Data[0] = Hi(PGA4);
      RxTx_Data[1] = Lo(PGA4);
      RxTx_Data[2] = Hi(PGA5);
      RxTx_Data[3] = Lo(PGA5);
      RxTx_Data[4] = PGA_01_Gain;
      RxTx_Data[5] = PGA_23_Gain;
      RxTx_Data[6] = PGA_45_Gain;
      ECAN1Write(LSM_PGA_2, RxTx_Data, 7, Can_Send_Flags);    // Enviar dados capturados
      
      //LED= 0;
      //Delay_ms(3);   //Atraso para não sobrecarregar o barramento CAN




  }
}