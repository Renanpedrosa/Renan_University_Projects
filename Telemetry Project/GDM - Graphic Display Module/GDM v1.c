/*
 * Project name:
     Led_Blinking (The simplest simple example)
 * Target Platform:
     dsPIC
 * Copyright:
     (c) mikroElektronika, 2010.
 * Revision History:
     20100502:
       - Initial release;
 * Description:
     Simple "Hello world" example for the world of dsPIC MCUs;
* Test configuration:
     MCU:             dsPIC30F4013
                      http://ww1.microchip.com/downloads/en/DeviceDoc/70138F.pdf
     Dev.Board:       EASYdsPIC6 - ac:LED
                      http://www.mikroe.com/eng/products/view/434/easydspic6-development-system/
     Oscillator:      XT-PLL8, 10.000MHz
     Ext. Modules:    None.
     SW:              mikroC PRO for dsPIC30/33 and PIC24
                      http://www.mikroe.com/eng/products/view/231/mikroc-pro-for-dspic30-33-and-pic24/
 * NOTES:
     - Turn ON port LEDs at SW12 (board specific).
 */

 #include <built_in.h>
 #include "ECAN_Defs.h"
 #include "ECAN_IDs.h"

 //
 // Defini��es para Velocidade CAN
 //
 #define SJW      1
 #define BRP      1
 #define PHSEG1   8
 #define PHSEG2   6
 #define PROPSEG  5
int OSCCON_LED;

//Vari�veis do CAN - Usados para fazer o exemplo de comunica��o CAN funcionar.
unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;  // can flags
unsigned int Rx_Data_Len;                                    // received data length in bytes
char RxTx_Data[8];                                           // can rx/tx data buffer
char Msg_Rcvd;                                               // reception flag
const unsigned long ID_1st = 12111, ID_2nd = 3;              // node IDs
unsigned long Rx_ID;

sbit SPI_CS_PGA1  at LATC5_bit;                     //Chip-Select PGA1(MCP6S28)

//variaveis para inicializar o lcd
sbit GLCD_D0 at RB7_bit;
sbit GLCD_D1 at RB8_bit;
sbit GLCD_D2 at RB9_bit;
sbit GLCD_D3 at RC6_bit;
sbit GLCD_D4 at RC7_bit;
sbit GLCD_D5 at RC8_bit;
sbit GLCD_D6 at RC9_bit;
sbit GLCD_D7 at RB7_bit;
sbit GLCD_CS1 at RC3_bit;
sbit GLCD_CS2 at RC4_bit;
sbit GLCD_RS at RA7_bit;
sbit GLCD_RW at RA8_bit;
sbit GLCD_EN at RA9_bit;
sbit GLCD_RST at RC5_bit;

sbit GLCD_D0_Direction at TRISB7_bit;
sbit GLCD_D1_Direction at TRISB8_bit;
sbit GLCD_D2_Direction at TRISB9_bit;
sbit GLCD_D3_Direction at TRISC6_bit;
sbit GLCD_D4_Direction at TRISC7_bit;
sbit GLCD_D5_Direction at TRISC8_bit;
sbit GLCD_D6_Direction at TRISC9_bit;
sbit GLCD_D7_Direction at TRISB7_bit;
sbit GLCD_CS1_Direction at TRISC3_bit;
sbit GLCD_CS2_Direction at TRISC4_bit;
sbit GLCD_RS_Direction at TRISA7_bit;
sbit GLCD_RW_Direction at TRISA8_bit;
sbit GLCD_EN_Direction at TRISA9_bit;
sbit GLCD_RST_Direction at TRISC5_bit;


