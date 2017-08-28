/*

  Coração de LEDs para minha namorada Ellen!!

  GPIO


*/

#define Low_Low       422
#define Low           415
#define Med_Low       412
#define Medium        408
#define Medium_Max    405
#define Max           402
#define Max_Max       398


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

//Base de cálculo para o batimento cardíaco
// mínimo 20 bpm - 0,33 Hz  - 3000ms
// médio baixo 60 bpm - 1Hz - 1000ms
// médio 80 bpm - 1,33 Hz   -  750ms
// máximo 100 bpm - 1,66 Hz -  600ms
// depois 120 bpm - 2 Hz    -  500ms

void main() {

  GPIO   = 0;
  TRISIO = 0x01;              // Configura GPIO 0 para entrada
  ANSEL  = 0x01;              // Configure AN0 pin as analog
  CMCON  = 0x07;              // Disable comparators
  /*
  //Timer1 Settings
  TMR1H      = 0;
  TMR1L      = 0;
  TMR1IE_bit = 1;
  TMR1IF_bit = 0;
  T1CON      = 0x30;
  INTCON     = 0xC0;           // Enable TMRO interrupt
  */
  delay_on = 50;
  delay_1  = 10;
  delay_2  = 3000;

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
    if(NTC_Val >= Low_Low)
    {
      delay_on = 50;
      delay_1 = 200;
      delay_2 = 3000;
      normSt = 1;
      pulseSt = 0;
    }
    else if(NTC_Val >= Low)
    {
      delay_on = 50;
      delay_1 = 150;
      delay_2 = 1500;
      normSt = 1;
      pulseSt = 0;
    }
    else if(NTC_Val >= Med_Low)
    {
      delay_on = 50;
      delay_1 = 125;
      delay_2 = 1000;
      normSt = 0;
      pulseSt = 1;
    }
    else if(NTC_Val >= Medium)
    {
      delay_on = 50;
      delay_1 = 100;
      delay_2 = 850;
      normSt = 0;
      pulseSt = 1;
    }
    else if(NTC_Val >= Medium_Max)
    {
      delay_on = 50;
      delay_1 = 100;
      delay_2 = 700;
      normSt = 0;
      pulseSt = 1;
    }
    else if(NTC_Val >= Max)
    {
      delay_on = 50;
      delay_1 = 100;
      delay_2 = 650;
      normSt = 0;
      pulseSt = 1;
    }
    else if(NTC_Val >= Max_Max)
    {
      delay_on = 50;
      delay_1 = 100;
      delay_2 = 500;
      normSt = 0;
      pulseSt = 1;
    }
    else //(Muito quente)
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