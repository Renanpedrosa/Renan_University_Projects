// ADXL345 Register Definition
#define _POWER_CTL      0x2D
#define _DATA_FORMAT    0x31
#define _BW_RATE        0x2C
#define _DATAX0         0x32
#define _DATAX1         0x33
#define _DATAY0         0x34
#define _DATAY1         0x35
#define _DATAZ0         0x36
#define _DATAZ1         0x37
#define _FIFO_CTL       0x38

#define _SPI_READ       0x80
#define _SPI_WRITE      0x00
#define _SPI_READ_MULT  0x40

#define _SPEED_3200     0x0F                       // Buffer Speed - 3200Hz
#define _SPEED_1600     0x0E                       // Buffer Speed - 3200Hz
#define _SPEED_800      0x0D                       // Buffer Speed - 3200Hz
#define _SPEED_400      0x0C                       // Buffer Speed - 3200Hz
#define _SPEED_200      0x0B                       // Buffer Speed - 3200Hz
#define _SPEED_100      0x0A                       // Buffer Speed - 3200Hz


//Conexões do SPI
sbit ADXL_CS at LATC5_bit;                  //Acelerômetro ADXL345
sbit ADXL_CS_Direction at TRISC5_bit;

void ADXL345_Write(unsigned short address, unsigned short data1) {
  unsigned short internal = 0;
  internal = address | _SPI_WRITE;                 // Register and Write bit

  ADXL_CS = 0;
  SPI1_Write(internal);
  SPI1_Write(data1);
  ADXL_CS = 1;
}

unsigned short ADXL345_Read(unsigned short address) {
  unsigned short internal = 0;
  internal = address | _SPI_READ;                  // Register and Read bit

  ADXL_CS = 0;
  SPI1_Write(internal);
  internal = SPI1_Read(0);
  ADXL_CS = 1;

  return internal;
}
    /*
void ADXL345_Read_Multiple(unsigned short address, char numBytes, char * buffer)
{
  char short internal = 0;
  char short ii;
  internal = ((_SPI_READ | _SPI_READ_MULT) | address);                  // Register and Read bit

  ADXL_CS = 0;
  SPI1_Write(internal);
  for (ii = 0; ii < numBytes; ii++) {
    buffer[ii] = SPI1_Read(0);
  }
  ADXL_CS = 1;
}
      */
void ADXL345_Init()
{
// Go into standby mode to configure the device.
ADXL345_Write(_POWER_CTL, 0x00);

// Full resolution, +/-8g, 4mg/LSB.
ADXL345_Write(_DATA_FORMAT, 0x02);

// Set data rate.
ADXL345_Write(_BW_RATE, _SPEED_100);

// Measurement mode.
ADXL345_Write(_POWER_CTL, 0x08);
}

void ADXL345_Read_XYZ(char * dados)
{
  dados[0] = ADXL345_Read(_DATAX0);
  dados[1] = ADXL345_Read(_DATAX1);
  dados[2] = ADXL345_Read(_DATAY0);
  dados[3] = ADXL345_Read(_DATAY1);
  dados[4] = ADXL345_Read(_DATAZ0);
  dados[5] = ADXL345_Read(_DATAZ1);
}