void InitClock()
{

//
   // In�cio da configura��o de Clock para rodar a 40MIPS (80MHz)
   //

   //Configurando o PLL p/ um cristal de 20MHz p/ um clock aproximado de 80MHz
   //CLKDIV &= 0xFFE0;   //Zera os bits do PLL prescaler que ser�o modificados
   //CLKDIV |= 0x0003;   //PLL prescaler = N1 = 5
   //PLLFBD = 38;        //PLL multiplier = M = 40
   //CLKDIV &= 0xFF3F;   //PLL postscaler = N2 = 2
   /*FOSC=FIN*M/(N1*N2). Logo, para um cristal de 20MHz, o clock ser� de 80MHz.
   Para o dsPIC33F, FCY=FOSC/2. Portanto, neste caso, ele opera a 40MIPS.*/


   //Configurando o PLL p/ um cristal de 16MHz p/ um clock aproximado de 80MHz
   CLKDIV &= 0xFFE0;   //Zera os bits do PLL prescaler que ser�o modificados
   CLKDIV |= 0x0002;   //PLL prescaler = N1 = 4
   PLLFBD = 38;        //PLL multiplier = M = 40
   CLKDIV &= 0xFF3F;   //PLL postscaler = N2 = 2

   /*FOSC=FIN*M/(N1*N2). Logo, para um cristal de 16MHz, o clock ser� de 80MHz.
   Para o dsPIC33F, FCY=FOSC/2. Portanto, neste caso, ele opera a 40MIPS.*/


   //LED2 = CF_bit;
   //while(OSCCONbits.CF != 1);
   //LED = 1;

   //Comando em Assembly necess�rio para fazer a mudan�a do clock
   asm {
                ; Unlocking Assembly language code.
                 MOV #0x743, w1         ;note memory address of OSSCONH address
                 MOV.B #0b011, w0
                 MOV #0x78, w2
                 MOV #0x9A, w3
                 MOV.B w2, [w1]
                 MOV.B w3, [w1]
                 MOV.B w0, [w1]

                 MOV #0x742, w1         ;note memory address of OSSCONL address
                 MOV.B #0x03, w0
                 MOV #0x46, w2
                 MOV #0x57, w3
                 MOV.B w2, [w1]
                 MOV.B w3, [w1]
                 MOV.B w0, [w1]
                 NOP
                 NOP
    }
    //LED2 = CF_bit;

   //while(OSCCONbits.OSWEN != 0) {}
    //LED = 0;


   //
   // Fim da configura��o de Clock para rodar a 40MIPS (80MHz)
   //
}



