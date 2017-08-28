#line 1 "C:/Users/Renan/Documents/Eletrônica/Aula CEFET Dado/LED Dice.c"
#line 46 "C:/Users/Renan/Documents/Eletrônica/Aula CEFET Dado/LED Dice.c"
unsigned char bot1,bot2;


unsigned char Numero(int Lim, int Y)
{
 unsigned char Result;
 static unsigned int Y;

 Y = (Y * 32718 + 3) % 32749;
 Result = ((Y % Lim) + 1);
 return Result;
}

interrupt()
{
GPIF_bit = 0;
bot1 =  GPIO.B4 ;
bot2 =  GPIO.B3 ;
}

void main ()
{
 unsigned char i;

 unsigned char J;
 unsigned char min = 1;
 unsigned char Pattern;
 unsigned char last_Pattern;
 unsigned char DADO[] = {0,0x01,0x04,0x05,0x22,0x23,0x26};

 GPIO = 0;
 TRISIO = 0b011000;
 OSCCAL = 0x38;
 IOC = 0x18;
 INTCON = 0xC8;


 for (;;)
 {

 if (bot1 == 0)
 {
 for(i = 0; i<4; i++)
 {
 J = Numero(6,min);
 Pattern = DADO[J];
 GPIO = Pattern;
 Delay_ms(400);
 GPIO = 0;
 }
 J = Numero(6,min);
 Pattern = DADO[J];
 GPIO = Pattern;
 Delay_ms(2500);
 GPIO = 0;

 }


 if (bot2 == 0)
 {
 GPIO = Pattern;
 Delay_ms(2000);
 GPIO = 0;
 }


 asm SLEEP;




 }

}
