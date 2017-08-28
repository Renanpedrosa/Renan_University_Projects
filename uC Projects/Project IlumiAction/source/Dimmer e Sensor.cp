#line 1 "C:/Users/Renan/Documents/Eletrônica/Sensores de Luz/pROGRAMA/Dimmer e Sensor.c"
#line 25 "C:/Users/Renan/Documents/Eletrônica/Sensores de Luz/pROGRAMA/Dimmer e Sensor.c"
void Buttoncheck(void);
unsigned int PercentOn, Maxdim;
unsigned int TestCheck, Outcount, TestCount;
unsigned int DelayCnt;
unsigned int LastBoth, FirstPass;
unsigned int Count;
const Maxbrt = 0xFD, NotInTest = 3;


unsigned int sensor_out;
unsigned int set_point;
int en0;
int en1;
int en2;
int en3;
int kp;
int ki;
unsigned int auto_normal;
bit read_err;
bit sw_auto;

void interrupt() {
 if (TMR1IF_bit) {
 read_err = 1;
 }
}

void main()
{
 OPTION_REG = 0x85;
 PORTA = 0;
 PORTB = 0;
 PORTC = 0;
 ADCON1 = 0x83;
 TRISA = 0xFF;
 TRISB = 0xFF;
 TRISC = 0x30;


 T1CON = 0x31;
 TMR1IF_bit = 0;
 TMR1H = 0x80;
 TMR1L = 0x00;
 TMR1IE_bit = 1;


 set_point = 600;
 PercentOn = 0xD0;
 Maxdim = 0x70;
 TestCheck = 0;
 Outcount = 0;
 TestCount = 0;
 DelayCnt = NotInTest;
 LastBoth = 0;
 FirstPass = 1;
 Count = 0;

 kp = 3;
 ki = 5;
 en3 = en2 = en1 = en0 = 0;
 RC0_bit = 1;

 for(Count = 0; Count < 60; Count++)
 {
 while( PORTB.B0  == 1);
 while( PORTB.B0  == 0);
 asm{CLRWDT};
 }


 while( PORTB.B0  == 1)
 asm{CLRWDT};
 TMR0 = PercentOn;
 while(TMR0 >= 3 &&  PORTB.B0  == 0)
 asm{CLRWDT};
 RC1_bit = 1;
 INTCON = 0xC0;

 while(1)
 {
 Count = 0;
 while (Count++ < DelayCnt)

 {
 if( PORTB.B0  == 1)
 {
 Maxdim += 5;
 while( PORTB.B0  == 1);
 while( PORTB.B0  == 0)
 asm{CLRWDT};
 }
 else
 {
 while( PORTB.B0  == 0)
 asm{CLRWDT};
 Maxdim = PercentOn - TMR0 + 2;

 }
 if(FirstPass == 1)
 {
 FirstPass = 0;
 PercentOn = Maxdim;
 }
 if(PercentOn < Maxdim)
 PercentOn = Maxdim;
 TMR0 = PercentOn;
 while(TMR0 >= 3 &&  PORTB.B0  == 1)
 asm{CLRWDT};

  PORTC.B6  = 1;
 asm{NOP};
 asm{NOP};
 asm{NOP};
 asm{NOP};
 asm{NOP};
 asm{NOP};
 asm{NOP};
  PORTC.B6  = 0;
 asm{CLRWDT};
 RC2_bit = 1;
 if( PORTB.B0  == 0)
 {
 Maxdim += 5;
 while( PORTB.B0  == 0);
 while( PORTB.B0  == 1)
 asm{CLRWDT};
 }
 else
 {
 while( PORTB.B0 ==1)
 asm{CLRWDT};
 Maxdim = PercentOn - TMR0 + 2;

 }
 if(PercentOn < Maxdim)
 PercentOn = Maxdim;
 TMR0 = PercentOn;
 while(TMR0 >= 3 &&  PORTB.B0  == 0)
 asm{CLRWDT};
  PORTC.B6  = 1;
 asm{NOP};
 asm{NOP};
 asm{NOP};
 asm{NOP};
 asm{NOP};
 asm{NOP};
 asm{NOP};
  PORTC.B6  = 0;
 asm{CLRWDT};
 }

 sensor_out = ADC_Read(2);

 auto_normal = ADC_Read(4);
 if(auto_normal >= 500)
 sw_auto = 1;
 else
 sw_auto = 0;

 Buttoncheck();
 asm{CLRWDT};
 RC3_bit = 1;
 }
}
#line 206 "C:/Users/Renan/Documents/Eletrônica/Sensores de Luz/pROGRAMA/Dimmer e Sensor.c"
void Buttoncheck()
{
asm{NOP};
if(TestCheck == 3)
{
 DelayCnt = 2;
 if( PORTA.B4  && ! PORTC.B4 )
 {
 TestCheck = 0;
 DelayCnt = 5;
 return;
 }
 if(TestCount == 0)
 {
 if(++PercentOn > Maxbrt)
 {
 PercentOn = Maxbrt;
 ++TestCount;
 return;
 }
 else
 return;
 }
 if(TestCount == 1)
 {
 if(--PercentOn <= Maxdim)
 {
 PercentOn = Maxbrt;
 ++TestCount;
 return;
 }
 else
 return;
 }
 while(TestCount++ < 5)
 return;
 while(TestCount++ < 10)
 {
 PercentOn = Maxdim;
 return;
 }
 while(TestCount++ < 15)
 {
 PercentOn = Maxbrt;
 return;
 }
 while(TestCount++ < 20)
 {
 PercentOn = Maxdim;
 return;
 }
 while(TestCount++ < 25)
 {
 PercentOn = Maxbrt;
 return;
 }
 while(TestCount++ < 30)
 {
 PercentOn = Maxdim;
 return;
 }
 PercentOn = Maxdim;
 TestCount = 0;
 if(++Outcount == 255)
 {
 TestCheck = 0;
 DelayCnt = NotInTest;
 Outcount = 0;
 }
 return;
}
if(TestCheck)
if(++Outcount == 0x60)
{
 DelayCnt = NotInTest;
 Outcount = 0;
 TestCheck = 0;
}
if(!TestCheck && ! PORTA.B4  && ! PORTC.B4 )
 TestCheck = 1;
if(TestCheck == 1 && ! PORTA.B4  &&  PORTC.B4 )
 TestCheck = 2;
if(TestCheck == 2 && ! PORTA.B4  && ! PORTC.B4 )
{
 TestCheck = 3;
 TestCount = 0;
 PercentOn = Maxdim;
 Outcount = 0;
}
if(! PORTC.B4  && ! PORTA.B4 )
{
 if(LastBoth == 0)
 {
 LastBoth = 1;

 if(PercentOn == Maxdim)
 PercentOn = Maxbrt;
 else
 PercentOn = Maxdim;
 }
}
else
 LastBoth = 0;
 if(! PORTA.B4  &&  PORTC.B4 )
 {
 if(sw_auto)
 PercentOn = Maxbrt;
 else
 PercentOn ++;
 }
 if( PORTA.B4  && ! PORTC.B4 )
 {
 if(sw_auto)
 PercentOn = Maxdim;
 else
 PercentOn --;
 }

 if(sw_auto)
 {
 en0 = (int)sensor_out - (int)set_point;

 if(en0 > 0)
 {
 PercentOn --;
 }
 if(en0 < 0)
 {
 PercentOn ++;
 }

 }

if(PercentOn > Maxbrt)
 PercentOn = Maxbrt;
if(PercentOn < Maxdim)
 PercentOn = Maxdim;
}
