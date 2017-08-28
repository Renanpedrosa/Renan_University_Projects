#line 1 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/Funcoes_ADXL.c"
#line 26 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/Funcoes_ADXL.c"
sbit ADXL_CS at LATC5_bit;
sbit ADXL_CS_Direction at TRISC5_bit;

void ADXL345_Write(unsigned short address, unsigned short data1) {
 unsigned short internal = 0;
 internal = address |  0x00 ;

 ADXL_CS = 0;
 SPI1_Write(internal);
 SPI1_Write(data1);
 ADXL_CS = 1;
}

unsigned short ADXL345_Read(unsigned short address) {
 unsigned short internal = 0;
 internal = address |  0x80 ;

 ADXL_CS = 0;
 SPI1_Write(internal);
 internal = SPI1_Read(0);
 ADXL_CS = 1;

 return internal;
}
#line 65 "C:/Users/Renan/Documents/My Dropbox/Fórmula Eng 3/Engenharia 3/CT02 - Acelerômetro/Programa CT02/Funcoes_ADXL.c"
void ADXL345_Init()
{

ADXL345_Write( 0x2D , 0x00);


ADXL345_Write( 0x31 , 0x02);


ADXL345_Write( 0x2C ,  0x0A );


ADXL345_Write( 0x2D , 0x08);
}

void ADXL345_Read_XYZ(char * dados)
{
 dados[0] = ADXL345_Read( 0x32 );
 dados[1] = ADXL345_Read( 0x33 );
 dados[2] = ADXL345_Read( 0x34 );
 dados[3] = ADXL345_Read( 0x35 );
 dados[4] = ADXL345_Read( 0x36 );
 dados[5] = ADXL345_Read( 0x37 );
}
