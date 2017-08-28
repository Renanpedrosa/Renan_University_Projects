#line 1 "C:/Users/Renan/Documents/Eletrônica/FSAE/Aula Protocolo CAN/PIC Temp2/PicTemp2.c"
#line 54 "C:/Users/Renan/Documents/Eletrônica/FSAE/Aula Protocolo CAN/PIC Temp2/PicTemp2.c"
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

 long const ID_Temp1 = 1000;
 long const ID_ReqT1 = 1001;


 long const ID_Temp2 = 2000;
 long const ID_ReqT2 = 2001;


 TRISA = 0xFF;
 ADCON1 = 0x0C;
 TRISB = 0x08;
 TRISC = 0;
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
 CANSetFilter(_CAN_FILTER_B2_F3,ID_ReqT2,_CAN_CONFIG_XTD_MSG);


 CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);

 while(1)
 {
 dt = 0;


 dt = CANRead(&Rx_ID, RxTx_Data, &len, &Read_Flags);


 LED = dt;


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
