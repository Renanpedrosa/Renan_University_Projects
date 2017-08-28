//Trabalho GPS
//Interface GPS - Cartão SD

#include <build_in.h>

     
#include <built_in.h>
char enter[2]={0x0D,0x0A};
int ii=0,i=1;
char tmp_g[200];
char dosya[12]="GPS_LOG0TXT";
////////////////////////////////////////////////////////////////////////////////
void MMC_Kayit_Ekle(char *data,int data_boyu) {
     Mmc_Fat_Assign(dosya, 0);     // 0 varolana devam et - 1 yoksa yeni aç
     Mmc_Fat_Set_File_Date(2007,7,21,00,00,0);
     Mmc_Fat_Append();                  // Prepare file for append
     Mmc_Fat_Write(data, data_boyu);   // Write data to assigned file
}
//////////////////  Her Açilista Yeni dosya Açar  ////////////////////////
void yeni_dosya_ac(){
tekrarkontrol:
if (Mmc_Fat_Assign(dosya, 0)){
dosya[7]=dosya[7]+1;
goto tekrarkontrol;
}
else {
  Mmc_Fat_Assign(dosya, 1);
  Mmc_Fat_Rewrite();
  MMC_Kayit_Ekle("GPS Veri Kaydedicisi. Ver:1.0",29);
  MMC_Kayit_Ekle(enter,2);
}
}
////////////////////////////////////////////////////////////////////////////////
void main()
   {
TRISD = 0x00 ;
PortD=0x00;
   Spi_Init_Advanced(MASTER_OSC_DIV16, DATA_SAMPLE_MIDDLE,CLK_IDLE_LOW, LOW_2_HIGH);
   Usart_Init( 4800L ) ;
while (Mmc_Fat_Init(&PORTC,2)){
PortD.F6=1;
}
yeni_dosya_ac();
           PortD.F5=1;
           PortD.F6=0;
   while (1)
      {
      while ( !Usart_Data_Ready() ){}
    PortD.F6=1;
    tmp_g[ii]=Usart_Read();
        if(tmp_g[0]==0x24){ii++;} // Baslangiç karakterini kontrol eder "$" // Hire control the start char "$"

        if(tmp_g[ii-i]==0x2A){        // Bitise yakin *   // hire control the (end char -4 ) the is "*"
//karakterini kontrol eder
        i++;
        if(i==4)
        {       PortD.F2=1;
                MMC_Kayit_Ekle(tmp_g,ii);
                MMC_Kayit_Ekle(enter,2);
                PortD.F2=0;
                ii=0;i=1;
                }
        }
        PortD.F6=0;
        }
}