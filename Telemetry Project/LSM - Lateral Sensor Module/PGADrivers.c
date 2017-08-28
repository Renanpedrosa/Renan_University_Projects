///////////////////////////////////////////////////////////////////
//                                                               //
//   Drivers para leitura do NTC utilizando PGAS MCP6S28         //
//   ---------------------------------------------------         //
//                                                               //
///////////////////////////////////////////////////////////////////


//Fun��o driver para esse microcontrolador
//Os pgas utilizados s�o dois MCP6S28, com 8 entradas cada.

sbit SPI_CS_PGA1  at LATC5_bit;                     //Chip-Select PGA1(MCP6S28)
//sbit SPI_CS_PGA2  at LATA3_bit;                     //Chip-Select PGA2(MCP6S28)

//Defini��es para usar o PGA (ver datasheet MCP6S28)
#define PGA_Inst_WriteCH 0b01000001
#define PGA_Inst_WriteGN 0b01000000
#define PGA_Inst_SHTDOWN 0b00100000
#define PGA_GAIN1        0b00000000
#define PGA_GAIN2        0b00000001
#define PGA_GAIN4        0b00000010
#define PGA_GAIN8        0b00000100

#define PGA_CH0          0x00
#define PGA_CH1          0x01
#define PGA_CH2          0x02
#define PGA_CH3          0x03
#define PGA_CH4          0x04
#define PGA_CH5          0x05
#define PGA_CH6          0x06
#define PGA_CH7          0x07

#define AN_PGA1          9        //Canais anal�gicos do PIC que os dois PGAs est�o conectados
//#define AN_PGA2          6

#define MAXOVERSAMPLE 255
unsigned int Result[MAXOVERSAMPLE];    //Vetor de medidas de temperatura

//char ADC_Out[7];            //Usado para exibir numeros inteiro atraves da
//                            // fun��o IntToStr(int input,char *output[7]).

void SPI_PGA_Init()
{
  SPI_CS_PGA1 = 1;
  SPI_CS_PGA2 = 1;

  //SPI_SCK = 0;         //Colocando o clock em '0', nivel normal para SPI 0,0

  //Inicializando o modulo SPI Master Fosc/16 (3MHz) e Clock 0,0
  SSP2STAT = 0xC0;
  SSP2CON1 = 0x21;

  //SPI_Remappable_Init_Advanced(_SPI_REMAPPABLE_MASTER_OSC_DIV16, _SPI_REMAPPABLE_DATA_SAMPLE_MIDDLE,
   //_SPI_REMAPPABLE_CLK_IDLE_LOW, _SPI_REMAPPABLE_HIGH_2_LOW);
}


void PGA1_Set_Gain(char ganho)
{
   SPI_CS_PGA1 = 0;                             //Ativar PGA1
   SPI_Remappable_Write(PGA_Inst_WriteGN);                //Endere�ar o ganho
   SPI_Remappable_Write(ganho);                            //Ganho de x vezes
   SPI_CS_PGA1 = 1;                             //Desativar o PGA1
   Delay_us(4);                                 //Tempo para mudan�a de ganho
}

void PGA2_Set_Gain(char ganho)
{
   SPI_CS_PGA2 = 0;                             //Ativar PGA2
   SPI_Remappable_Write(PGA_Inst_WriteGN);                //Endere�ar o ganho
   SPI_Remappable_Write(ganho);                            //Ganho de x vezes
   SPI_CS_PGA2 = 1;                             //Desativar o PGA1
   Delay_us(4);                                 //Tempo para mudan�a de ganho
}

void PGA1_Set_Channel(char canal)
{
   SPI_CS_PGA1 = 0;                     //Ativar PGA1
   SPI_Remappable_Write(PGA_Inst_WriteCH);        //Endere�ar a configura��o de Canais do PGA
   SPI_Remappable_Write(canal);                   //Selecionar o Canal x do PGA1
   SPI_CS_PGA1 = 1;                     //Desativar o PGA1
   Delay_us(4);                         //Tempo para ocorrer a troca de canais dentro do PGA
}

