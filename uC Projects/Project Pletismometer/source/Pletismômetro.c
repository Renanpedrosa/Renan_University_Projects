/******************************************************************************

          Pletismômetro utilizando sensor capacitivo
          ==========================================

   Esse programa converte o período de uma onda quadrada para medidas
  de capacitância. Essas medidas de capacitância são então colocadas em
  uma curva de calibração e transformadas em volume. O circuito analógico
  do pletismômetro transforma as medidas de capacitância em uma onda quadrada.
  Será utilizada a interrupção do Capture do PIC para medir esse tempo.

  Autor: Renan Pedrosa
  Data de Início: 22/01/2009
  Arquivo: Pletis_Main.c

  ----------------------------------------------------------------------------

  Esquema de Ligação:

  Sinais
  Pinos 13 e 14      - Cristal 16Mhz
  Pino 16(RC1/T1OSI) - 32kHz input
  Pino 17(RC2/CCP1)  - Period input
  Pino 18(Vusb)      - Caps

  LCD
  Pino 20(RD1)       - LCD-RW
  Pino 21(RD2)       - LCD-RS
  Pino 22(RD3)       - LCD-E
  Pino 27(RD4)       - LCD-D4
  Pino 28(RD5)       - LCD-D5
  Pino 29(RD6)       - LCD-D6
  Pino 30(RD7)       - LCD-D7
  Pino 36(RB3)       - LCD-LED+

  USB
  Pino 23(RC4)       - D-
  Pino 24(RC5)       - D+

  Usart
  Pino 25(RC6)       - TX
  Pino 26(RC7)       - RX

  Pino 31(GND)       - GND
  Pino 32(VDD)       - VDD

  DS1307
  Pino 33(RB0/SDA)   - DS1307/SDA
  Pino 34(RB1/SCL)   - DS1307/SCL

  Pino 35(RB2)       - LED-ON

  Push Buttons
  Pino 37(RB4)       - Button CANCEL/PREVIOUS
  Pino 38(RB5)       - Button OK/NEXT/SAVE
  Pino 39(RB6)       - Button Zero
  Pino 40(RB7)       - Button Mode



  ----------------------------------------------------------------------------

  Cada dado salvo será colocado na memoria utilizando 10 bytes
  Ao atingir a memoria maxima o endereço volta ao inicio e passa a gravar
  os dados por cima.
--------------------------------------------------------------------------------
|   1   |   2   |   3   |   4   |   5   |   6   |   7   |   8   |   9   |   10 |
--------------------------------------------------------------------------------
| vol1  | vol2  | vol3  | vol4  | hora  |  min  |  seg  |  dia  |  mes  |  ano |
--------------------------------------------------------------------------------

******************************************************************************/


//
// DIRETIVAS DEFINE
// ================
//
#define modeBt                PORTB.F7
#define zeroBt                PORTB.F6
#define saveBt                PORTB.F5
#define cancelBt              PORTB.F4

#define LedLcd                PORTB.F3
#define OnLed                 PORTB.F2

#include <built_in.h>







//
// INICIALIZAÇÃO DOS TEXTOS
// ========================
//

//caracteres de uso geral
char cap_msg[] = "Cap:";
char vol_msg[] = "Volume:xx,xxx ml";

//Para modo de comunicação do computador
char comm_msg[] = "Comunicação - PC";
char sendDado_msg[] = "Enviar Dados?";

//Para exibição de data e hora
char hora_msg[] = "->xx:xx:xx";
char data_msg[] = "Data: xx/xx/xx";

//Para acertar o relógio
char digHr_msg[] = "Hora: ";
char digMin_msg[] = "Minutos: ";
char digSeg_msg[] = "Segundos: ";
char digDia_msg[] = "Dia: ";
char digMes_msg[] = "Mes: ";
char digAno_msg[] = "Ano: ";


//
// DECLARAÇÃO DAS VARIÁVEIS
// ========================
//

//Estrutura com os principais CAP
typedef struct
{
mode       : 3; //bits 0, 1 e 2  == vai de 0 a 7
capInit    : 1; //bit 3          == caso o cabo USB esteja conectado
clockDate  : 1; //bit 4          == caso o clock esteja atualizado
cnt        : 1; //bit 5          == contagem de passagem de borda
capTest    : 1; //bit 6          == capTest OK
capScale   : 1; //bit 7          == escala da capacitância
}configCap;


long offset1;              //variável utilizada para estabelecer o valor zero
int cntCap2;              //var2. para contagem do timer1
//long cntRes;               //var. para usar nas operações de pegar capacitancia
unsigned short cntOvrf;    //var. para contagem de overflows

unsigned short High_B1;    //valor dos bytes da borda 1
unsigned short Low_B1;
unsigned short High_B2;    //valor dos bytes da borda 2
unsigned short Low_B2;
int Capacitancia; //Capacitância em picofaradays


