/********************************************************/
/* DIMMER.C                                             */
/*                                                      */
/* Lamp dimmer for the 12C508.                          */
/* This program uses the internal 4MHz oscillator       */
/* To drive TRIAC, the output is taken high             */
/* or put in high-impeadance(open drain) to release it  */
/*                                                      */
/* NOTE: This program is designed to work with a 60Hz   */
/* line frequency, it must be modified if used          */
/* on a 50Hz AC line.                                   */
/*                                                      */
/* GPIO<0> = Dim button                                 */
/* GPIO<1> = No Connect                                 */
/* GPIO<2> = Output to TRIAC                            */
/* GPIO<3> = Bright Button                              */
/* GPIO<4> = Zero Crossing sense input                  */
/* GPIO<5> = No Connect                                 */
/********************************************************/
#define Brtbut PORTA.B4 //Brighten button
#define Output PORTC.B6 //Output to TRIAC
#define Dimbut PORTC.B4 //Dim button
#define LineInput PORTB.B0 //AC line zero crossing sense

void Buttoncheck(void); //Button check routine
unsigned int PercentOn, Maxdim; //Global variables
unsigned int TestCheck, Outcount, TestCount;
unsigned int DelayCnt;
unsigned int LastBoth, FirstPass;
unsigned int Count;
const Maxbrt = 0xFD, NotInTest = 3;

