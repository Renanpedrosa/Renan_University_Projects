//Inicializacoes FSM

#include "Funcoes_ADXL.h"
//#include "ECAN_IDs.h"



//Conexões do SPI
sbit ADXL_CS at LATC5_bit;                  //Acelerômetro ADXL345
sbit ADXL_CS_Direction at TRISC5_bit;

sbit Expander_CS at LATA8_bit;              //Expansor de portas para controlar o LCD e LEDs do painel
sbit Expander_CS_Direction at TRISA8_bit;

sbit  SPExpanderRST at RA9_bit;             //Reset do Expansor MCP23S17 , usado para controlar o LCD e os LEDs do painel
sbit  SPExpanderCS  at RA8_bit;             //ChipSelect do Expansor MCP23S17
sbit  SPExpanderRST_Direction at TRISA9_bit;
sbit  SPExpanderCS_Direction  at TRISA8_bit;

sbit Mmc_Chip_Select at LATB8_bit;                    //Cartão de memória SD
sbit Mmc_Chip_Select_Direction at TRISB8_bit;

void InitClock()
{

//
   // Início da configuração de Clock para rodar a 40MIPS (80MHz)
   //

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


   //LED2 = CF_bit;
   //while(OSCCONbits.CF != 1);

   //Comando em Assembly necessário para fazer a mudança do clock
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

   //
   // Fim da configuração de Clock para rodar a 40MIPS (80MHz)
   //
}

void InitPorts()
{
  //Configura os pinos como analógicos ou digitais ('1'Dig, '0'An)
  AD1PCFGL = 0x01BE;

  //Configurando os pinos digitais
  TRISA10_bit = 0;        //Seta o pino do Led como uma saída digital
  TRISA7_bit  = 0;        //Seta o pino do GPteste como como uma saída digital
  TRISB2_bit  = 0;        //Seta o pino do AUX como como uma saída digital
  TRISB4_bit  = 1;        //Seta o pino do botão 1 como uma entrada digital
  TRISA4_bit  = 1;        //Seta o pino do botão 2 como uma entrada digital
  TRISB1_bit  = 1;        //Seta o pino do botão 3 como uma entrada digital
  TRISB0_bit  = 1;        //Seta o pino do botão 4 como uma entrada digital
  TRISA1_bit  = 1;        //Seta o pino do jumper como uma entrada digital
  TRISA2_bit  = 1;        //Clock In
  TRISA3_bit  = 0;        //Clock Out

  //Configura todas os pinos analógicos como entrada
  TRISC0_bit  = 1;        //AN6 - GPIN_0
  TRISC1_bit  = 1;        //AN7 - GPIN_1 (Digital para VelFE)
  TRISC2_bit  = 1;        //AN8 - GPIN_2 (Digital para VelFD)
  TRISB3_bit  = 1;        //AN5 - GPIN_3 (Digital para RPM)
  TRISB15_bit = 1;        //AN9 - GPIN_4
  TRISA0_bit  = 1;        //AN0 - GPIN_6
  TRISB14_bit = 1;        //AN12 - Acelerômetro eixo X
  TRISB12_bit = 1;        //AN10 - Acelerômetro eixo Y
  TRISB13_bit = 1;        //AN11 - Acelerômetro eixo Z

  //Configura os pinos de comunicação como entradas e saídas
  ADXL_CS_Direction = 0;         //CS - Adxl345
  Mmc_Chip_Select_Direction = 0; //CS - Cartão SD
  SPExpanderRST_Direction = 0;   //Reset - Expansor SPI MCP23S17
  SPExpanderCS_Direction = 0;    //ChipSelect - Expansor SPI MCP23S17
  TRISB5_bit = 0;                //SPI - SCK
  TRISB6_bit = 1;                //SPI - SDI
  TRISB7_bit = 0;                //SPI - SDO
  TRISC8_bit = 0;                //Uart1 - TX  Conectado ao rádio da telemetria
  TRISC7_bit = 1;                //Uart1 - RX
  TRISB9_bit = 0;                //Uart2 - TX  Conectado ao GPS
  TRISC6_bit = 1;                //Uart2 - RX  Conectado ao GPS
  TRISC3_bit = 0;                //CAN bus TX
  TRISC4_bit = 1;                //CAN bus RX
  ADXL_CS = 1;

  //Configurando as portas remapeáveis
  Unlock_IOLOCK();
  PPS_Mapping(5, _OUTPUT, _SCK1OUT); //Configura o pino 41 como saída do clock do SPI1
  PPS_Mapping(6, _INPUT, _SDI1);     //Configura o pino 42 como entrada serial do SPI1
  PPS_Mapping(7, _OUTPUT, _SDO1);    //Configura o pino 43 como saída serial do SPI1
  PPS_Mapping(24, _OUTPUT, _U1TX);   //Configura o pino 4 como TX da UART1
  PPS_Mapping(23, _INPUT, _U1RX);    //Configura o pino 3 como RX da UART1
  PPS_Mapping(9, _OUTPUT, _U2TX);    //Configura o pino 1 como TX da UART2
  PPS_Mapping(22, _INPUT, _U2RX);    //Configura o pino 2 como RX da UART2
  PPS_Mapping(19, _OUTPUT, _C1TX);   //Configura o pino 36 como TX do CAN
  PPS_Mapping(20, _INPUT, _CIRX);    //Configura o pino 37 como RX do CAN
  PPS_Mapping(17, _INPUT, _IC1);     //Configura o pino 26 (GPIN1) como Entrada do Input Capture 1 (Velocidade Roda)
  PPS_Mapping(18, _INPUT, _IC2);     //Configura o pino 27 (GPIN2) como Entrada do Input Capture 2 (Velocidade Roda)
  PPS_Mapping(3, _INPUT, _IC7);     //Configura o pino 24 (GPIN3) como Entrada do Input Capture 7   (Rotação)
  Lock_IOLOCK();
}



