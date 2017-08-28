/*=======================================================
                       LED DICE
                       --------
Compilador : MikroC PRO v 1.65

Projeto para o PIC16F628, adaptado do livro Advanced Microcontrollers
Project Book. O programa vai variando um numero de 1 a 6 e quando o Usuário
aperta o botão 1 o dado exibe este número nos LEDs. Como o clock é de 4MHz,
o numero varia tão rapido que é aleatório.

Oscilador: 4MHz e 37kHz

Descrição das portas:
Pino 1 - VDD (5V)
Pino 2 - GP5 -> LEDs 1 e 5
Pino 3 - GP4 -> Botão 1
Pino 4 - GP3 -> Botão 2
Pino 5 - GP2 -> LEDs 2 e 6
Pino 6 - GP1 -> LEDs 3 e 7
Pino 7 - GP0 -> LED 4
Pino 8 - Vss (0V)

Mask GPIO
1 - 0b000001
2 - 0b000100
3 - 0b000101
4 - 0b100010
5 - 0b100011
6 - 0b100110


Autor:   Renan Pedrosa
Univ.:   CEFET-MG
Arquivo: LED Dice.c
//=======================================================*/

//Definições das Portas do PIC
#define  LED1_5   GPIO.B5
#define  LED2_6   GPIO.B2
#define  LED3_7   GPIO.B1
#define  LED4     GPIO.B0

#define  Botao1   GPIO.B4
#define  Botao2   GPIO.B3

unsigned char bot1,bot2;
unsigned char X;

//Essa função retorna um número inteiro aleatório entre 1 e Lim
unsigned char Numero(int Lim, int Y)
{
  unsigned char Result;
  static unsigned int Y;
  Y = X + TMR0;
  Y = (Y * 32718 + 3) % 32749;
  Result = ((Y % Lim) + 1);
  return Result;
}

void interrupt()
{
if (T0IF_bit) {
    T0IF_bit = 0;        // clear TMR0IF
    //TMR0   = 0;
  }
if (GPIF_bit) {
   GPIF_bit = 0;
   bot1 = Botao1;
   bot2 = Botao2;
   }
}

void main ()
{
  unsigned char i;

  unsigned char J;
  unsigned char min = 1;
  unsigned char Pattern;
  unsigned char last_Pattern;
  unsigned char DADO[] = {0,0x01,0x04,0x05,0x22,0x23,0x26};

  GPIO   = 0;                          //Desligar todos os LEDs
  TRISIO = 0b011000;                   //Portas GP4 e GP3 são entrada
  OSCCAL = 0x38;
  IOC = 0x18;
  INTCON = 0xE8;
  
  T0CS_bit = 0;
  T0SE_bit = 0;
  PSA_bit = 0;
  PS2_bit = 0;
  PS1_bit = 0;
  PS0_bit = 0;


  for (;;)                             //Loop infinito
  {
      //Testando se o Botão 1 foi pressionado
      if (bot1 == 0)
        {
          for(i = 0; i<2; i++)
          {
          J = Numero(6,min);
          Pattern = DADO[J];          //Pegar padrao dos LEDs
          GPIO = Pattern;             //Ligar LEDs correspondentes
          Delay_ms(400);              //Atraso de 400ms
          GPIO = 0;                   //Desligar todos os LEDs
          }
          J = Numero(6,min);
          Pattern = DADO[J];          //Pegar padrao dos LEDs
          GPIO = Pattern;             //Ligar LEDs correspondentes
          Delay_ms(2500);             //Atraso de 2 segundos
          GPIO = 0;                   //Desligar todos os LEDs
          //J = 0;                      //Inicializa o contador
        }

      //Testando se o botão 2 foi pressionado
      if (bot2 == 0)
        {
          GPIO = Pattern;             //Ligar LEDs correspondentes
          Delay_ms(1000);             //Atraso de 3 segundos
          GPIO = 0;                   //Desligar todos os LEDs
        }

        
        //asm SLEEP;
        
        X++;                          //Soma o contador
        if(X == 7) X = 1;             //Mantem a contagem de 1 a 6

  }
 
}