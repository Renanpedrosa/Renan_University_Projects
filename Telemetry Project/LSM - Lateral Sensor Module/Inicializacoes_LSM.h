 //
 //  Definições de portas gerais
 //

 #define LED   LATA8_bit   //LED
 #define BT    RA9_bit     //Botão
 #define DIGIN RB7_bit     //Entrada digital. Obs: pino remapeável ainda sem utilidade

 //
 //   Defines p/ canais analógicos
 //      Sinal  |  ANx

 #define AN_GPIN0    0   //Entrada analógica 0 geral do módulo LSM
 #define AN_GPIN1    1   //Entrada analógica 1 geral do módulo LSM
 #define AN_GPIN2    2   //Entrada analógica 2 geral do módulo LSM
 #define AN_GPIN3    3   //Entrada analógica 3 geral do módulo LSM
 #define AN_GPIN4    4   //Entrada analógica 4 geral do módulo LSM
 #define AN_GPIN5    5   //Entrada analógica 5 geral do módulo LSM
 #define AN_ICAN_BUS 6   //Corrente drenada pelo CAN (Saída do ACS713)
 #define AN_PGA      9   //Saída do MUX MCP6S28  //Canal analógico do PIC que o PGA está conectado
 
 //Definições para usar o PGA (ver datasheet MCP6S28)
#define PGA_GAIN1        0b00000000
#define PGA_GAIN2        0b00000001
#define PGA_GAIN4        0b00000010
#define PGA_GAIN5        0b00000011
#define PGA_GAIN8        0b00000100
#define PGA_GAIN10       0b00000101
#define PGA_GAIN16       0b00000110
#define PGA_GAIN32       0b00000111

//Definições de ganho do PGA (ver datasheet MCP6S28)
#define PGA_CH0          0x00
#define PGA_CH1          0x01
#define PGA_CH2          0x02
#define PGA_CH3          0x03
#define PGA_CH4          0x04
#define PGA_CH5          0x05
#define PGA_CH6          0x06
#define PGA_CH7          0x07


//Sinais dos Sensores
unsigned GPIN0;     //Entrada analógica 0 geral do módulo LSM//Tensão na bateria
unsigned GPIN1;     //Entrada analógica 1 geral do módulo LSM//Corrente na bateria
unsigned GPIN2;     //Entrada analógica 2 geral do módulo LSMTensão do sistema elétrica
unsigned GPIN3;     //Entrada analógica 3 geral do módulo LSMCorrente do sistema elétrico
unsigned GPIN4;     //Entrada analógica 4 geral do módulo LSM//Corrente do CAN bus
unsigned GPIN5;     //Entrada analógica 5 geral do módulo LSMSuspensão dianteira esquerda
unsigned ICAN_BUS;  //Corrente do Barramento CAN
unsigned DIG1;      //Entrada de rotação
unsigned PGA0;      //Entradas do PGA. resultado da conversão A/D
unsigned PGA1;      //
unsigned PGA2;      //
unsigned PGA3;      //
unsigned PGA4;      //
unsigned PGA5;      //
//unsigned PGA6;      // Canais não conectados
//unsigned PGA7;      //
char PGA0_Gain;     // Ganho do PGA no momento da aquisição do canal 0 (CH0)
char PGA1_Gain;     // Ganho do PGA no momento da aquisição do canal 1 (CH1)
char PGA2_Gain;     // Ganho do PGA no momento da aquisição do canal 2 (CH2)
char PGA3_Gain;     // Ganho do PGA no momento da aquisição do canal 3 (CH3)
char PGA4_Gain;     // Ganho do PGA no momento da aquisição do canal 4 (CH4)
char PGA5_Gain;     // Ganho do PGA no momento da aquisição do canal 5 (CH5)
//char PGA6_Gain;     // Ganho do PGA no momento da aquisição do canal 0 (CH0) //Não conectados na placa
//char PGA7_Gain;     // Ganho do PGA no momento da aquisição do canal 0 (CH0)
char PGA_01_Gain;   //Ganho do PGA dos canais 0 e 1. No high nibble está o canal 0, no low nibble está o canal 1
char PGA_23_Gain;   //Ganho do PGA dos canais 0 e 1. No high nibble está o canal 2, no low nibble está o canal 3
char PGA_45_Gain;   //Ganho do PGA dos canais 0 e 1. No high nibble está o canal 4, no low nibble está o canal 5


void InitClock();
void InitPorts();
void InitTimersCapture();
void InitCAN();
void InitMain();