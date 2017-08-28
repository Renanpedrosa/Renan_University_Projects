#include <built_in.h>
//#include "ECAN_IDs.h"
//#include "Inicializacoes_BSM.h"



void InitClock()
{
   /*
   //Configurando o PLL p/ um cristal de 20MHz p/ um clock aproximado de 80MHz
   CLKDIV &= 0xFFE0;   //Zera os bits do PLL prescaler que serão modificados
   CLKDIV |= 0x0003;   //PLL prescaler = N1 = 5
   PLLFBD = 38;        //PLL multiplier = M = 40
   CLKDIV &= 0xFF3F;   //PLL postscaler = N2 = 2    */
   /*FOSC=FIN*M/(N1*N2). Logo, para um cristal de 20MHz, o clock será de 80MHz.
   Para o dsPIC33F, FCY=FOSC/2. Portanto, neste caso, ele opera a 40MIPS.*/


   //Configurando o PLL p/ um cristal de 16MHz p/ um clock aproximado de 80MHz
   CLKDIV &= 0xFFE0;   //Zera os bits do PLL prescaler que serão modificados
   CLKDIV |= 0x0002;   //PLL prescaler = N1 = 4
   PLLFBD = 38;        //PLL multiplier = M = 40
   CLKDIV &= 0xFF3F;   //PLL postscaler = N2 = 2

   
   /*FOSC=FIN*M/(N1*N2). Logo, para um cristal de 16MHz, o clock será de 80MHz.
   Para o dsPIC33F, FCY=FOSC/2. Portanto, neste caso, ele opera a 40MIPS.*/

   //Comando em Assembly necessário para fazer a mudança do clock
   asm{
                ;Unlocking Assembly language code.
                 MOV #0x743, w1         ;note memory address of OSSCONH address
                 MOV.B #0b011, w0
                 MOV #0x78, w2
                 MOV #0x9A, w3
                 MOV.B w2, [w1]
                 MOV.B w3, [w1]
                 MOV.B w0, [w1]

                 MOV #0x742, w1         ;note memory address of OSSCONL address
                 MOV.B #0x01, w0
                 MOV #0x46, w2
                 MOV #0x57, w3
                 MOV.B w2, [w1]
                 MOV.B w3, [w1]
                 MOV.B w0, [w1]
                 NOP
                 NOP
    }
    while(OSCCONbits.COSC != 0b011) {}
    
    //while(OSCCONbits.LOCK != 1) {}

}


void InitPorts()
{
//Configura os pinos como analógicos ou digitais ('1'Dig, '0'An)
   AD1PCFGL = 0x1000;

   //Configura todas os pinos analógicos como entrada
   TRISA0_bit  = 1;        //ANA0
   TRISA1_bit  = 1;        //ANA1
   TRISB0_bit  = 1;        //ANA2
   TRISB1_bit  = 1;        //ANA3
   TRISB2_bit  = 1;        //ANA4
   TRISB3_bit  = 1;        //ANA5
   TRISC0_bit  = 1;        //ANA6
   TRISC1_bit  = 1;        //ANA7
   TRISC2_bit  = 1;        //ANA8
   TRISB15_bit = 1;        //ANA9
   TRISB14_bit = 1;        //ANA10
   TRISB13_bit = 1;        //ANA11

   //Configura todas os pinos digitais e comunicação como entradas e saídas
   TRISB11_bit = 1;           //DIG1
   TRISB12_bit = 1;           //DIG2
   TRISB10_bit = 1;           //DIG3
   TRISC9_bit = 1;           //DIG4
   TRISB4_bit = 1;           //DIG5
   TRISA10_bit = 1;           //DIG6
   TRISB7_bit = 1;           //DIG7
   TRISA7_bit = 1;           //DIG8
   TRISA8_bit = 0;           //LED1
   TRISA9_bit = 0;           //LED2
   TRISC7_bit = 0;           //CAN 1 TX
   TRISC8_bit = 1;           //CAN 1 RX
   TRISC3_bit = 0;           //UART 1 TX
   TRISC4_bit = 1;           //UART 1 RX
   TRISB9_bit = 1;           //I2C SDA
   TRISB8_bit = 0;           //I2C SCL
   TRISA4_bit = 1;           //Botão 1
   TRISC5_bit = 0;           //Relé 1 - RL1
   TRISC6_bit = 0;           //Relé 2 - RL2



  Unlock_IOLOCK();
  //PPS_Mapping(20, _INPUT, _U1RX);      //Configura o pino 43 como rx da UART1
  //PPS_Mapping(19, _OUTPUT, _U1TX);     //Configura o pino 44 como TX da UART1 (Sem conexão com a placa, pino flutuante)
  PPS_Mapping(12, _INPUT, _IC1);     //Configura DIG2 como Entrada do Input Capture 1
  PPS_Mapping(10, _INPUT, _IC2);     //Configura DIG3 como Entrada do Input Capture 2
  PPS_Mapping(25, _INPUT, _IC7);     //Configura DIG4 como Entrada do Input Capture 7
  PPS_Mapping(23, _OUTPUT, _C1TX);     //Configura o pino 4 como TX do CAN
  PPS_Mapping(24, _INPUT, _CIRX);      //Configura o pino 5 como RX da CAN
  Lock_IOLOCK();
}





