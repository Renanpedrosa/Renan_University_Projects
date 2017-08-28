/*
Projeto de Eletrônica
Usarei
*/
#include <built_in.h>

char filename[13]={"GPS_LOG0.TXT"};
char gpsdata[200];   //buffer q recebe os dados do GPS
int  i=1, ii=0;
char enter[2]={0x0D,0x0A};


///////////////////////////////////////////////////////////////////////////////
void MMC_Write_Log (char *data, int data_size)
{
     Mmc_Fat_Assign(filename, 0);     // 0 varolana devam et - 1 yoksa yeni aç
     Mmc_Fat_Set_File_Date(2007,9,21,00,00,0);
     Mmc_Fat_Append();                  // Prepare file for append
     Mmc_Fat_Write(data, data_size);   // Write data to assigned file
}
///////////////////////////////////////////////////////////////////////////////
void New_Filename()
{
name_control:
if (Mmc_Fat_Assign(filename, 0) == 1)//Vai procurar um arquivo com o filename
{
filename[7]=filename[7]+1;           //Se tiver o GPS_LOG0.txt vira GPS_LOG1.txt
goto name_control;                   //O nome mudou e vai procurar se ja existe
}
else
{
  Mmc_Fat_Assign(filename, 1);
  Mmc_Fat_Rewrite();
  MMC_Write_Log("Desenvolvido por Renan. Ver:0.3b",32);
  MMC_Write_Log(enter,2);
}
}
///////////////////////////////////////////////////////////////////////////////


void main ()
{

unsigned short oldstate;

     PORTB = 0;         // zerar PORTB
     TRISB = 0x08;            // set RB3 como entrada
                              // and RB7, RB6, RB5, RB4, RB2, RB1, RB0 como saída
                              
     PORTB.F0=255;      //acende LED de PIC_OK

     //--- coloca USART(GPS Data) ligada e pronta para receber
Spi_Init_Advanced(MASTER_OSC_DIV16, DATA_SAMPLE_MIDDLE,CLK_IDLE_LOW, LOW_2_HIGH);
Usart_Init(4800);//--- iniciar FAT library para escrever no cartão
     if (Mmc_Fat_Init(&PORTC,2) == 0)
     {
     PORTB.F1 =255;       //acende LED de SD_OK
     }
     while (Mmc_Fat_Init(&PORTC,2))  {}//se cartão tiver ok, sai do loop e
                                      //continua no procedimento de gravação


        
new_route: // depois que termina de fazer a rota o pic vem para aqui
        PortB.F2= 0;//apaga LED SD record
        New_filename();

  while(1)
  {
  //  if (Button(&PORTB, 3, 1, 0)) oldstate = 0;
  //  if (oldstate && Button(&PORTB, 3, 1, 1))  // espera a transiçao do botão
    if (PORTB.F3 == 0)
    {
      while(1)
      {
        PortB.F2= 255;//acende LED SD record
        while(!Usart_Data_Ready() ) {}   //Espera a USART estiver ativa
                                         //e enviando dados

        gpsdata[ii]=Usart_Read();
        if(gpsdata[0]==0x24) {ii++;} // Hire control the start char "$"

        if(gpsdata[ii-i]==0x2A)    // hire control the (end char -4 ) the is "*"
        {
//karakterini kontrol eder
        i++;
        if(i==4)
        {       //PortB.F2= 255;Acende Led de GPS_Logging
                MMC_Write_Log(gpsdata,ii);
                MMC_Write_Log(enter,2);
                ii=0;i=1;
                }
        }
        oldstate=1;
        
        Delay_ms(200);

        //if (Button(&PORTB, 3, 1, 0)) oldstate = 0;
        //if (oldstate && Button(&PORTB, 3, 1, 1))
        if (PORTB.F3 == 0)
        {
        oldstate=1;
        goto new_route; // se o botão for pressionado, a rota termina
                        //manda pra fazer outro arquivo
        }
        }
    }
  }
}
         
         //--- Test start