unsigned int memCnt;       //var. para contagem do endereço da EEPROM
unsigned short oldstate;   //var. para escaneamento do botões
unsigned short oldstate1;
unsigned short oldstate2;
unsigned short oldstate3;
unsigned short botaoPress;
unsigned short clk;       //Clock Fosc do microcontrolador em MHz


//Variáveis para uso do RTC DS1307
unsigned char sec, min1, hr, day, month, year;
char *txt, tnum[7];
char byteHigh[4];
char byteLow[4];
char clk_msg[4];
configCap CAP;

//Variáveis para o LCD
//--------------------
// Lcd pinout settings
sbit LCD_RW at RD1_bit;      //Coloquei essa variavel por ja esta no projeto da placa
sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

// Pin direction
sbit LCD_RW_Direction at TRISD1_bit;   //Coloquei essa variavel por ja esta no projeto da placa
sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;



//
// FUNÇÕES DE GRAVAÇÃO DA MEMORIA
// ==============================
//
/*void GravaDado()
{
}
void GetDado()
{
}*/
//
// FUNÇÕES DO RTC
// ==============
//
/*void GravaData()
{
}

void GetData()
{
}*/
//
// FUNÇÕES DO CAPACIMETRO E MEDIDOR DE VOLUME
// ==========================================
//

int GetCap(long last_Cap)
{
   if(CAP.capInit == 0)
   {

       PIR1.CCP1IF = 0;            //limpar interrupt flag do capture CCP1
       PIR1.TMR1IF = 0;            // ||        ||     ||  || timer1

       cntOvrf = 0;               //Resetar contagem de overflow
       CAP.cnt = 0;               //Resetar para a primeira borda
       CAP.capTest = 0;           //Resetar indicador de medida completa

       TMR1H = 0;
       TMR1L = 0;
       T1CON = 0x00;               //Iniciar Timer 1 1/4 desligado
       PIE1.CCP1IE = 1;            // setar interrupção do capture CCP1
       PIE1.TMR1IE = 1;            // enable Timer1 interrupt

       CAP.capInit = 1;

       return last_Cap;
   }
   if(CAP.capTest==1)        //Se ocorreu a contagem ,
   {                         //retornar o valor medido
       CAP.capInit = 0;

       Hi(cntCap2) = High_B2;               //Somar o byte superior com o byte
       Lo(cntCap2) = Low_B2;
       //cntRes = cntOvrf*0xFFFF;           //inferior para armazenar a contagem
       //cntCap2 += cntRes;

       OnLed = 1;
       return cntCap2;   //Periodo em microsegundos
   }
   else
   {
         return last_Cap;
   }
}



//
// FUNÇÕES DE COMUNICAÇÃO COM O PC
// ===============================
//

//
// FUNÇÃO DO PRESSIONAR DAS TECLAS
// ==========================
//
unsigned short int KeyScan()
{
    //Botão Mode pressionado?
    if (Button(&PORTB, 7, 1, 1))                // detect logical one on RB7 pin
      oldstate = 1;
    if (oldstate && Button(&PORTB, 7, 1, 0)) {  // detect one-to-zero transition on RB1 pin
      oldstate = 0;
      return 1;
      }

    //Botão Zero pressionado?
    if (Button(&PORTB, 6, 1, 1))                // detect logical one on RB6 pin
      oldstate1 = 1;
    if (oldstate1 && Button(&PORTB, 6, 1, 0)) {  // detect one-to-zero transition on RB1 pin
      oldstate1 = 0;
      return 2;
      }

    //Botão Ok/Next/Save pressionado?
    if (Button(&PORTB, 5, 1, 1))                // detect logical one on RB5 pin
      oldstate2 = 1;
    if (oldstate2 && Button(&PORTB, 5, 1, 0)) {  // detect one-to-zero transition on RB1 pin
      oldstate2 = 0;
      return 3;
      }

    //Botão Cancel/Previous pressionado?
    if (Button(&PORTB, 4, 1, 1))                // detect logical one on RB4 pin
      oldstate3 = 1;
    if (oldstate3 && Button(&PORTB, 4, 1, 0)) {  // detect one-to-zero transition on RB1 pin
      oldstate3 = 0;
      return 4;
      }

    else
    {
     return 0;
    }
}
//
// FUNÇÕES DE ATUALIZAÇÃO DO LCD
// =============================
//
//void CapToLCD(long Cap, char row, char column)
//{
//}
//
// FUNÇÃO DE INICIALIZAÇÃO DE VARIAVEIS
// ====================================
//
void InitMain()
{
  //INTCON2 = 0x80;
  ADCON1 = 0x0F;          //Todos pinos AN são digitais.
  //PORTB = 0;

  TRISB = 0xF0;           //RB7-RB4 >> Input, RB3-RB0 >> Out

  LCD_RW = 1;             //Iniciando o LCD no modo Write(projeto ja na placa)
  LCD_RW_Direction = 0;

  //Configurações do Capture
  TRISC.F2 = 1;			//entrada de pulsos
  TMR1H = 0;
  TMR1L = 0;
  INTCON = 0;
  PIE1 = 0;
  PIR1 = 0;
  CCP1CON = 5;            //Iniciar CCP1CON em capture a cada rising edge
  T1CON = 0x00;           //Iniciar Timer 1 1/4 desligado

  INTCON = 0xC0;              // Set GIE, PEIE(interrupções globais ja setadas)

  CAP.capScale = 0;         //Colocar a escala para o periodo real,
                              //sem multiplicador
  CAP.capInit = 0;
  cntOvrf = 0;
  OnLed = 0;
  Capacitancia = 0;           //Valor inicial a ser mostrado no lcd caso
                              //  não tenha tido leitura de capacitancia
  Lcd_Init();                        // Lcd_Init_EP5, see Autocomplete
  LCD_Cmd(_LCD_CURSOR_OFF);                 // send command to LCD (cursor off)
  LCD_Cmd(_LCD_CLEAR);

}

