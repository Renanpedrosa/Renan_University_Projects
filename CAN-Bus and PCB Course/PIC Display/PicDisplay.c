/*******************************************************************************
              EXEMPLO CAN BUS
              ===============
 * Project name:
     Can_1st (CAN Network demonstration with mikroE's CAN module)
 * Copyright:
     (c) MikroElektronika, 2005-2008
 * Description:
     Este exemplo mostra um display mostrando as temperaturas de dois sensores
     em outros nós do barramento CAN. O nó Display adquire os dados no byte 0 da
     mensagem. Ele então transforma o dado numérico em caracter e exibe no LCD.
 * Test configuration:
     MCU:             PIC18F2580
     Dev.Board:       Protoboard
     Oscillator:      HS, 8.0000 MHz
     Ext. Modules:    mE CAN extra board on PORTB
                      http://www.mikroe.com/en/tools/can1/
     SW:              mikroC PRO for PIC
                      http://www.mikroe.com/en/compilers/mikroc/pro/pic/
 * NOTES:
     - Pinagem do PIC:
     
         LCD
         ---
         RC0       D4
         RC1       D5
         RC2       D6
         RC3       D7
         RC4       RS
         RC5       EN

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
Arquivo:  PICDisplay.C
*******************************************************************************/

// Lcd pinout settings
sbit LCD_RS at RC4_bit;
sbit LCD_EN at RC5_bit;
sbit LCD_D7 at RC3_bit;
sbit LCD_D6 at RC2_bit;
sbit LCD_D5 at RC1_bit;
sbit LCD_D4 at RC0_bit;

// Pin direction
sbit LCD_RS_Direction at TRISC4_bit;
sbit LCD_EN_Direction at TRISC5_bit;
sbit LCD_D7_Direction at TRISC3_bit;
sbit LCD_D6_Direction at TRISC2_bit;
sbit LCD_D5_Direction at TRISC1_bit;
sbit LCD_D4_Direction at TRISC0_bit;

//Definição do LED
sbit LED at LATC6_bit;

char introTxt1[] = "Aula CANBUS 2010";
char introTxt2[] = " No = PicDisplay";

char Temp1Txt[]  = "Temp1:        oC";
char Temp2Txt[]  = "Temp2:        oC";



void init_main()
{

}

void main()
{
  unsigned char temperature, RxTx_Data[8];
  unsigned short Init_Flags, Send_Flags, dt, len, Read_Flags;
  char SJW, BRP, Phase_Seg1, Phase_Seg2, Prop_Seg, txt[4];
  long Rx_ID, mask;
  
  long const ID_Temp1 = 1000;            //ID da mensagem da Temperatura 1
  long const ID_ReqT1 = 1001;            //ID para requisitar um novo valor da
                                         //temperatura 1
  
  long const ID_Temp2 = 2000;            //ID da mensagem da Temperatura 2
  long const ID_ReqT2 = 2001;            //ID para requisitar um novo valor da
                                         //temperatura 2

  TRISC  = 0;                  //Port C é saída
  TRISB  = 0x08;               //RB2 é saída(TXD) e RB3 é entrada (RXD)
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
  
  //Configurar o módulo
  CANSetOperationMode(_CAN_MODE_CONFIG,0xFF);               // set CONFIGURATION mode
  CANSetMask(_CAN_MASK_B1,mask,_CAN_CONFIG_XTD_MSG);          // set all mask1 bits to ones
  CANSetMask(_CAN_MASK_B2,mask,_CAN_CONFIG_XTD_MSG);          // set all mask2 bits to ones
  CANSetFilter(_CAN_FILTER_B2_F4,ID_Temp1,_CAN_CONFIG_XTD_MSG);// set id of filter B2_F4 to 1st Temp msg
  CANSetFilter(_CAN_FILTER_B2_F3,ID_Temp2,_CAN_CONFIG_XTD_MSG);// set id of filter B2_F3 to 2nd Temp msg

  //Retornar ao modo normal
  CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);               // set NORMAL mode
  
  //Iniciar LCD
  Lcd_Init();
  Lcd_Cmd(_LCD_CLEAR);                // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);           // Cursor off
  
  //Exibir mensagem de introdução
  Lcd_Out(1,1,introTxt1);                 // Write text in first row
  Lcd_Out(2,1,introTxt2);                 // Write text in second row
  Delay_ms(2000);
  Lcd_Cmd(_LCD_CLEAR);                // Clear display
  Lcd_Out(1,1,Temp1Txt);                 // Write temp1
  Lcd_Out(2,1,Temp2Txt);                 // Write temp2

  while(1)
  {

     //Enviar uma requisição da temperatura do nó 1
     RxTx_Data[0] = 'T';
     CANWrite(ID_ReqT1, RxTx_Data, 1, Send_Flags);
     dt = 0;
     
     //Pegar alguma temperatura recebida
     dt = CANRead(&Rx_ID, RxTx_Data, &len, &Read_Flags);
     LED = dt;
     
     //Se recebeu a temperatura 1
     if((Rx_ID == ID_Temp1)&& dt)
     {
         temperature = RxTx_Data[0];
         ByteToStr(temperature,txt);
         Lcd_Out(1,9,txt);
     }

     Delay_ms(500);
     
     //Enviar uma requisição da temperatura do nó 1
     CANWrite(ID_ReqT2, RxTx_Data, 1, Send_Flags);

     //Se recebeu a temperatura 2
     if((Rx_ID == ID_Temp2)&& dt)
     {
         temperature = RxTx_Data[0];
         ByteToStr(temperature,txt);
         Lcd_Out(2,9,txt);
     }
     


  }
}
