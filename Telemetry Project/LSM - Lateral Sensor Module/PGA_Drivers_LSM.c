//8 Gain Selections:
//+1, +2, +4, +5, +8, +10, +16 or +32 V/V
sbit SPI_CS_PGA1  at LATC5_bit;                     //Chip-Select PGA1(MCP6S28)

#define PGA_Inst_WriteCH 0b01000001
#define PGA_Inst_WriteGN 0b01000000
#define PGA_Inst_SHTDOWN 0b00100000

void PGA_Set_Gain(char ganho)
{
   SPI_CS_PGA1 = 0;                             //Ativar PGA1
   SPI1_Write(PGA_Inst_WriteGN);                //Endereçar o ganho
   SPI1_Write(ganho);                            //Ganho de x vezes
   SPI_CS_PGA1 = 1;                             //Desativar o PGA1
   Delay_us(4);                                 //Tempo para mudança de ganho
}

void PGA_Set_Channel(char canal)
{
   SPI_CS_PGA1 = 0;                     //Ativar PGA1
   SPI1_Write(PGA_Inst_WriteCH);        //Endereçar a configuração de Canais do PGA
   SPI1_Write(canal);                   //Selecionar o Canal x do PGA1
   SPI_CS_PGA1 = 1;                     //Desativar o PGA1
   Delay_us(4);                         //Tempo para ocorrer a troca de canais dentro do PGA
}