//
// VETOR DE INTERRUPÇÃO
// =====================
//
void interrupt()
{
   if(PIR1.CCP1IF)            //Ocorreu interrupção do Capture?
   {
      if(CAP.cnt==0)                         //É a primeira borda?
      {
          T1CON.TMR1ON = 1;                      //Ligar Timer1
          LedLcd = 1;
          cntOvrf = 0;
          CAP.cnt = 1;                         //Proxima borda de subida
      }
      else                                    //É a segunda borda!
      {
          High_B2 = CCPR1H;                     //Passando os valores do timer1
          Low_B2 = CCPR1L;
          T1CON.TMR1ON = 0;
          PIE1.CCP1IE = 0;
          PIE1.TMR1IE = 0;
          CAP.capTest = 1;                     //Medida do periodo completa
          CAP.cnt = 0;
      }
      PIR1.CCP1IF = 0;                         //retirar o flag de interrupção
   }
   if(PIR1.TMR1IF)                           //ocorreu overflow entre a
   {                                         //  primeira e segunda medidas?
     cntOvrf++;
     PIR1.TMR1IF = 0;                        //retirar o flag de interrupção
     //OnLed = 1;
   }

}

//
// FUNÇÃO PRINCIPAL
// ================
//
void main()
{

 InitMain();
 CAP.mode = 0x00;
 LCD_Out(1,1,&cap_msg);
 clk = Clock_Khz();
 for(;;)
 {
   switch (CAP.mode) //Loop principal das funções
   {
      //modo Capacitor
      case 0: Capacitancia = GetCap(Capacitancia);
              //OnLed = 1;
              IntToStr(Capacitancia, &tnum);
              ByteToStr(High_B2,&byteHigh);
              ByteToStr(Low_B2,&byteLow);
              LCD_Out(1,5,&tnum);
              LCD_Out(2,3,&byteHigh);
              LCD_Out(2,11,&byteLow);

              break;

      //modo Data e Hora
      case 1: //LedLcd = 0;
              break;

      //modo Volume e Hora
      case 2: //LedLcd = 1;
              break;

      //modo Memoria
      case 3:
              break;

      //modo Comunicação com PC
      case 4:
              break;


   }

   botaoPress = KeyScan();
   //Botão mode pressionado?
   switch(botaoPress)
   {
     case 1: LCD_Cmd(_LCD_CLEAR);
             CAP.mode++;          //Proximo modo
             switch (CAP.mode)
             {
                 //modo Capacitor
                  case 0: LCD_Out(1,1,&cap_msg);

                          break;

                  //modo Data e Hora
                  case 1: LCD_Out(1,1,&data_msg);
                          ShortToStr(clk,&clk_msg);
                          LCD_Out(2,1,&clk_msg);

                          //LedLcd = 0;
                          break;

                  //modo Volume e Hora
                  case 2: LCD_Out(1,1,&vol_msg);
                          LCD_Out(2,3,&hora_msg);
                          //LedLcd = 1;
                          break;

                  //modo Memoria
                  case 3: LCD_Out(1,1,&vol_msg);
                          LCD_Out(2,3,&hora_msg);
                          break;

                  //modo Comunicação com PC
                  case 4: LCD_Out(1,1,&comm_msg);
                          LCD_Out(2,1,&sendDado_msg);
                          //LedLcd = 0;
                          break;

                  //O incremento passou?
                  case 5: CAP.mode = 0; //Voltar ao primeiro
                          LCD_Out(1,1,&cap_msg);
                          LCD_Out(2,1,"H:");
                          LCD_Out(2,9,"L:");
                          break;
             }
             break;

     case 2: LedLcd = 0;
             break;

     case 3: OnLed = 0;
             break;
     }
 }
}