void PGA2_Set_Channel(char canal)
{
   SPI_CS_PGA2 = 0;                     //Ativar PGA2
   SPI_Remappable_Write(PGA_Inst_WriteCH);        //Endere�ar a configura��o de Canais do PGA
   SPI_Remappable_Write(canal);                   //Selecionar o Canal x do PGA2
   SPI_CS_PGA2 = 1;                     //Desativar o PGA2
   Delay_us(4);                         //Tempo para ocorrer a troca de canais dentro do PGA
}

///////////////////////////////////////////////////////////////////
//                                                               //
//     Fun��es de Leitura do Medidor de Temperatura              //
//     --------------------------------------------              //
//                                                               //
///////////////////////////////////////////////////////////////////

int GetTempOvrs(char x, unsigned short N_OverS) //x � o canal desejado, N_OverS � a sobre-amostragem
{
  char voutMult;                                //Multiplicador do PGA
  unsigned int ResultIndex;                     //Endere�amento para as tabelas de temperaturas
  unsigned long Result2;                        //Vari�vel onde � guardado o resultado dos calculos da sobre-amostragem
  int i;
  
  SPI_CS_PGA1 = 1;
  SPI_CS_PGA2 = 1;

  voutMult = 1;                                 //Multiplicador do PGA inicia em 1
  switch(x)                                     //Para cada canal desejado deve-se selecionar o canal do PGA
  {
   case 1: PGA1_Set_Channel(PGA_CH0);
           break;                               //Pr�ximo passo � conferir o se o ganho est� correto
   case 2:                                      //Idem para os demais do PGA1
           PGA1_Set_Channel(PGA_CH1);
           break;
   case 3:
           PGA1_Set_Channel(PGA_CH2);
           break;
   case 4:
           PGA1_Set_Channel(PGA_CH3);
           break;
   case 5:
           PGA1_Set_Channel(PGA_CH4);
           break;
   case 6:
           PGA1_Set_Channel(PGA_CH5);
           break;
   case 7:
           PGA1_Set_Channel(PGA_CH6);
           break;
   case 8:
           PGA1_Set_Channel(PGA_CH7);
           break;
   case 9:                                      //A partir do canal 9 utiliza-se o PGA2
           PGA2_Set_Channel(PGA_CH0);
           break;
   case 10:                                     //Sensor A
           PGA2_Set_Channel(PGA_CH1);
           break;
   case 11:                                     //Sensor B
           PGA2_Set_Channel(PGA_CH2);
           break;
   case 12:                                     //Sensor C
           PGA2_Set_Channel(PGA_CH3);
           break;
   case 13:                                     //Sensor D
           PGA2_Set_Channel(PGA_CH5);           //Ordem diferente pois foi trocado na placa para facilitar o roteamento
           break;
   case 14:                                     //Sensor E
           PGA2_Set_Channel(PGA_CH4);           //Ordem diferente pois foi trocado na placa para facilitar o roteamento
           break;
   case 15:                                     //Sensor F - Hardware existente por�m
           PGA2_Set_Channel(PGA_CH6);           // n�o conectado na porta traseira atual
           break;
   case 16:                                     //Sensor G - Idem para Sensor F
           PGA2_Set_Channel(PGA_CH7);
           break;

   }

   if(x <= 8)                                       //Se foi no PGA1
   {
       PGA1_Set_Gain(PGA_GAIN1);
       Result[x] = ADC_Get_Sample(AN_PGA1);         //Aquisi��o da sa�da do PGA1

       if(Result[x] > VOUTx1_MAX)                   //Caso a temperatura for menor que 0�C (Temperatura m�nima de calibra��o)
       {
         return Tabela_x1[(VOUTx1_MAX - VOUTx1_MIN)];       //retornar 0�C
       }

       if(Result[x] < VOUTx1_MIN)                   //Se maior que 38,4�C
       {
         PGA1_Set_Gain(PGA_GAIN2);                  //Multiplicar por 2 o PGA
         Result[x] = ADC_Get_Sample(AN_PGA1);       //Aquisi��o da sa�da do PGA1

         if(Result[x] < VOUTx2_MIN)                 //Se maior que 70,5�C
         {
           PGA1_Set_Gain(PGA_GAIN4);                //Multiplicar por 4
           Result[x] = ADC_Get_Sample(AN_PGA1);     //Aquisi��o da sa�da do PGA1

           if(Result[x] <  VOUTx4_MIN)              //Se a TEMP � maior que 93,6�C
           {
             PGA1_Set_Gain(PGA_GAIN8);              //Multiplicar por 8
             Result[x] = ADC_Get_Sample(AN_PGA1);   //Aquisi��o da sa�da do PGA1
             if(Result[x] < VOUTx8_MIN)             //Se maior que 120�C (Valores n�o obtidos durante a calibra��o)
             {
                return Tabela_x8[0];                //Mostrar apenas 120�C
             }
             else                                   //Caso contrario medir (93,5� a 120�)
             {
                 for(i=0;i<N_OverS;i++)             //Medir 'x' vezes, dependendo da sobre-amosragem desejada
                 {
                    Result[i] = ADC_Get_Sample(AN_PGA1);
                 }
                 voutMult = 8;                      //Multiplicador � 8
             }
           }
           else                                      //Medir com ganho 4 (70,4� a 93,6�)
           {
             for(i=0;i<N_OverS;i++)                  //Medir 'x' vezes, dependendo da sobre-amosragem desejada
             {
                Result[i] = ADC_Get_Sample(AN_PGA1);
             }
             voutMult = 4;                           //Multiplicador � 4
           }
         }
         else                                        //Medir com ganho 2 (38,2� a 70,5�)
         {
           for(i=0;i<N_OverS;i++)                    //Medir 'x' vezes, dependendo da sobre-amosragem desejada
           {
              Result[i] = ADC_Get_Sample(AN_PGA1);
           }
           voutMult = 2;                             //Multiplicador � 2
         }
       }
       else                                          //Medir com ganho 1 (0� a 38,4�)
       {
         for(i=0;i<N_OverS;i++)
         {
            Result[i] = ADC_Get_Sample(AN_PGA1);
         }
         voutMult = 1;
       }
    }
    else                                            //Se foi no PGA 2 - repetir o mesmo por�m com o PGA2
    {
       PGA2_Set_Gain(PGA_GAIN1);
       Result[x] = ADC_Get_Sample(AN_PGA2);
       if(Result[x] > VOUTx1_MAX)
       {
         return Tabela_x1[(VOUTx1_MAX - VOUTx1_MIN)];
       }

       if(Result[x] < VOUTx1_MIN)                     //Se maior que 38� multiplicar por 2
       {
         PGA2_Set_Gain(PGA_GAIN2);
         Result[x] = ADC_Get_Sample(AN_PGA2);
         if(Result[x] < VOUTx2_MIN)                  //Se maior que 70� multiplicar por 4
         {
           PGA2_Set_Gain(PGA_GAIN4);
           Result[x] = ADC_Get_Sample(AN_PGA2);
           if(Result[x] <  VOUTx4_MIN)               //Se maior que 94�C multiplicar por 8
           {
             PGA2_Set_Gain(PGA_GAIN8);
             Result[x] = ADC_Get_Sample(AN_PGA2);
             if(Result[x] < VOUTx8_MIN)
             {
                return Tabela_x8[0];                 //Mostrar apenas 120�C
             }
             else                                    //Medir com ganho 8 (94� a 120�)
             {
                 for(i=0;i<N_OverS;i++)
                 {
                    Result[i] = ADC_Get_Sample(AN_PGA2);
                 }
                 voutMult = 8;
             }
           }
           else                                       //Medir com ganho 4 (70� a 94�)
           {
             for(i=0;i<N_OverS;i++)
             {
                Result[i] = ADC_Get_Sample(AN_PGA2);
             }
             voutMult = 4;
           }
         }
         else                                         //Medir com ganho 2 (38� a 70�)
         {
           for(i=0;i<N_OverS;i++)
           {
              Result[i] = ADC_Get_Sample(AN_PGA2);
           }
           voutMult = 2;
         }
       }
       else                                           //Medir com ganho 1 (0� a 38�)
       {
         for(i=0;i<N_OverS;i++)
         {
            Result[i] = ADC_Get_Sample(AN_PGA2);
         }
         voutMult = 1;
       }
     }

   Result2 = 0;                                       //Inicializando o somat�rio

   //Somando todos os valores e tirando a m�dia
   for(i=0;i<N_OverS;i++) {
     Result2 = Result2 + (unsigned long)Result[i];
   }
   Result2 = Result2/N_OverS;


   //Depois de conseguir um valor de ADC est�vel, agora vamos interpolar com os valores das tabelas
   //no arquivo "TabelasTemperaturas.h"
   if(voutMult == 1)
   {
     #ifdef MODO_CALIBRACAO //Usar esse modo para observar quais os valores de ADc 
                            //  correspondentes para cada valor de temperatura aquisitado
     if(x ==1)      //Usado na calibra��o do ganho 1, sempre no canal 1
     {
      IntToStr(Result2, ADC_Out);
      LCD_Out(4,9,ADC_Out);                      //Exibir o valor ADC antes de usar a tabela de interpola��o
     }
     #endif

     if(Result2>VOUTx1_MAX)                      //Macete para n�o exibir um valor fora da tabela
     Result2 = VOUTx1_MAX;

     if(Result2 < VOUTx1_MIN)                    //Idem, evita a m�dia final repassar um valor fora do esperado
     Result2 = VOUTx1_MIN;

     ResultIndex = Result2 - VOUTx1_MIN;         //Fazer com que o valor se adeque ao valor m�nimo da tabela
     Result2 = Tabela_x1[ResultIndex];           //Depois de linearizado, o valor do ADC � o �ndice do valor na tabela.

   }
   else
   {
       if(voutMult == 2)
       {
           #ifdef MODO_CALIBRACAO
           if(x ==1)   //Usado na calibra��o do ganho 2, sempre no canal 1
           {
            IntToStr(Result2, ADC_Out);
            LCD_Out(3,9,ADC_Out);
           }
           #endif

           if(Result2>VOUTx2_MAX)
           Result2 = VOUTx2_MAX;

           if(Result2 < VOUTx2_MIN)
           Result2 = VOUTx2_MIN;

           ResultIndex = Result2 - VOUTx2_MIN;
           Result2 = Tabela_x2[ResultIndex];
       }
       else
       {
           if(voutMult == 4)
           {
               #ifdef MODO_CALIBRACAO
               if(x ==1)     //Usado na calibra��o do ganho 4, sempre no canal 1
               {
                IntToStr(Result2, ADC_Out);
                LCD_Out(2,9,ADC_Out);
               }
               #endif

               if(Result2>VOUTx4_MAX)
               Result2 = VOUTx4_MAX;

               if(Result2 < VOUTx4_MIN)
               Result2 = VOUTx4_MIN;

               ResultIndex = Result2 - VOUTx4_MIN;
               Result2 = Tabela_x4[ResultIndex];
           }
           else  //Multiplicador � 8
           {
               #ifdef MODO_CALIBRACAO
               if(x ==1)    //Usado na calibra��o do ganho 8, sempre no canal 1
               {
                IntToStr(Result2, ADC_Out);
                LCD_Out(1,9,ADC_Out);
               }
               #endif

               if(Result2>VOUTx8_MAX)
               Result2 = VOUTx8_MAX;

               if(Result2 < VOUTx8_MIN)
               Result2 = VOUTx8_MIN;

               ResultIndex = Result2 - VOUTx8_MIN;
               Result2 = Tabela_x8[ResultIndex];
           }
       }
   }
   return Result2;       //O valor de retorno � o valor da temperatura!
}