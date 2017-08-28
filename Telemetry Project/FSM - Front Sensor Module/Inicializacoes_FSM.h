
#define LED    LATA10_bit   //LED
#define GPtest LATA7_bit    //Pino disponibilizado para Debug, colocando uma sonda de ociloscópio
#define AUX    LATB2_bit    //Pino do ICSP para Debug (Pode-se vizualisar ele no Logic Test do programa do Pickit2)
#define BT1    RB4_bit      //Botão 1 no painel
#define BT2    RA4_bit      //Botão 2 no painel
#define BT3    RB1_bit      //Botão 3 na placa
#define BT4    RB0_bit      //Botão 4 na placa
#define GPIN_5 RC9_bit      //Uso Geral - Entrada Digital 3.3V (Suporta 5V)
#define GPFall RA1_bit      //Uso Geral - Jumper de acionamento do datalogger (Pode ser usado em futuras aplicações


//defines p/ canais analógicos
//        Sinal | ANx

#define GPIN_0    6   //Entrada 5V  - Sonda Lambda
//#define GPIN_1    7   //Entrada 12V - Velocidade FE
//#define GPIN_2    8   //Entrada 12V - Velocidade FD
//#define GPIN_3    5   //Entrada 5V  - Infravermelho (RPM)
#define GPIN_4    9   //Entrada 3.3V - Potenciômetro
#define GPIN_6    0   //Entrada 3.3V - Potenciômetro
#define ACCEL_X  10   //Acelerômetro no eixo X
#define ACCEL_Y  12   //Acelerômetro no eixo X
#define ACCEL_Z  11   //Acelerômetro no eixo X

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







//Texto dos Sensores do BSM

const char ID_FSM_ACCEL1[]  = "$01,";
const char ID_FSM_ACCEL2[]  = "$02,";
const char ID_FSM_GPIO1[]   = "$03,";
const char ID_FSM_GPIO2[]   = "$04,";
const char ID_FSM_CTRL[]    = "$09,";
const char ID_LSM_ELET_1[]  = "$10,";
const char ID_LSM_ELET_2[]  = "$11,";
const char ID_LSM_PGA_1[]   = "$12,";
const char ID_LSM_PGA_2[]   = "$13,";
const char ID_BSM_ANA_1[]   = "$14,";
const char ID_BSM_ANA_2[]   = "$15,";
const char ID_BSM_ANA_3[]   = "$16,";
const char ID_BSM_DIG_1[]  =  "$17,";
const char ID_BSM_DIG_2[]  =  "$18,";
const char ID_GPS_1[]   = "$19,";
const char ID_GPS_2[]   = "$20,";
const char ID_GPS_3[]   = "$21,";
const char ID_GPS_TIME_1[]  = "$22,";
const char ID_GPS_TIME_2[]  = "$23,";

void InitClock();
void InitPorts();
void InitTimersCapture();
void InitCAN();
void InitMain();