#line 1 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT01 - Medidor Bateria/CT01/PGA_Drivers_LSM.c"


sbit SPI_CS_PGA1 at LATC5_bit;





void PGA_Set_Gain(char ganho)
{
 SPI_CS_PGA1 = 0;
 SPI1_Write( 0b01000000 );
 SPI1_Write(ganho);
 SPI_CS_PGA1 = 1;
 Delay_us(4);
}

void PGA_Set_Channel(char canal)
{
 SPI_CS_PGA1 = 0;
 SPI1_Write( 0b01000001 );
 SPI1_Write(canal);
 SPI_CS_PGA1 = 1;
 Delay_us(4);
}
