#line 1 "C:/Users/Renan/Documents/Eletrônica/Coracao/Heart Proj.c"
#line 19 "C:/Users/Renan/Documents/Eletrônica/Coracao/Heart Proj.c"
sbit LED_1 at GP1_bit;
sbit LED_2 at GP2_bit;
sbit LED_3 at GP4_bit;
sbit LED_4 at GP5_bit;

unsigned NTC_Val;
unsigned delay_on;
unsigned delay_1;
unsigned delay_2;
char normSt;
char pulseSt;

void Delay1000ms()
{
 Delay_ms(1000);
}








void main() {

 GPIO = 0;
 TRISIO = 0x01;
 ANSEL = 0x01;
 CMCON = 0x07;
#line 58 "C:/Users/Renan/Documents/Eletrônica/Coracao/Heart Proj.c"
 delay_on = 50;
 delay_1 = 10;
 delay_2 = 3000;

 Delay1000ms();
 LED_1 = 1;
 Delay1000ms();
 LED_2 = 1;
 Delay1000ms();
 LED_3 = 1;
 Delay1000ms();
 LED_4 = 1;
 Delay1000ms();
 Delay1000ms();
 LED_1 = 0;
 LED_2 = 0;
 LED_3 = 0;
 LED_4 = 0;
 Delay1000ms();
 LED_1 = 1;
 LED_2 = 1;
 LED_3 = 1;
 LED_4 = 1;

 while(1)
 {
 NTC_Val = ADC_Read(0);
 if(NTC_Val >=  422 )
 {
 delay_on = 50;
 delay_1 = 200;
 delay_2 = 3000;
 normSt = 1;
 pulseSt = 0;
 }
 else if(NTC_Val >=  415 )
 {
 delay_on = 50;
 delay_1 = 150;
 delay_2 = 1500;
 normSt = 1;
 pulseSt = 0;
 }
 else if(NTC_Val >=  412 )
 {
 delay_on = 50;
 delay_1 = 125;
 delay_2 = 1000;
 normSt = 0;
 pulseSt = 1;
 }
 else if(NTC_Val >=  408 )
 {
 delay_on = 50;
 delay_1 = 100;
 delay_2 = 850;
 normSt = 0;
 pulseSt = 1;
 }
 else if(NTC_Val >=  405 )
 {
 delay_on = 50;
 delay_1 = 100;
 delay_2 = 700;
 normSt = 0;
 pulseSt = 1;
 }
 else if(NTC_Val >=  402 )
 {
 delay_on = 50;
 delay_1 = 100;
 delay_2 = 650;
 normSt = 0;
 pulseSt = 1;
 }
 else if(NTC_Val >=  398 )
 {
 delay_on = 50;
 delay_1 = 100;
 delay_2 = 500;
 normSt = 0;
 pulseSt = 1;
 }
 else
 {
 delay_on = 50;
 delay_1 = 100;
 delay_2 = 100;
 normSt = 0;
 pulseSt = 1;
 }

 LED_1 = pulseSt;
 LED_2 = pulseSt;
 LED_3 = pulseSt;
 LED_4 = pulseSt;
 Vdelay_ms(delay_on);
 LED_1 = normSt;
 LED_2 = normSt;
 LED_3 = normSt;
 LED_4 = normSt;
 Vdelay_ms(delay_1);
 LED_1 = pulseSt;
 LED_2 = pulseSt;
 LED_3 = pulseSt;
 LED_4 = pulseSt;
 Vdelay_ms(delay_on);
 LED_1 = normSt;
 LED_2 = normSt;
 LED_3 = normSt;
 LED_4 = normSt;
 Vdelay_ms(delay_2);

 }




}
