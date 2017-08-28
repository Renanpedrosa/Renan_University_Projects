#line 1 "I:/Eletrônica/Projeto Plestimógrafo/Programa uC PRO/Pletismômetro.c"
#line 1 "c:/program files/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 101 "I:/Eletrônica/Projeto Plestimógrafo/Programa uC PRO/Pletismômetro.c"
char cap_msg[] = "Cap:";
char vol_msg[] = "Volume:xx,xxx ml";


char comm_msg[] = "Comunicação - PC";
char sendDado_msg[] = "Enviar Dados?";


char hora_msg[] = "->xx:xx:xx";
char data_msg[] = "Data: xx/xx/xx";


char digHr_msg[] = "Hora: ";
char digMin_msg[] = "Minutos: ";
char digSeg_msg[] = "Segundos: ";
char digDia_msg[] = "Dia: ";
char digMes_msg[] = "Mes: ";
char digAno_msg[] = "Ano: ";








typedef struct
{
mode : 3;
capInit : 1;
clockDate : 1;
cnt : 1;
capTest : 1;
capScale : 1;
}configCap;


long offset1;
int cntCap2;

unsigned short cntOvrf;

unsigned short High_B1;
unsigned short Low_B1;
unsigned short High_B2;
unsigned short Low_B2;
int Capacitancia;


unsigned int memCnt;
unsigned short oldstate;
unsigned short oldstate1;
unsigned short oldstate2;
unsigned short oldstate3;
unsigned short botaoPress;
unsigned short clk;



unsigned char sec, min1, hr, day, month, year;
char *txt, tnum[7];
char byteHigh[4];
char byteLow[4];
char clk_msg[4];
configCap CAP;




sbit LCD_RW at RD1_bit;
sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;


sbit LCD_RW_Direction at TRISD1_bit;
sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;
#line 215 "I:/Eletrônica/Projeto Plestimógrafo/Programa uC PRO/Pletismômetro.c"
int GetCap(long last_Cap)
{
 if(CAP.capInit == 0)
 {

 PIR1.CCP1IF = 0;
 PIR1.TMR1IF = 0;

 cntOvrf = 0;
 CAP.cnt = 0;
 CAP.capTest = 0;

 TMR1H = 0;
 TMR1L = 0;
 T1CON = 0x00;
 PIE1.CCP1IE = 1;
 PIE1.TMR1IE = 1;

 CAP.capInit = 1;

 return last_Cap;
 }
 if(CAP.capTest==1)
 {
 CAP.capInit = 0;

  ((char *)&cntCap2)[1]  = High_B2;
  ((char *)&cntCap2)[0]  = Low_B2;



  PORTB.F2  = 1;
 return cntCap2;
 }
 else
 {
 return last_Cap;
 }
}
#line 266 "I:/Eletrônica/Projeto Plestimógrafo/Programa uC PRO/Pletismômetro.c"
unsigned short int KeyScan()
{

 if (Button(&PORTB, 7, 1, 1))
 oldstate = 1;
 if (oldstate && Button(&PORTB, 7, 1, 0)) {
 oldstate = 0;
 return 1;
 }


 if (Button(&PORTB, 6, 1, 1))
 oldstate1 = 1;
 if (oldstate1 && Button(&PORTB, 6, 1, 0)) {
 oldstate1 = 0;
 return 2;
 }


 if (Button(&PORTB, 5, 1, 1))
 oldstate2 = 1;
 if (oldstate2 && Button(&PORTB, 5, 1, 0)) {
 oldstate2 = 0;
 return 3;
 }


 if (Button(&PORTB, 4, 1, 1))
 oldstate3 = 1;
 if (oldstate3 && Button(&PORTB, 4, 1, 0)) {
 oldstate3 = 0;
 return 4;
 }

 else
 {
 return 0;
 }
}
#line 316 "I:/Eletrônica/Projeto Plestimógrafo/Programa uC PRO/Pletismômetro.c"
void InitMain()
{

 ADCON1 = 0x0F;


 TRISB = 0xF0;

 LCD_RW = 1;
 LCD_RW_Direction = 0;


 TRISC.F2 = 1;
 TMR1H = 0;
 TMR1L = 0;
 INTCON = 0;
 PIE1 = 0;
 PIR1 = 0;
 CCP1CON = 5;
 T1CON = 0x00;

 INTCON = 0xC0;

 CAP.capScale = 0;

 CAP.capInit = 0;
 cntOvrf = 0;
  PORTB.F2  = 0;
 Capacitancia = 0;

 Lcd_Init();
 LCD_Cmd(_LCD_CURSOR_OFF);
 LCD_Cmd(_LCD_CLEAR);

}





void interrupt()
{
 if(PIR1.CCP1IF)
 {
 if(CAP.cnt==0)
 {
 T1CON.TMR1ON = 1;
  PORTB.F3  = 1;
 cntOvrf = 0;
 CAP.cnt = 1;
 }
 else
 {
 High_B2 = CCPR1H;
 Low_B2 = CCPR1L;
 T1CON.TMR1ON = 0;
 PIE1.CCP1IE = 0;
 PIE1.TMR1IE = 0;
 CAP.capTest = 1;
 CAP.cnt = 0;
 }
 PIR1.CCP1IF = 0;
 }
 if(PIR1.TMR1IF)
 {
 cntOvrf++;
 PIR1.TMR1IF = 0;

 }

}





void main()
{

 InitMain();
 CAP.mode = 0x00;
 LCD_Out(1,1,&cap_msg);
 clk = Clock_Khz();
 for(;;)
 {
 switch (CAP.mode)
 {

 case 0: Capacitancia = GetCap(Capacitancia);

 IntToStr(Capacitancia, &tnum);
 ByteToStr(High_B2,&byteHigh);
 ByteToStr(Low_B2,&byteLow);
 LCD_Out(1,5,&tnum);
 LCD_Out(2,3,&byteHigh);
 LCD_Out(2,11,&byteLow);

 break;


 case 1:
 break;


 case 2:
 break;


 case 3:
 break;


 case 4:
 break;


 }

 botaoPress = KeyScan();

 switch(botaoPress)
 {
 case 1: LCD_Cmd(_LCD_CLEAR);
 CAP.mode++;
 switch (CAP.mode)
 {

 case 0: LCD_Out(1,1,&cap_msg);

 break;


 case 1: LCD_Out(1,1,&data_msg);
 ShortToStr(clk,&clk_msg);
 LCD_Out(2,1,&clk_msg);


 break;


 case 2: LCD_Out(1,1,&vol_msg);
 LCD_Out(2,3,&hora_msg);

 break;


 case 3: LCD_Out(1,1,&vol_msg);
 LCD_Out(2,3,&hora_msg);
 break;


 case 4: LCD_Out(1,1,&comm_msg);
 LCD_Out(2,1,&sendDado_msg);

 break;


 case 5: CAP.mode = 0;
 LCD_Out(1,1,&cap_msg);
 LCD_Out(2,1,"H:");
 LCD_Out(2,9,"L:");
 break;
 }
 break;

 case 2:  PORTB.F3  = 0;
 break;

 case 3:  PORTB.F2  = 0;
 break;
 }
 }
}
