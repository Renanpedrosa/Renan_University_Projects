#line 1 "G:/Arquivos Renan/GPS_SD_Interface/GPS_SD_Interface.c"
#line 1 "d:/arquivos de programas/mikroelektronika/mikroc/include/built_in.h"
#line 7 "G:/Arquivos Renan/GPS_SD_Interface/GPS_SD_Interface.c"
char filename[13]={"GPS_LOG0.TXT"};
char gpsdata[200];
int i=1, ii=0;
char enter[2]={0x0D,0x0A};



void MMC_Write_Log (char *data, int data_size)
{
 Mmc_Fat_Assign(filename, 0);
 Mmc_Fat_Set_File_Date(2007,9,21,00,00,0);
 Mmc_Fat_Append();
 Mmc_Fat_Write(data, data_size);
}

void New_Filename()
{
name_control:
if (Mmc_Fat_Assign(filename, 0) == 1)
{
filename[7]=filename[7]+1;
goto name_control;
}
else
{
 Mmc_Fat_Assign(filename, 1);
 Mmc_Fat_Rewrite();
 MMC_Write_Log("Desenvolvido por Renan. Ver:0.3b",32);
 MMC_Write_Log(enter,2);
}
}



void main ()
{

unsigned short oldstate;

 PORTB = 0;
 TRISB = 0x08;


 PORTB.F0=255;


Spi_Init_Advanced(MASTER_OSC_DIV16, DATA_SAMPLE_MIDDLE,CLK_IDLE_LOW, LOW_2_HIGH);
Usart_Init(4800);
 if (Mmc_Fat_Init(&PORTC,2) == 0)
 {
 PORTB.F1 =255;
 }
 while (Mmc_Fat_Init(&PORTC,2)) {}




new_route:
 PortB.F2= 0;
 New_filename();

 while(1)
 {


 if (PORTB.F3 == 0)
 {
 while(1)
 {
 PortB.F2= 255;
 while(!Usart_Data_Ready() ) {}


 gpsdata[ii]=Usart_Read();
 if(gpsdata[0]==0x24) {ii++;}

 if(gpsdata[ii-i]==0x2A)
 {

 i++;
 if(i==4)
 {
 MMC_Write_Log(gpsdata,ii);
 MMC_Write_Log(enter,2);
 ii=0;i=1;
 }
 }
 oldstate=1;

 Delay_ms(200);



 if (PORTB.F3 == 0)
 {
 oldstate=1;
 goto new_route;

 }
 }
 }
 }
}
