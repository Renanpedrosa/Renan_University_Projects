#line 1 "C:/Users/Renan/Documents/Eletrônica/FSAE/Aula Protocolo CAN/PIC Display/PicDisplay.c"
#line 58 "C:/Users/Renan/Documents/Eletrônica/FSAE/Aula Protocolo CAN/PIC Display/PicDisplay.c"
sbit LCD_RS at RC4_bit;
sbit LCD_EN at RC5_bit;
sbit LCD_D7 at RC3_bit;
sbit LCD_D6 at RC2_bit;
sbit LCD_D5 at RC1_bit;
sbit LCD_D4 at RC0_bit;


sbit LCD_RS_Direction at TRISC4_bit;
sbit LCD_EN_Direction at TRISC5_bit;
sbit LCD_D7_Direction at TRISC3_bit;
sbit LCD_D6_Direction at TRISC2_bit;
sbit LCD_D5_Direction at TRISC1_bit;
sbit LCD_D4_Direction at TRISC0_bit;


sbit LED at LATC6_bit;

char introTxt1[] = "Aula CANBUS 2010";
char introTxt2[] = " No = PicDisplay";

char Temp1Txt[] = "Temp1:        oC";
char Temp2Txt[] = "Temp2:        oC";



void init_main()
{

}

void main()
{
 unsigned char temperature, RxTx_Data[8];
 unsigned short Init_Flags, Send_Flags, dt, len, Read_Flags;
 char SJW, BRP, Phase_Seg1, Phase_Seg2, Prop_Seg, txt[4];
 long Rx_ID, mask;

 long const ID_Temp1 = 1000;
 long const ID_ReqT1 = 1001;


 long const ID_Temp2 = 2000;
 long const ID_ReqT2 = 2001;


 TRISC = 0;
 TRISB = 0x08;
 OSCCON = 0b01110011;



 SJW = 1;
 BRP = 1;
 Phase_Seg1 = 6;
 Phase_Seg2 = 7;
 Prop_Seg = 6;

 mask = -1;

 Init_Flags = _CAN_CONFIG_SAMPLE_THRICE &
 _CAN_CONFIG_PHSEG2_PRG_ON &
 _CAN_CONFIG_XTD_MSG &
 _CAN_CONFIG_DBL_BUFFER_ON &
 _CAN_CONFIG_VALID_XTD_MSG;

 Send_Flags = _CAN_TX_PRIORITY_0 &
 _CAN_TX_XTD_FRAME &
 _CAN_TX_NO_RTR_FRAME;

 Read_Flags = 0;


 CANInitialize(SJW, BRP, Phase_Seg1, Phase_Seg2, Prop_Seg, Init_Flags);


 CANSetOperationMode(_CAN_MODE_CONFIG,0xFF);
 CANSetMask(_CAN_MASK_B1,mask,_CAN_CONFIG_XTD_MSG);
 CANSetMask(_CAN_MASK_B2,mask,_CAN_CONFIG_XTD_MSG);
 CANSetFilter(_CAN_FILTER_B2_F4,ID_Temp1,_CAN_CONFIG_XTD_MSG);
 CANSetFilter(_CAN_FILTER_B2_F3,ID_Temp2,_CAN_CONFIG_XTD_MSG);


 CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);


 Lcd_Out(1,1,introTxt1);
 Lcd_Out(2,1,introTxt2);
 Delay_ms(2000);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,Temp1Txt);
 Lcd_Out(2,1,Temp2Txt);

 while(1)
 {


 RxTx_Data[0] = 'T';
 CANWrite(ID_ReqT1, RxTx_Data, 1, Send_Flags);
 dt = 0;


 dt = CANRead(&Rx_ID, RxTx_Data, &len, &Read_Flags);
 LED = dt;


 if((Rx_ID == ID_Temp1)&& dt)
 {
 temperature = RxTx_Data[0];
 ByteToStr(temperature,txt);
 Lcd_Out(1,9,txt);
 }

 Delay_ms(500);


 CANWrite(ID_ReqT2, RxTx_Data, 1, Send_Flags);


 if((Rx_ID == ID_Temp2)&& dt)
 {
 temperature = RxTx_Data[0];
 ByteToStr(temperature,txt);
 Lcd_Out(2,9,txt);
 }



 }
}
