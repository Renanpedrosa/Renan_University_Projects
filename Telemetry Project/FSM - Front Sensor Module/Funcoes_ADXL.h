


void ADXL345_Write(unsigned short address, unsigned short data1);
unsigned short ADXL345_Read(unsigned short address);
void ADXL345_Read_Multiple(unsigned short address, char numBytes, char * buffer);
void ADXL345_Init();
void ADXL345_Read_XYZ(char * dados);