///////////////////////////////////////////
//    Mapa de Mensagens do CAN-BUS       //
///////////////////////////////////////////

// Mapa feito de acordo com o arquivo: "Datasheet Telemetria CEFAST v3.xlsx"



long const FSM_ACCEL1  =  1000 ; // Sinal X, Y e Z do Aceler�metro Digital e Z do Aceler�metro Interno
long const FSM_ACCEL2  =  1010 ; // Sinal X e Y do Aceler�metro Interno e Status do Aceler�metro (OK/KO)
long const FSM_GPIO1   =  1020 ; // Sinais de cada porta respectiva do FSM. Portas 0 a 3.
long const FSM_GPIO2   =  1030 ; // Sinais de cada porta respectiva do FSM. Portas 4 a 6.
//long const FSM_UART_1  =  1040 ; // Caso seja usada a porta UART e seja necess�rio usar estes dados. Uso futuro.
//long const FSM_UART_2  =  1045 ; // Caso seja usada a porta UART e seja necess�rio usar estes dados. Uso futuro.
//long const FSM_SPI_1   =  1050 ; // Caso seja usada a porta SPI e seja necess�rio usar estes dados. Uso futuro.
//long const FSM_SPI_2   =  1055 ; // Caso seja usada a porta SPI e seja necess�rio usar estes dados. Uso futuro.
long const FSM_CTRL    =  1060 ; // Caso seja usado uma configura��o das demais placas e acionamento dos transistores do BSM. Uso futuro.
long const LSM_ELET_1  =  2000 ; // Entradas anal�gicas dos canais do LSM e Sinal de Corrente do CAN-Bus.
long const LSM_ELET_2  =  2010 ; // Entradas anal�gicas dos canais do LSM e Entrada de Rota��o - Medi��o do Per�odo.
long const LSM_PGA_1  =  2020 ; // Entradas Anal�gicas do Amplificador de Ganho Program�vel MCP6S28.
long const LSM_PGA_2  =  2030 ; // Entradas Anal�gicas do Amplificador de Ganho Program�vel MCP6S29 e os respectivos ganhos.
long const BSM_ANA_1   =  3000 ; // Parte 1 das entradas anal�gicas do BSM, ANA0 at� ANA3.
long const BSM_ANA_2   =  3010 ; // Parte 2 das entradas anal�gicas do BSM, ANA4 at� ANA7.
long const BSM_ANA_3   =  3030 ; // Parte 3 das entradas anal�gicas do BSM, ANA8 at� ANA11.
long const BSM_DIG_1  =  3040 ; // Entradas Digitais 1 do BSM. A entrada DIG1 � bin�ria e as entradas DIG2 a 4 s�o entradas de frequ�ncia.
long const BSM_DIG_2  =  3050 ; // Entradas Digitais 2 do BSM. As entradas DIG5 at� DIG8 s�o bin�rias. DIG7 e DIG8 n�o est�o conectadas na parte externa.
long const BSM_GPS_1   =  3060 ; // Dados do GPS, retirados da frase $GPRMC.
long const BSM_GPS_2   =  3070 ; // Dados do GPS, retirados da frase $GPRMC.
long const BSM_GPS_3   =  3080 ; // Dados de hora do GPS, retirados da frase $GPRMC.
long const BSM_GPS_4   =  3090 ; // Dados do GPS, retirados da frase $GPGGA - Complemento para precis�o e altitude.
//long const BSM_I2C_0   =  3091 ; // Caso seja usado a porta I2C para pegar as temperaturas de pneu. Uso futuro
//long const BSM_I2C_1   =  3092 ; // Caso seja usado a porta I2C para pegar as temperaturas de pneu. Uso futuro
//long const BSM_I2C_2   =  3093 ; // Caso seja usado a porta I2C para pegar as temperaturas de pneu. Uso futuro
//long const BSM_I2C_3   =  3094 ; // Caso seja usado a porta I2C para pegar as temperaturas de pneu. Uso futuro
//long const BSM_I2C_4   =  3095 ; // Caso seja usado a porta I2C para pegar as temperaturas de pneu. Uso futuro
//long const BSM_I2C_5   =  3096 ; // Caso seja usado a porta I2C para pegar as temperaturas de pneu. Uso futuro
//long const BSM_I2C_6   =  3097 ; // Caso seja usado a porta I2C para pegar as temperaturas de pneu. Uso futuro
//long const BSM_I2C_7   =  3098 ; // Caso seja usado a porta I2C para pegar as temperaturas de pneu. Uso futuro