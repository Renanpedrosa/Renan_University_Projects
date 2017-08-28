
 

 
 
 //
 //  Definições de portas gerais
 //

 #define LED1   LATA8_bit   //LED
 #define LED2   LATA9_bit   //LED
 #define BT    RA4_bit     //Botão

 //
 //   Defines p/ canais analógicos
 //      Sinal  |  ANx
 #define ANA_0     8
 #define ANA_1     7
 #define ANA_2     6
 #define ANA_3     5
 #define ANA_4     4
 #define ANA_5     3
 #define ANA_6     2
 #define ANA_7     1
 #define ANA_8     0
 #define ANA_9     9
 #define ANA_10    11
 #define ANA_11    10

 //
 //   Defines p/ portas digitais
 //      Sinal  |  Port Register
 #define DIG_1     RB11_bit
 #define DIG_2     RB12_bit
 #define DIG_3     RB10_bit
 #define DIG_4     RC9_bit
 #define DIG_5     RB4_bit
 #define DIG_6     RA10_bit
 #define DIG_7     RB7_bit
 #define DIG_8     RA7_bit

 #define CR 0x0D   //Carriage return: posiciona o cursor no início da linha
 #define LF 0x0A   //Linefeed: equivalente a pressionar ENTER em um editor



//Funções de Inicialização
void InitClock();
void InitPorts();
void InitCAN();
void InitTimersCapture();
void InitMain();
