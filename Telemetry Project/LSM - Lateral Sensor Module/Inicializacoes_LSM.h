 //
 //  Defini��es de portas gerais
 //

 #define LED   LATA8_bit   //LED
 #define BT    RA9_bit     //Bot�o
 #define DIGIN RB7_bit     //Entrada digital. Obs: pino remape�vel ainda sem utilidade

 //
 //   Defines p/ canais anal�gicos
 //      Sinal  |  ANx

 #define AN_GPIN0    0   //Entrada anal�gica 0 geral do m�dulo LSM
 #define AN_GPIN1    1   //Entrada anal�gica 1 geral do m�dulo LSM
 #define AN_GPIN2    2   //Entrada anal�gica 2 geral do m�dulo LSM
 #define AN_GPIN3    3   //Entrada anal�gica 3 geral do m�dulo LSM
 #define AN_GPIN4    4   //Entrada anal�gica 4 geral do m�dulo LSM
 #define AN_GPIN5    5   //Entrada anal�gica 5 geral do m�dulo LSM
 #define AN_ICAN_BUS 6   //Corrente drenada pelo CAN (Sa�da do ACS713)
 #define AN_PGA      9   //Sa�da do MUX MCP6S28  //Canal anal�gico do PIC que o PGA est� conectado
 
 //Defini��es para usar o PGA (ver datasheet MCP6S28)
#define PGA_GAIN1        0b00000000
#define PGA_GAIN2        0b00000001
#define PGA_GAIN4        0b00000010
#define PGA_GAIN5        0b00000011
#define PGA_GAIN8        0b00000100
#define PGA_GAIN10       0b00000101
#define PGA_GAIN16       0b00000110
#define PGA_GAIN32       0b00000111

//Defini��es de ganho do PGA (ver datasheet MCP6S28)
#define PGA_CH0          0x00
#define PGA_CH1          0x01
#define PGA_CH2          0x02
#define PGA_CH3          0x03
#define PGA_CH4          0x04
#define PGA_CH5          0x05
#define PGA_CH6          0x06
#define PGA_CH7          0x07


//Sinais dos Sensores
unsigned GPIN0;     //Entrada anal�gica 0 geral do m�dulo LSM//Tens�o na bateria
unsigned GPIN1;     //Entrada anal�gica 1 geral do m�dulo LSM//Corrente na bateria
unsigned GPIN2;     //Entrada anal�gica 2 geral do m�dulo LSMTens�o do sistema el�trica
unsigned GPIN3;     //Entrada anal�gica 3 geral do m�dulo LSMCorrente do sistema el�trico
unsigned GPIN4;     //Entrada anal�gica 4 geral do m�dulo LSM//Corrente do CAN bus
unsigned GPIN5;     //Entrada anal�gica 5 geral do m�dulo LSMSuspens�o dianteira esquerda
unsigned ICAN_BUS;  //Corrente do Barramento CAN
unsigned DIG1;      //Entrada de rota��o
unsigned PGA0;      //Entradas do PGA. resultado da convers�o A/D
unsigned PGA1;      //
unsigned PGA2;      //
unsigned PGA3;      //
unsigned PGA4;      //
unsigned PGA5;      //
//unsigned PGA6;      // Canais n�o conectados
//unsigned PGA7;      //
char PGA0_Gain;     // Ganho do PGA no momento da aquisi��o do canal 0 (CH0)
char PGA1_Gain;     // Ganho do PGA no momento da aquisi��o do canal 1 (CH1)
char PGA2_Gain;     // Ganho do PGA no momento da aquisi��o do canal 2 (CH2)
char PGA3_Gain;     // Ganho do PGA no momento da aquisi��o do canal 3 (CH3)
char PGA4_Gain;     // Ganho do PGA no momento da aquisi��o do canal 4 (CH4)
char PGA5_Gain;     // Ganho do PGA no momento da aquisi��o do canal 5 (CH5)
//char PGA6_Gain;     // Ganho do PGA no momento da aquisi��o do canal 0 (CH0) //N�o conectados na placa
//char PGA7_Gain;     // Ganho do PGA no momento da aquisi��o do canal 0 (CH0)
char PGA_01_Gain;   //Ganho do PGA dos canais 0 e 1. No high nibble est� o canal 0, no low nibble est� o canal 1
char PGA_23_Gain;   //Ganho do PGA dos canais 0 e 1. No high nibble est� o canal 2, no low nibble est� o canal 3
char PGA_45_Gain;   //Ganho do PGA dos canais 0 e 1. No high nibble est� o canal 4, no low nibble est� o canal 5


void InitClock();
void InitPorts();
void InitTimersCapture();
void InitCAN();
void InitMain();