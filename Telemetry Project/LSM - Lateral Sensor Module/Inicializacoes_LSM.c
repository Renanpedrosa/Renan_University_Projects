 //
 // Definições para Velocidade CAN
 //               //Vel 500 kpbs      //Para 1Mbps usar esses:
 #define SJW      1                   //   4
 #define BRP      4                   //   1
 #define PHSEG1   3                   //   8
 #define PHSEG2   3                   //   6
 #define PROPSEG  1                   //   5

  #include "__Lib_ECAN1_Defs.h"
  #include "PGA_Drivers_LSM.h"
  
//Variáveis do CAN - Usados para fazer o exemplo de comunicação CAN funcionar.
unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;  // can flags
unsigned int Rx_Data_Len;                                    // received data length in bytes
char RxTx_Data[8];                                           // can rx/tx data buffer
char Msg_Rcvd;                                               // reception flag
unsigned long Rx_ID;

void InitClock()
{

 //Configurando o PLL p/ um cristal de 20MHz p/ um clock aproximado de 80MHz
   CLKDIV &= 0xFFE0;   //Zera os bits do PLL prescaler que serão modificados
   CLKDIV |= 0x0003;   //PLL prescaler = N1 = 5
   PLLFBD = 38;        //PLL multiplier = M = 40
   CLKDIV &= 0xFF3F;   //PLL postscaler = N2 = 2
   /*FOSC=FIN*M/(N1*N2). Logo, para um cristal de 20MHz, o clock será de 80MHz.
   Para o dsPIC33F, FCY=FOSC/2. Portanto, neste caso, ele opera a 40MIPS.*/

   /*
   //Configurando o PLL p/ um cristal de 16MHz p/ um clock aproximado de 80MHz
   CLKDIV &= 0xFFE0;   //Zera os bits do PLL prescaler que serão modificados
   CLKDIV |= 0x0002;   //PLL prescaler = N1 = 4
   PLLFBD = 38;        //PLL multiplier = M = 40
   CLKDIV &= 0xFF3F;   //PLL postscaler = N2 = 2
   */
   /*FOSC=FIN*M/(N1*N2). Logo, para um cristal de 16MHz, o clock será de 80MHz.
   Para o dsPIC33F, FCY=FOSC/2. Portanto, neste caso, ele opera a 40MIPS.*/

   //Acende o LED para teste
   //LED = 1;

   //LED2 = CF_bit;

   //while(OSCCONbits.CF != 1);
   //LED = 0;

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
    //LED = 0;

}


void InitPorts()
{
//Configura os pinos como analógicos ou digitais ('1'Dig, '0'An)
   AD1PCFGL = 0x1800;

   //Configura todas os pinos analógicos como entrada
   TRISA0_bit  = 1;        //AN0 - GPIN0
   TRISA1_bit  = 1;        //AN1 - GPIN1
   TRISB0_bit  = 1;        //AN2 - GPIN2
   TRISB1_bit  = 1;        //AN3 - GPIN3
   TRISB2_bit  = 1;        //AN4 - GPIN4
   TRISB3_bit  = 1;        //AN5 - GPIN5
   TRISC0_bit  = 1;        //AN6 - ITELEMETRIA
   TRISB15_bit = 1;        //AN9 - PGA_OUT

   //Configura todas os pinos digitais
   TRISA8_bit  = 0;        //LED
   TRISA9_bit  = 1;        //Botão na caixa
   TRISB7_bit  = 1;        //INT0 / RP7 / CN23 - Entrada de Rotação - DIG1
   TRISB10_bit = 0;        //CS   - Cartão SD
   TRISB11_bit = 0;        //SDO2 - Cartão SD
   TRISB12_bit = 0;        //SCK2 - Cartão SD
   TRISB13_bit = 1;        //SDI2 - Cartão SD
   TRISC3_bit  = 0;        //SCK  - PGA
   TRISC4_bit  = 0;        //SDO  - PGA
   TRISC5_bit  = 0;        //CS   - PGA
   TRISC8_bit  = 0;        //C1TX - CanBus
   TRISC9_bit  = 1;        //C1RX - CanBus

  Unlock_IOLOCK();
  PPS_Mapping(19, _OUTPUT, _SCK1OUT); //Configura o pino 36 como saída do clock do SPI1 - PGA
  PPS_Mapping(20, _OUTPUT, _SDO1);    //Configura o pino 37 como saída serial do SPI1 - PGA
  PPS_Mapping(11, _OUTPUT, _SDO2);    //Configura o pino 9 como saída serial do SPI1 - PGA
  PPS_Mapping(12, _OUTPUT, _SCK2OUT); //Configura o pino 10 como saída do clock do SPI2  - Cartão SD
  PPS_Mapping(13, _INPUT, _SDI2);     //Configura o pino 9 como entrada serial do SPI2 - Cartão SD
  PPS_Mapping(7, _INPUT, _IC1);      //Configura o pino 43 como entrada do Input Capture 1 - Medir RotaçãO (DIG1)
  PPS_Mapping(24, _OUTPUT, _C1TX);     //Configura o pino 4 como TX do CAN
  PPS_Mapping(25, _INPUT, _CIRX);      //Configura o pino 5 como RX da CAN
  Lock_IOLOCK();
}