void InitTimersCapture()
{
  //Inicializando Timer 1 para funcionar como tempo para enviar os dados num tempo certo
  IEC0.F3 = 1;                     // Enable Timer1 interrupt
  TMR1 = 0xE795;                   // Timer1 starts counting from 57722
  T1CON.F5 = 1;                    // Set Timer1 Prescaler to 1:256
  T1CON.F4 = 1;
  IFS0.F3 = 0;                     // Clear Timer1 interrupt flag
  //Note: Timer1 is set to generate interrupt on 40ms interval

  // IFS1.F8 = 0;                     // Clear UART receive interrupt flag
  // IEC1.F8 = 1;                     // Enable UART receive interrupt
  T1CON.F15 = 1;                   // Start Timer 1*/
  
  //Inicializa Timer 5 para fazer a leitura do buffer da porta serial. Caso tenha algum dado ele lê e armazena em outro buffer.
  T5CONbits.TCKPS = 0b01; //1:8 prescaler(Período de 0,2us e estouro em 13,1ms)
  T5CONbits.TCS = 0;      //Clock interno (Fosc/2)
  TMR5 = 0xF447;          //Carregando o Timer 5 para gerar uma interrupção a cada 600us
  T5IE_bit = 1;
  T5IF_bit = 0;
  T5CONbits.TON = 1;      //Liga o Timer 2

  // Initializa Timer 2 for the Input Capture 1 and 2 Module GPIN1 e GPIN2
  T2CONbits.TCKPS = 0b11; //1:256 prescaler(Período de 6,4us e estouro em 419ms)
  T2CONbits.T32 = 0;      //Funciona como um timer de 16bits
  T2CONbits.TCS = 0;      //Clock interno (Fosc/2)
  T2CONbits.TON = 1;      //Liga o Timer 2

  // Initializa Timer 3 for the Input Capture 7 Module   GPIN3
  T3CONbits.TCKPS = 0b10; //1:64 prescaler(Período de 1,6us e estouro em 104ms)
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

void InitMain()
{
  ADC1_Init_Advanced(_ADC_12bit, _ADC_INTERNAL_REF);

  UART1_Init(115200);             // Initialize UART1 module at 115200 bps
  Delay_ms(1000);                  // Wait for UART module to stabilize
  
  UART1_Write_Text("Inicializando módulo...");
  UART1_Write(0X0D);
  UART1_Write(0X0A);

  UART2_Init(57600);              // Initialize UART2 module at 19200 bps for GPS
  U2MODEbits.UARTEN = 0;
  U2RXIF_bit = 0;                  //Zerar flag de interrupções
  IPC7bits.U2RXIP = 0;             // Definir prioridade (baixa)
  U2STAbits.URXISEL = 0b11;        //Interrupção a cada recebimento de caractere
  IFS1bits.U2TXIF = 0;	// Clear the Transmit Interrupt Flag
  IEC1bits.U2TXIE = 1;	// Enable Transmit Interrupts
  IFS1bits.U2RXIF = 0;	// Clear the Recieve Interrupt Flag
  IEC1bits.U2RXIE = 1;	// Enable Recieve Interrupts
  U2MODEbits.UARTEN = 1;
  Delay_ms(1000);                  // Wait for UART2 module to stabilize


  //Colocando para exibir apenas mensagens de RMC at 1Hz
  UART2_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29");
  UART2_Write(0x0D);
  UART2_Write(0x0A);
  Delay_ms(500);
  //Colocando para GPS de 5Hz
  UART2_Write_Text("$PMTK220,200*2C");
  UART2_Write(0x0D);
  UART2_Write(0x0A);
  Delay_ms(500);


  //UART2_Init(57600);              // Initialize UART2 module at 19200 bps for GPS
 // Delay_ms(200);                  // Wait for UART2 module to stabilize

  SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_8, _SPI_PRESCALE_PRI_4,_SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);

  ADXL345_Init();
  



}