//Variaveis para o controle PI
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
  OPTION_REG = 0x85;   //1:64 tmr0 prescaler, pullups disabled
  PORTA = 0;
  PORTB = 0;
  PORTC = 0;
  ADCON1 = 0x83;       //RA0:RA3 são AN0:3 , RA3=Vref+, RA5 = AN4
  TRISA = 0xFF;        //PORTA é entrada
  TRISB = 0xFF;        //PORTB é saída
  TRISC = 0x30;        //Apenas RC5 é entrada,
                       //RC6 e RC7 são CTR2 e CTR1 respect.
                       
  T1CON = 0x31;               // Timer1 settings (1:8) + T1ON
  TMR1IF_bit = 0;             // clear TMR1IF
  TMR1H = 0x80;               // Initialize Timer1 register
  TMR1L = 0x00;               // to interrupt every 4ms
  TMR1IE_bit = 1;             // enable Timer1 Interrupt


  set_point = 600;  //Começar com um valor de controle
  PercentOn = 0xD0; //On Period
  Maxdim = 0x70; //Value of Maximum dimming
  TestCheck = 0; //Test mode check counter
  Outcount = 0; //Counter for test mode exit
  TestCount = 0; //Test mode counter
  DelayCnt = NotInTest; //Delay count
  LastBoth = 0; //Both buttons pressed last time flag
  FirstPass = 1; //Indicate power-up
  Count = 0; //General counter
  
  kp = 3;
  ki = 5;
  en3 = en2 = en1 = en0 = 0;
  RC0_bit = 1;

  for(Count = 0; Count < 60; Count++) //Allow power supply to stabilize
  {
    while(LineInput == 1);
    while(LineInput == 0);
    asm{CLRWDT};
  }


  while(LineInput == 1) //Synch to line phase
  asm{CLRWDT};
  TMR0 = PercentOn; //Get Delay time
  while(TMR0 >= 3 && LineInput == 0) //Delay to enter main at proper point
             asm{CLRWDT};
  RC1_bit = 1;
  INTCON = 0xC0;              // Set GIE, PEIE

  while(1) //Stay in this loop
  {
    Count = 0;
    while (Count++ < DelayCnt) //Check for button press every
                               //DelayCnt zero crossings
    {
      if(LineInput == 1) //Check for AC line already high
      {
        Maxdim += 5; //If so, increment Maxdim
        while(LineInput == 1); // and re-sync with line
        while(LineInput == 0)
        asm{CLRWDT};
      }
      else
      {
        while(LineInput == 0) //Wait for zero crossing
        asm{CLRWDT};
        Maxdim = PercentOn - TMR0 + 2; //Compensate full dim value for line
        // frequency vs osc. speed
    }
    if(FirstPass == 1) //If first pass, go to full dim
    {
      FirstPass = 0;
      PercentOn = Maxdim;
    }
    if(PercentOn < Maxdim) //If maxdim moved, fix brightness
      PercentOn = Maxdim;
    TMR0 = PercentOn; //Get delay time
    while(TMR0 >= 3 && LineInput == 1) //Delay TRIAC turn on (wait for Counter rollover)
      asm{CLRWDT};

    Output = 1; //Fire TRIAC
    asm{NOP}; //Delay for TRIAC fire pulse
    asm{NOP};
    asm{NOP};
    asm{NOP};
    asm{NOP};
    asm{NOP};
    asm{NOP};
    Output = 0; //Release TRIAC fire Signal
    asm{CLRWDT};
    RC2_bit = 1;
    if(LineInput == 0) //Check for AC line already low
    {
      Maxdim += 5; //If so, increment Maxdim
      while(LineInput == 0); // and re-sync with line
      while(LineInput == 1)
      asm{CLRWDT};
    }
    else
    {
      while(LineInput==1) //Wait for zero crossing
        asm{CLRWDT};
      Maxdim = PercentOn - TMR0 + 2; //Compensate full dim value for line
      // frequency vs osc. speed
    }
    if(PercentOn < Maxdim) //If maxdim moved, fix brightness
      PercentOn = Maxdim;
    TMR0 = PercentOn; //Get Delay time
    while(TMR0 >= 3 && LineInput == 0) //Delay TRIAC turn on
      asm{CLRWDT};
    Output = 1; //Fire TRIAC
    asm{NOP}; //Delay for TRIAC fire pulse
    asm{NOP};
    asm{NOP};
    asm{NOP};
    asm{NOP};
    asm{NOP};
    asm{NOP};
    Output = 0;    //Release TRIAC fire signal
    asm{CLRWDT};
    }

    sensor_out = ADC_Read(2);

    auto_normal = ADC_Read(4);
    if(auto_normal >= 500)
      sw_auto = 1;
    else
      sw_auto = 0;
      
    Buttoncheck(); //Check for button press
    asm{CLRWDT};
    RC3_bit = 1;
  }
}
/******************************************************** */
/* ButtonCheck */
/* */
/* This subroutine checks for presses on the BRT and DIM */
/* buttons and increments or decrements PercentOn. */
/* */
/* If both buttons are pressed and the lamp */
/* is not off, it is turned off, if off, it is set to */
/* to max bright. */
/* */
/* In addition, a test function is built in. If both */
/* buttons are pressed, the dim let go and then pressed */
/* again, test mode is entered. If dim is pressed */
/* (alone), the program goes to normal operation at max */
/* dim. The test mode brightens to full bright, dims to */
/* full dim, flashes full bright twice, and repeats. */
/******************************************************** */
void Buttoncheck()
{
asm{NOP}; //Bugfix for MPLABC V1.10
if(TestCheck == 3) //Check test mode flag
{
  DelayCnt = 2; //Reset the delay count
  if(Brtbut && !Dimbut) //If Dimbutton pressed, exit test mode
  {
    TestCheck = 0; //Clear Test mode flag
    DelayCnt = 5;
    return;
  }
  if(TestCount == 0) //Ramp up to full dim
  {
    if(++PercentOn > Maxbrt) //Check for full bright
    {
      PercentOn = Maxbrt;
      ++TestCount;
      return;
    }
    else
    return;
  }
  if(TestCount == 1) //Ramp down to full dim
  {
    if(--PercentOn <= Maxdim) //Check for full dim
    {
      PercentOn = Maxbrt;
      ++TestCount;
      return;
    }
    else
    return;
  }
  while(TestCount++ < 5) //Delay
  return;
  while(TestCount++ < 10) //Turn off for a short period
  {
    PercentOn = Maxdim;
    return;
  }
  while(TestCount++ < 15) //Turn On for a short period
  {
    PercentOn = Maxbrt;
    return;
  }
  while(TestCount++ < 20) //Turn off for a short period
  {
    PercentOn = Maxdim;
    return;
  }
  while(TestCount++ < 25) //Turn on for a short period
  {
    PercentOn = Maxbrt;
    return;
  }
  while(TestCount++ < 30) //Turn off for a short period
  {
    PercentOn = Maxdim;
    return;
  }
  PercentOn = Maxdim;
  TestCount = 0; //Reset to beggining of test sequence
  if(++Outcount == 255) //Run 255 cycles of test mode
  {
    TestCheck = 0; //Clear Test mode flag
    DelayCnt = NotInTest;
    Outcount = 0;
  }
    return;
}
if(TestCheck) //If Test mode not entered quickly,
if(++Outcount == 0x60) // quit checking
{
  DelayCnt = NotInTest;
  Outcount = 0;
  TestCheck = 0;
}
if(!TestCheck && !Brtbut && !Dimbut) //Check bright & dim at same time
  TestCheck = 1; //If both pressed, set to look for next combo
if(TestCheck == 1 && !Brtbut && Dimbut) //Check for only bright button pressed
  TestCheck = 2; //If pressed, set to look for next combo
if(TestCheck == 2 && !Brtbut && !Dimbut) //Check for both pressed again
{
  TestCheck = 3; //Enable test mode
  TestCount = 0;
  PercentOn = Maxdim;
  Outcount = 0;
}
if(!Dimbut && !Brtbut) //If both pressed
{
  if(LastBoth == 0) //Don't flash if held
  {
    LastBoth = 1;
    //set_point = ADC_Read(2);
    if(PercentOn == Maxdim) //If full off...
      PercentOn = Maxbrt; // turn full on...
    else
      PercentOn = Maxdim; // otherwise turn off
  }
}
else
  LastBoth = 0;
  if(!Brtbut && Dimbut) //Check for brighten cmd
    {
      if(sw_auto)
       PercentOn = Maxbrt;
      else
       PercentOn ++;
    }
  if(Brtbut && !Dimbut) //Check for dim cmd
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

if(PercentOn > Maxbrt) //If greater than full bright
  PercentOn = Maxbrt;
if(PercentOn < Maxdim) //If less than full dim
  PercentOn = Maxdim;
}
