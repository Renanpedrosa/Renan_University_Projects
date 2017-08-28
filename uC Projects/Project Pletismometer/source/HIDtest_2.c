/*
 * Project name:
     HIDtest2 (USB HID Read & Write Test)
 * Copyright:
     (c) MikroElektronika, 2005-2008
 * Revision History:
     20050502:
       - initial release;
 * Description:
     This example establishes connection with the HID terminal that is active
     on the PC. Upon connection establishment, the HID Device Name will appear
     in the respective window. The character that user sends to PIC from the HID
     terminal will be re-sent back to user.
 * Test configuration:
     MCU:             PIC18F4550
     Dev.Board:       EasyPIC5
     Oscillator:      HS 8.000 MHz  (USB osc. is raised with PLL to 48.000MHz)
     Ext. Modules:    USB-HID terminal board/None
     SW:              mikroC PRO for PIC
 * NOTES:
     (*) Be VERY careful about the configuration flags for the 18F4550 - there's
     so much place for mistake!
    - Place jumpers J12 in the right position
*/

unsigned char k;
unsigned char userWR_buffer[64], userRD_buffer[64];

const char *text = "MIKROElektronika Compilers ER \r\n";

//**************************************************************************************************
// Main Interrupt Routine
//**************************************************************************************************
void interrupt()
{
  HID_InterruptProc();

}
//**************************************************************************************************

//**************************************************************************************************
// Initialization Routine
//**************************************************************************************************

void Init_Main()
{
        //--------------------------------------
        // Disable all interrupts
        //--------------------------------------
        INTCON = 0;                             // Disable GIE, PEIE, TMR0IE,INT0IE,RBIE
        INTCON2 = 0xF5;
        INTCON3 = 0xC0;
        RCON.IPEN = 0;                          // Disable Priority Levels on interrupts
        PIE1 = 0;
        PIE2 = 0;
        PIR1 = 0;
        PIR2 = 0;

        ADCON1 |= 0x0F;                         // Configure all ports with analog function as digital
        CMCON  |= 7;                            // Disable comparators
        //--------------------------------------
        // Ports Configuration
        //--------------------------------------
        TRISA = 0xFF;
        TRISB = 0xFF;
        TRISC = 0xFF;
        TRISD = 0;
        TRISE = 0x07;

        LATA = 0;
        LATB = 0;
        LATC = 0;
        LATD = 0;
        LATE = 0;
        //--------------------------------------
        // Clear user RAM
        // Banks [00 .. 07] ( 8 x 256 = 2048 Bytes )
        //--------------------------------------

        
}
//**************************************************************************************************





//**************************************************************************************************
// Main Program Routine
//**************************************************************************************************

void main() {
  unsigned char i, ch;
  
  Init_Main();

  HID_Enable(&userRD_buffer, &userWR_buffer);
  Delay_ms(1000); Delay_ms(1000);

  while (1) {
    k = HID_Read();
    i = 0;
    while (i < k) {
      ch = userRD_buffer[i];
      userWR_buffer[0] = ch;
      while (!HID_Write(&userWR_buffer, 1)) ;
      i++;
      }

    }
  HID_Disable();
}
//**************************************************************************************************