void InitCan()
{
 /* Clear Interrupt Flags */

        IFS0=0;
        IFS1=0;
        IFS2=0;
        IFS3=0;
        IFS4=0;

  /* Enable ECAN1 Interrupt */

        IEC2bits.C1IE   = 1;                       // enable ECAN1 interrupt
        C1INTEbits.TBIE = 1;                       // enable ECAN1 tx interrupt
        C1INTEbits.RBIE = 1;                       // enable ECAN1 rx interrupt

  Can_Init_Flags = 0;                              //
  Can_Send_Flags = 0;                              // clear flags
  Can_Rcv_Flags  = 0;                              //

  Can_Send_Flags = _ECAN_TX_PRIORITY_0 &           // form value to be used
                   _ECAN_TX_XTD_FRAME &            // with CANSendMessage
                   _ECAN_TX_NO_RTR_FRAME;

  Can_Init_Flags = _ECAN_CONFIG_SAMPLE_THRICE &    // form value to be used
                   _ECAN_CONFIG_PHSEG2_PRG_ON &    // with CANInitialize
                   _ECAN_CONFIG_XTD_MSG &
                   _ECAN_CONFIG_MATCH_MSG_TYPE &
                   _ECAN_CONFIG_LINE_FILTER_OFF;

  ECAN1DmaChannelInit(0, 1, &ECAN1RxTxRAMBuffer);  // init dma channel 0 for
                                                   // dma to ECAN peripheral transfer
  ECAN1DmaChannelInit(2, 0, &ECAN1RxTxRAMBuffer);  // init dma channel 2 for
                                                   // ECAN peripheral to dma transfer
  ECAN1Initialize(SJW, BRP, PHSEG1, PHSEG2, PROPSEG, Can_Init_Flags);  // initialize ECAN 1Mbps
  ECAN1SetBufferSize(ECAN1RAMBUFFERSIZE);          // set number of rx+tx buffers in DMA RAM

  ECAN1SelectTxBuffers(0x000F);                    // select transmit buffers
                                                   // 0x000F = buffers 0:3 are transmit buffers
  ECAN1SetOperationMode(_ECAN_MODE_CONFIG,0xFF);   // set CONFIGURATION mode

  ECAN1SetMask(_ECAN_MASK_0, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask1 bits to ones
  ECAN1SetMask(_ECAN_MASK_1, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask2 bits to ones
  ECAN1SetMask(_ECAN_MASK_2, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask3 bits to ones
  ECAN1SetFilter(_ECAN_FILTER_10,FSM_CTRL, _ECAN_MASK_2, _ECAN_RX_BUFFER_7, _ECAN_CONFIG_XTD_MSG); // set id of filter10 to 1st node ID

                                                                                                 // assign buffer7 to filter10
  ECAN1SetOperationMode(_ECAN_MODE_NORMAL,0xFF);   // set NORMAL mode
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

  // Initializa Timer 2 for the Input Capture 1 and 2 Module GPIN1 e GPIN2
  T2CONbits.TCKPS = 0b11; //1:256 prescaler(Per�odo de 6,4us e estouro em 419ms)
  T2CONbits.T32 = 0;      //Funciona como um timer de 16bits
  T2CONbits.TCS = 0;      //Clock interno (Fosc/2)
  T2CONbits.TON = 1;      //Liga o Timer 2

  // Initializa Timer 3 for the Input Capture 7 Module   GPIN3
  T3CONbits.TCKPS = 0b10; //1:64 prescaler(Per�odo de 1,6us e estouro em 104ms)
  T3CONbits.TCS = 0;      //Clock interno (Fosc/2)
  T3CONbits.TON = 1;      //Liga o Timer 3

  // Initialize Capture Module  (GPIN1)
  IC1CONbits.ICM=0b00; // Disable Input Capture 1 module
  IC1CONbits.ICTMR= 1; // Select Timer2 as the IC1 Time base
  IC1CONbits.ICI= 0b01; // Interrupt on every second capture event
  IC1CONbits.ICM= 0b011; // Generate capture event on every Rising edge

  // Enable Capture Interrupt And Timer2  (GPIN1)
  IPC0bits.IC1IP = 1; // Setup IC1 interrupt priority level
  IFS0bits.IC1IF = 0; // Clear IC1 Interrupt Status Flag
  IEC0bits.IC1IE = 1; // Enable IC1 interrupt

  // Initialize Capture Module 2 (GPIN2)
  IC2CONbits.ICM=0b00; // Disable Input Capture 2 module
  IC2CONbits.ICTMR= 1; // Select Timer2 as the IC2 Time base
  IC2CONbits.ICI= 0b01; // Interrupt on every second capture event
  IC2CONbits.ICM= 0b011; // Generate capture event on every Rising edge

  // Enable Capture Interrupt And Timer2 (GPIN2)
  IPC1bits.IC2IP = 1; // Setup IC2 interrupt priority level
  IFS0bits.IC2IF = 0; // Clear IC2 Interrupt Status Flag
  IEC0bits.IC2IE = 1; // Enable IC2 interrupt

  // Initialize Capture Module 7 (GPIN3)
  IC7CONbits.ICM=0b00; // Disable Input Capture 7 module
  IC7CONbits.ICTMR= 0; // Select Timer3 as the IC7 Time base
  IC7CONbits.ICI= 0b01; // Interrupt on every second capture event
  IC7CONbits.ICM= 0b011; // Generate capture event on every Rising edge

  // Enable Capture Interrupt And Timer2 (GPIN3)
  IPC5bits.IC7IP = 1; // Setup IC7 interrupt priority level
  IFS1bits.IC7IF = 0; // Clear IC7 Interrupt Status Flag
  IEC1bits.IC7IE = 1; // Enable IC7 interrupt

}



unsigned char const marchaneutra_bmp[1024] = {
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,128,192,192,224,224,
 240,112,112,120, 56, 56, 56, 56, 28, 28, 28, 28, 28, 28, 28, 28,
  28, 28, 28, 56, 56, 56, 56,120,112,112,240,224,224,192,192,128,
 128,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,128,192,224,240,120, 60, 30, 15, 15,  7,  3,  1,  1,  1,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  3,
   7,  7, 15, 30, 60,120,240,224,192,128,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,248,252,
  63, 15,  7,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,240,240,240,240,240,192,  0,  0,  0,  0,  0,  0,
   0,  0,  0,240,240,240,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  1,  7, 15, 63,252,248,224,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,255,255, 15,  1,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,255,255,255,  0,  3, 15, 31,126,248,224,128,  0,
   0,  0,  0,255,255,255,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,255,255,240,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,255,255,224,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,255,255,255,  0,  0,  0,  0,  0,  1,  7, 31, 62,
 252,240,192,255,255,255,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,255,255, 31,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1, 15, 63,127,
 248,224,192,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  7,  7,  7,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  3,  7,  7,  7,  7,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,128,224,248,126, 63, 15,  1,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   1,  3,  7, 15, 30, 60,120,240,224,192,192,128,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,
 192,192,224,240,120, 60, 62, 15,  7,  3,  1,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  3,  3,  7,  7, 14, 14,
  28, 28, 28, 60, 56, 56, 56,112,112,112,112,112,112,112,112,112,
 112,112,112,112, 56, 56, 56, 60, 28, 28, 28, 14, 14,  7,  7,  3,
   3,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
};




unsigned char const marchaum_bmp[1024] = {
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,128,192,192,224,224,
 240,112,112,120, 56, 56, 56, 56, 28, 28, 28, 28, 28, 28, 28, 28,
  28, 28, 28, 56, 56, 56, 56,120,112,112,240,224,224,192,192,128,
 128,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,128,192,224,240,120, 60, 30, 15, 15,  7,  3,  1,  1,  1,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  3,
   7,  7, 15, 30, 60,120,240,224,192,128,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,248,252,
  63, 15,  7,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,128,128,192,224, 96,240,240,240,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  1,  7, 15, 63,252,248,224,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,255,255, 15,  1,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  3,  3,  1,  1,  0,  0,255,255,255,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,255,255,240,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,255,255,224,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,255,255,255,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,255,255, 31,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1, 15, 63,127,
 248,224,192,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  2,  7,  7,  7,  7,  7,  7,  7,  7,  7,
   7,  7,  7,  7,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,128,224,248,126, 63, 15,  1,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   1,  3,  7, 15, 30, 60,120,240,224,192,192,128,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,
 192,192,224,240,120, 60, 62, 15,  7,  3,  1,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  3,  3,  7,  7, 14, 14,
  28, 28, 28, 60, 56, 56, 56,112,112,112,112,112,112,112,112,112,
 112,112,112,112, 56, 56, 56, 60, 28, 28, 28, 14, 14,  7,  7,  3,
   3,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
};



unsigned char const marchadois_bmp[1024] = {
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,128,192,192,224,224,
 240,112,112,120, 56, 56, 56, 56, 28, 28, 28, 28, 28, 28, 28, 28,
  28, 28, 28, 56, 56, 56, 56,120,112,112,240,224,224,192,192,128,
 128,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,128,192,224,240,120, 60, 30, 15, 15,  7,  3,  1,  1,  1,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  3,
   7,  7, 15, 30, 60,120,240,224,192,128,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,248,252,
  63, 15,  7,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,192,224,224,112,112,112,112,112,240,
 224,224,192,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  1,  7, 15, 63,252,248,224,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,255,255, 15,  1,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,128,192,
 255,255, 63,  6,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,255,255,240,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,255,255,224,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,128,192,224,112, 56, 28, 30, 15,  3,
   1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,255,255, 31,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1, 15, 63,127,
 248,224,192,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,
   7,  7,  7,  7,  7,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,128,224,248,126, 63, 15,  1,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   1,  3,  7, 15, 30, 60,120,240,224,192,192,128,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,
 192,192,224,240,120, 60, 62, 15,  7,  3,  1,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  3,  3,  7,  7, 14, 14,
  28, 28, 28, 60, 56, 56, 56,112,112,112,112,112,112,112,112,112,
 112,112,112,112, 56, 56, 56, 60, 28, 28, 28, 14, 14,  7,  7,  3,
   3,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
};



unsigned char const marchatres_bmp[1024] = {
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,128,192,192,224,224,
 240,112,112,120, 56, 56, 56, 56, 28, 28, 28, 28, 28, 28, 28, 28,
  28, 28, 28, 56, 56, 56, 56,120,112,112,240,224,224,192,192,128,
 128,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,128,192,224,240,120, 60, 30, 15, 15,  7,  3,  1,  1,  1,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  3,
   7,  7, 15, 30, 60,120,240,224,192,128,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,248,252,
  63, 15,  7,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,128,128,192,192,192,192,192,192,
 128,128,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  1,  7, 15, 63,252,248,224,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,255,255, 15,  1,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  7,131,131,129,129,129,129,193,195,
 247,127, 63, 12,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,255,255,240,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,255,255,224,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  1,  3,  3,  3,  3,  3,  3,  7,
  15,254,254,252,240,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,255,255, 31,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1, 15, 63,127,
 248,224,192,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  7, 14, 14, 28, 28, 28, 28, 28, 28, 30,
  14, 15,  7,  3,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,128,224,248,126, 63, 15,  1,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   1,  3,  7, 15, 30, 60,120,240,224,192,192,128,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,
 192,192,224,240,120, 60, 62, 15,  7,  3,  1,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  3,  3,  7,  7, 14, 14,
  28, 28, 28, 60, 56, 56, 56,112,112,112,112,112,112,112,112,112,
 112,112,112,112, 56, 56, 56, 60, 28, 28, 28, 14, 14,  7,  7,  3,
   3,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
};



unsigned char const marchaquatro_bmp[1024] = {
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,128,192,192,224,224,
 240,112,112,120, 56, 56, 56, 56, 28, 28, 28, 28, 28, 28, 28, 28,
  28, 28, 28, 56, 56, 56, 56,120,112,112,240,224,224,192,192,128,
 128,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,128,192,224,240,120, 60, 30, 15, 15,  7,  3,  1,  1,  1,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  3,
   7,  7, 15, 30, 60,120,240,224,192,128,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,248,252,
  63, 15,  7,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,192,224,224,224,
 224,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  1,  7, 15, 63,252,248,224,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,255,255, 15,  1,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,192,224,248, 60, 15,  7,  1,  1,255,
 255,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,255,255,240,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,255,255,224,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,120,124,127,119,113,112,112,112,112,112,112,255,
 255,112,112,112,112,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,255,255, 31,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1, 15, 63,127,
 248,224,192,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,
  15,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,128,224,248,126, 63, 15,  1,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   1,  3,  7, 15, 30, 60,120,240,224,192,192,128,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,
 192,192,224,240,120, 60, 62, 15,  7,  3,  1,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  3,  3,  7,  7, 14, 14,
  28, 28, 28, 60, 56, 56, 56,112,112,112,112,112,112,112,112,112,
 112,112,112,112, 56, 56, 56, 60, 28, 28, 28, 14, 14,  7,  7,  3,
   3,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
};


unsigned char const marchacinco_bmp[1024] = {
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,128,192,192,224,224,
 240,112,112,120, 56, 56, 56, 56, 28, 28, 28, 28, 28, 28, 28, 28,
  28, 28, 28, 56, 56, 56, 56,120,112,112,240,224,224,192,192,128,
 128,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,128,192,224,240,120, 60, 30, 15, 15,  7,  3,  1,  1,  1,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  3,
   7,  7, 15, 30, 60,120,240,224,192,128,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,248,252,
  63, 15,  7,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,192,192,192,192,192,192,192,192,192,
 192,192,192,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  1,  7, 15, 63,252,248,224,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,255,255, 15,  1,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,255,255,255,193,193,193,193,193,193,
 129,129,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,255,255,240,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 15,255,255,224,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  3,
   3,143,255,254,120,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,224,255,255, 31,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1, 15, 63,127,
 248,224,192,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0, 14, 14, 28, 28, 28, 28, 28, 28, 28, 14,
  15,  7,  7,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,128,224,248,126, 63, 15,  1,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   1,  3,  7, 15, 30, 60,120,240,224,192,192,128,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,
 192,192,224,240,120, 60, 62, 15,  7,  3,  1,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  3,  3,  7,  7, 14, 14,
  28, 28, 28, 60, 56, 56, 56,112,112,112,112,112,112,112,112,112,
 112,112,112,112, 56, 56, 56, 60, 28, 28, 28, 14, 14,  7,  7,  3,
   3,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
};


void delay2S(){
  delay_ms(2000);
}
void main() {
  InitClock();
  AD1PCFGL = 0xFFFF;
  //ADPCFG = 0xFFFF;
  ADPCFG = 0xFFFF;       // Configure AN pins as digital I/O
  TRISA = 0x00;
  TRISB = 0;             // Initialize PORTB as output
  TRISC = 0;             // Initialize PORTC as output
  LATA = 0;
  LATB = 0;              // Set PORTB to zero
  LATC = 0;              // Set PORTC to zero*/

  // Glcd_Init();
   //Glcd_Fill(0x00);


  while(1) {
    //Glcd_Fill(0x00);
    //Delay_ms(2000);
    // Glcd_Fill(0xff);
    RA7_bit = ~RA7_bit;
    RA9_bit = ~RA9_bit;
    RA10_bit = ~RA10_bit;
    LATB = ~LATB;        // Invert PORTB value
    LATC = ~LATC;        // Invert PORTC value
    Delay_ms(1000);
  }
}