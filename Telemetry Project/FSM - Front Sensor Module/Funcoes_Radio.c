
#define CR 0x0D   //Carriage return: posiciona o cursor no início da linha
#define LF 0x0A   //Linefeed: equivalente a pressionar ENTER em um editor


char dado1_txt[6];
char dado2_txt[6];
char dado3_txt[6];
char dado4_txt[6];

const char DATA_end = ';';

//Funções de Protocolo do Rádio
void Write_UART_UDATA(char *ID, unsigned dado1, unsigned dado2, unsigned dado3, unsigned dado4)
{

    WordToStr(dado1,dado1_txt);
    WordToStr(dado2,dado2_txt);
    WordToStr(dado3,dado3_txt);
    WordToStr(dado4,dado4_txt);

    UART1_Write_Text(ID);
    UART1_Write_Text(dado1_txt);
    UART1_Write(',');
    UART1_Write_Text(dado2_txt);
    UART1_Write(',');
    UART1_Write_Text(dado3_txt);
    UART1_Write(',');
    UART1_Write_Text(dado4_txt);
    UART1_Write(DATA_end);
    UART1_Write(CR);
    UART1_Write(LF);
}
void GetGPSData(char *string)
{

}