// Inicializa o módulo CAN com velocidade de 500 kbps a partir dos valores do ECAN1Initialize
// Valores de tempo baseados no Manual do ECAN do dsPIC33F - páginas 56 a 59. Valores na página 59.
// 33F Ref Manual Part 1 -> Section 21. Enhanced Controller Area Network (ECAN) - dsPIC33F/PIC24H FRM
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

  ECAN1SelectTxBuffers(0x00FF);                    // select transmit buffers
                                                   // 0x000F = buffers 0:3 are transmit buffers
  ECAN1SetOperationMode(_ECAN_MODE_CONFIG,0xFF);   // set CONFIGURATION mode

  ECAN1SetMask(_ECAN_MASK_0, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask1 bits to ones
  ECAN1SetMask(_ECAN_MASK_1, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask2 bits to ones
  ECAN1SetMask(_ECAN_MASK_2, -1, _ECAN_CONFIG_MATCH_MSG_TYPE & _ECAN_CONFIG_XTD_MSG);            // set all mask3 bits to ones
//  ECAN1SetFilter(_ECAN_FILTER_10,FSM_CTRL, _ECAN_MASK_2, _ECAN_RX_BUFFER_7, _ECAN_CONFIG_XTD_MSG); // set id of filter10 to 1st node ID

                                                                                                 // assign buffer7 to filter10
  ECAN1SetOperationMode(_ECAN_MODE_NORMAL,0xFF);   // set NORMAL mode
}

void InitTimersCapture()
{
  // Initializa Timer 2 for the Input Capture 1, 2 Module - Página 192 do datasheet dsPIC33
  T2CONbits.TCKPS = 0b11; //1:256 prescaler(Período de 6,4us e estouro em 419ms)
  T2CONbits.T32 = 0;      //Funciona como um timer de 16bits
  T2CONbits.TCS = 0;      //Clock interno (Fosc/2)
  T2CONbits.TON = 1;      //Liga o Timer 2

  // Initialize Capture Module  (Captura de velocidade de rodas) - Página 196 do datasheet dsPIC33
  IC1CONbits.ICM=0b00; // Desabilita módulo Input Capture 1
  IC1CONbits.ICTMR= 1; // Seleciona Timer2 como base de tempo do IC1
  IC1CONbits.ICI= 0b01; // Interrupt on every second capture event
  IC1CONbits.ICM= 0b011; // Generate capture event on every Rising edge

  // Colocar o priority level do Input Capture 1, zerar o flag da interrupção e habilitar interrupções do IC1
  IPC0bits.IC1IP = 2; // Setup IC1 interrupt priority level
  IFS0bits.IC1IF = 0; // Clear IC1 Interrupt Status Flag
  IEC0bits.IC1IE = 1; // Enable IC1 interrupt

}

/*
//Retirado do exemplo -> CE143_Timer_Period
void Init_Timer1( void )
{

        T1CON = 0;              // Timer reset
         IFS0bits.T1IF = 0;      // Reset Timer1 interrupt flag
        IPC0bits.T1IP = 6;      // Timer1 Interrupt priority level=4
         IEC0bits.T1IE = 1;      // Enable Timer1 interrupt
         TMR1=  0x0000;
        PR1 = 0xFFFF;           // Timer1 period register = ?????
        T1CONbits.TON = 1;      // Enable Timer1 and start the counter

}
*/
//Inicialização geral de outros periféricos
void InitMain()
{

  //Inicializa do conversor A/D
  ADC1_Init_Advanced(_ADC_12bit, _ADC_INTERNAL_REF);

  //Inicializa o SPI para comunicar com o PGA - Ver datasheet do MCP6S28 para mais detalhes
  SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_8, _SPI_PRESCALE_PRI_1, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_IDLE_2_ACTIVE);

  //Inicializar com ganho 1.
  PGA_Set_Gain(1);

}