void InitTimersCapture()
{
/*//Inicializando Timer 1 para funcionar como tempo para gravar o texto vindo do GPS
  IEC0.F3 = 1;                     // Enable Timer1 interrupt
  TMR1 = 0xE17A;                   // Timer1 starts counting from 57722
  T1CON.F5 = 1;                    // Set Timer1 Prescaler to 1:256
  T1CON.F4 = 1;
  IFS0.F3 = 0;                     // Clear Timer1 interrupt flag
  //Note: Timer1 is set to generate interrupt on 50ms interval

  IFS1.F8 = 0;                     // Clear UART receive interrupt flag
  IEC1.F8 = 1;                     // Enable UART receive interrupt
  T1CON.F15 = 1;                   // Start Timer 1*/

  // Initializa Timer 3 for the Input Capture 1 Module   DIG2
  T3CONbits.TCKPS = 0b10; //1:64 prescaler(Período de 1,6us e estouro em 104ms)
  T3CONbits.TCS = 0;      //Clock interno (Fosc/2)
  T3CONbits.TON = 1;      //Liga o Timer 3

  // Initializa Timer 2 for the Input Capture 2 and 7 Module DIG3 e DIG4
  T2CONbits.TCKPS = 0b11; //1:256 prescaler(Período de 6,4us e estouro em 419ms)
  T2CONbits.T32 = 0;      //Funciona como um timer de 16bits
  T2CONbits.TCS = 0;      //Clock interno (Fosc/2)
  T2CONbits.TON = 1;      //Liga o Timer 2


  // Initialize Capture Module  (DIG2)
  IC1CONbits.ICM=0b00; // Disable Input Capture 1 module
  IC1CONbits.ICTMR= 0; // Select Timer3 as the IC1 Time base
  IC1CONbits.ICI= 0b01; // Interrupt on every second capture event
  IC1CONbits.ICM= 0b011; // Generate capture event on every Rising edge

  // Enable Capture Interrupt And Timer3  (DIG2)
  IPC0bits.IC1IP = 1; // Setup IC1 interrupt priority level
  IFS0bits.IC1IF = 0; // Clear IC1 Interrupt Status Flag
  IEC0bits.IC1IE = 1; // Enable IC1 interrupt

  // Initialize Capture Module 2 (DIG3)
  IC2CONbits.ICM=0b00; // Disable Input Capture 2 module
  IC2CONbits.ICTMR= 1; // Select Timer2 as the IC2 Time base
  IC2CONbits.ICI= 0b01; // Interrupt on every second capture event
  IC2CONbits.ICM= 0b011; // Generate capture event on every Rising edge

  // Enable Capture Interrupt And Timer2 (DIG3)
  IPC1bits.IC2IP = 1; // Setup IC2 interrupt priority level
  IFS0bits.IC2IF = 0; // Clear IC2 Interrupt Status Flag
  IEC0bits.IC2IE = 1; // Enable IC2 interrupt

  // Initialize Capture Module 7 (DIG4)
  IC7CONbits.ICM=0b00; // Disable Input Capture 7 module
  IC7CONbits.ICTMR= 1; // Select Timer2 as the IC7 Time base
  IC7CONbits.ICI= 0b01; // Interrupt on every second capture event
  IC7CONbits.ICM= 0b011; // Generate capture event on every Rising edge

  // Enable Capture Interrupt And Timer2 (DIG4)
  IPC5bits.IC7IP = 1; // Setup IC7 interrupt priority level
  IFS1bits.IC7IF = 0; // Clear IC7 Interrupt Status Flag
  IEC1bits.IC7IE = 1; // Enable IC7 interrupt

}

void InitMain()
{




}