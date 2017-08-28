/*******************************************************************************
              EXEMPLO CAN BUS
              ===============
 * Project name:
     PicTemp1
 * Copyright:
     (c) MikroElektronika, 2005-2008
 * Description:
     Este exemplo mostra um um termômetro utilizando LM35 como sensor. É o
     primeiro de dois sensores do barramento CAN. Ele recebe uma requisição
     de aquisição da temperatura e a envia para o nó de display.
 * Test configuration:
     MCU:             PIC18F2480
     Dev.Board:       Protoboard
     Oscillator:      HS, 8.0000 MHz
     Ext. Modules:    mE CAN extra board on PORTB
                      http://www.mikroe.com/en/tools/can1/
     SW:              mikroC PRO for PIC
                      http://www.mikroe.com/en/compilers/mikroc/pro/pic/
 * NOTES:
     - Pinagem do PIC:
     
         LM35
         ----
         
         RA0       Vout do sensor

         RC6       Anodo do LED

         MCP2551
         -------
         RB2       TXD
         RB3       RXD
     
     - Parâmetros de velocidade CAN
     
         Clock do Microcontrolador:       8MHz
         CAN BUS bit rate:                100kb/s
         Sync_seg:                        1
         Prop_Seg:                        6
         Phase_Seg1:                      6
         Phase_Seg2:                      7
         SJW:                             1
         BRP:                             1
         Sample Point:                    65%
     
     
Autor:    Renan / Dogan Ibrahim
Data:     10/11/2010
Arquivo:  PICTemp2.C
*******************************************************************************/

//Definição do LED
sbit LED at LATC6_bit;


void init_main()
{

}

void main()
{
  unsigned char temperature, RxTx_Data[8];
  unsigned short Init_Flags, Send_Flags, dt, len, Read_Flags;
  char SJW, BRP, Phase_Seg1, Phase_Seg2, Prop_Seg, txt[4];
  long Rx_ID, mask;
  
  unsigned int temp;
  unsigned long mV;
  
  long const ID_Temp1 = 1000;            //ID da mensagem da Temperatura 1
  long const ID_ReqT1 = 1001;            //ID para requisitar um novo valor da
                                         //temperatura 1
  
  long const ID_Temp2 = 2000;            //ID da mensagem da Temperatura 2
  long const ID_ReqT2 = 2001;            //ID para requisitar um novo valor da
                                         //temperatura 2

  TRISA  = 0xFF;               //PortA é entrada
  ADCON1 = 0x0C;               //RA0, RA1 e RA2 são ent. analógicas.
  TRISB  = 0x08;               //RB2 é saída(TXD) e RB3 é entrada (RXD)
  TRISC  = 0;                  //PortC é saída
  OSCCON = 0b01110011;         //Oscilador interno selecionado(8MHz)

  

  //Parâmetros CAN BUS
  SJW = 1;
  BRP = 1;
  Phase_Seg1 = 6;
  Phase_Seg2 = 7;
  Prop_Seg = 6;
  
  mask = -1;
  
  Init_Flags = _CAN_CONFIG_SAMPLE_THRICE &              // form value to be used
                   _CAN_CONFIG_PHSEG2_PRG_ON &              // with CANInit
                   _CAN_CONFIG_XTD_MSG &
                   _CAN_CONFIG_DBL_BUFFER_ON &
                   _CAN_CONFIG_VALID_XTD_MSG;
  
  Send_Flags = _CAN_TX_PRIORITY_0 &                     // form value to be used
                   _CAN_TX_XTD_FRAME &                      //     with CANWrite
                   _CAN_TX_NO_RTR_FRAME;
  Read_Flags = 0;
  
  //Inializar módulo CAN
  CANInitialize(SJW, BRP, Phase_Seg1, Phase_Seg2, Prop_Seg, Init_Flags);
  
  //Configurar o módulo e o filtro para receber a mensagem de requisição
  CANSetOperationMode(_CAN_MODE_CONFIG,0xFF);               // set CONFIGURATION mode
  CANSetMask(_CAN_MASK_B1,mask,_CAN_CONFIG_XTD_MSG);          // set all mask1 bits to ones
  CANSetMask(_CAN_MASK_B2,mask,_CAN_CONFIG_XTD_MSG);          // set all mask2 bits to ones
  CANSetFilter(_CAN_FILTER_B2_F3,ID_ReqT2,_CAN_CONFIG_XTD_MSG);// set id of filter B2_F3 to 1st Temp req

  //Retornar ao modo normal
  CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);               // set NORMAL mode

  while(1)
  {
     dt = 0;
     
     //Pegar alguma temperatura recebida
     dt = CANRead(&Rx_ID, RxTx_Data, &len, &Read_Flags);
     
     //Caso alguma mensagem foi recebida, o LED acende
     LED = dt;
     
     //Se recebeu a temperatura 1
     if((Rx_ID == ID_ReqT2)&& dt)
     {
         temp = ADC_Read(0);
         mV = (unsigned long)temp * 5000/1024;
         temperature = mV/10;
         RxTx_Data[0] = temperature;
         CANWrite(ID_Temp2, RxTx_Data, 1, Send_Flags);
     }

  }
}
