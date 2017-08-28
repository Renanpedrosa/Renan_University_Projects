using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Modelagem_Leucena_v1._0
{
    public class ConfigData
    {
        //Dados de Otimização

        public int seedPackageSize;         //Numero de sementes por pacote discreto
        public int maxSeedNumber;           //Numero maximo de sementes no banco de sementes
        public int maxNumberTrees;          //Numero máximo de árvores que pode ter no local 
        public int maxNumberCuts;           //Numero de cortes máximo a cada decisão
        public int maxTreePopulation;

        public int totalTimeSpan;           //Número de anos que o modelo vai rodar
        public int decisionTimeStep;        //Número de meses que vai demorar para decidir sobre os cortes

        public double initialCutCost;       //Custo de aluguel, trator, necessario para corte
        public double treeCutCost;          //Custo por árvore
        public double taxaJuros;            //Taxa de Juros Anual

        //Dados de Simulação

        public int numberSeeds;             //Número de Sementes Inicial
        public int numberYoungPlants;       //Numero de Plantas Jovens Inicial
        public int numberAdultPlants;       //Numero de Plantas Adultas Inicial
        public int seedFallYoungP;          //Taxa de queda de sementes por arvores jovens
        public int seedFallAdultP;          //Taxa de queda de sementes por arvores adultas

        public double seedLostNumber;       //Taxa de perda de sementes
        public double plantLostNumber;      //Taxa de perda de germinações

        public double dominatLuminosity;    //Porcentagem de Iluminação entre claro e escuro
        //  (acima de 0.5 é mais claro que escuro)
        public double seedSleepTime;        //Tempo de dormencia da semente em meses
        public double germGrowTime;         //Tempo que leva para a planta germinar virar uma arvore adulta
        public double minPrecipitation;     //Precipitação minima para ocorrer germinação

        public double plantArea;            //Área que a simulação vai ocorrer
        public double treeSpaceRadius;      //Espaço entre Árvores

        public bool monthSimulation;        //Decisão se é mes a mes(true) ou todos os meses(false)

        public DateTime initialDate;
        public DateTime finalDate;

        public double[] rainProbability;
        public double[] tempProbability;

        public ConfigData() //Construtor normal com tudo zerado
        {
            //Dados da Simulação
            numberSeeds = 0;             //Número de Sementes Inicial
            numberYoungPlants = 0;
            numberAdultPlants = 0;
            seedFallYoungP = 0;
            seedFallAdultP = 0;

            seedLostNumber = 0;
            plantLostNumber = 0;

            dominatLuminosity = 0;

            seedSleepTime = 0;
            germGrowTime = 0;
            minPrecipitation = 0; //mm chuva    

            plantArea = 0;   //m²            
            treeSpaceRadius = 0;

            monthSimulation = false;

            //Dados da Otimização
            seedPackageSize = 0;
            maxSeedNumber = 0;
            maxNumberTrees = 0;
            maxNumberCuts = 0;
            maxTreePopulation = 0;

            totalTimeSpan = 0;
            decisionTimeStep = 0;

            initialCutCost = 0;
            treeCutCost = 0;
            taxaJuros = 0;

            initialDate = DateTime.Now;
            finalDate = DateTime.Now;


            rainProbability = new double[12];
            tempProbability = new double[12];

            for(int i = 0; i<12; i++)
            {
                rainProbability[i] = 0;
                tempProbability[i] = 0;
            }

        }

        //Construtor com valores iniciais
        public ConfigData(bool defaultData)
        {
            if (defaultData)
            {

                //Dados da Simulação
                numberSeeds = 100;             //Número de Sementes Inicial
                numberYoungPlants = 0;
                numberAdultPlants = 1;
                seedFallYoungP = 2;
                seedFallAdultP = 5;

                seedLostNumber = 0.60;
                plantLostNumber = 0.05;

                dominatLuminosity = 0.5;

                seedSleepTime = 12;
                germGrowTime = 5;
                minPrecipitation = 80; //mm chuva    

                plantArea = 1000;   //m²            
                treeSpaceRadius = 5;

                monthSimulation = false;

                //Dados da Otimização
                seedPackageSize = 100;
                maxSeedNumber = 300;
                maxNumberTrees = 5;
                maxNumberCuts = 50;
                maxTreePopulation = 50;

                totalTimeSpan = 8;
                decisionTimeStep = 12;

                initialCutCost = 40.0;
                treeCutCost = 10.0;
                taxaJuros = 0.01;

                initialDate = DateTime.Now;
                finalDate = DateTime.Now;

                rainProbability = new double[12] {1.0,1.0,1.0,1.0,0.5,0.375,0.375,0.375,0.325,0.75,0.875,0.875};
                tempProbability = new double[12] { 1.0, 1.0, 1.0, 1.0, 0.625, 0.625, 0.375, 0.875, 0.875, 0.750, 1.0, 1.0 };

               
            }
            else
            {
                //Dados da Simulação
                numberSeeds = 0;             //Número de Sementes Inicial
                numberYoungPlants = 0;
                numberAdultPlants = 0;
                seedFallYoungP = 0;
                seedFallAdultP = 0;

                seedLostNumber = 0;
                plantLostNumber = 0;

                dominatLuminosity = 0;

                seedSleepTime = 0;
                germGrowTime = 0;
                minPrecipitation = 0; //mm chuva    

                plantArea = 0;   //m²            
                treeSpaceRadius = 0;

                monthSimulation = false;

                //Dados da Otimização
                seedPackageSize = 0;
                maxSeedNumber = 0;
                maxNumberTrees = 0;
                maxNumberCuts = 0;
                maxTreePopulation = 0;

                totalTimeSpan = 0;
                decisionTimeStep = 0;

                initialCutCost = 0;
                treeCutCost = 0;
                taxaJuros = 0;

                initialDate = DateTime.Now;
                finalDate = DateTime.Now;

                rainProbability = new double[12];
                tempProbability = new double[12];

                for (int i = 0; i < 12; i++)
                {
                    rainProbability[i] = 0;
                    tempProbability[i] = 0;
                }
            }

        }

        public ConfigData(ConfigData dados) //Utilizando outro objeto criado
        {
            //Dados da Simulação
            numberSeeds = dados.numberSeeds;             //Número de Sementes Inicial
            numberYoungPlants = dados.numberYoungPlants;
            numberAdultPlants = dados.numberAdultPlants;
            seedFallYoungP = dados.seedFallYoungP;
            seedFallAdultP = dados.seedFallAdultP;

            seedLostNumber = dados.seedLostNumber;
            plantLostNumber = dados.seedLostNumber;

            dominatLuminosity = dados.dominatLuminosity;

            seedSleepTime = dados.seedSleepTime;
            germGrowTime = dados.germGrowTime;
            minPrecipitation = dados.minPrecipitation; //mm chuva    

            plantArea = dados.plantArea;   //m²            
            treeSpaceRadius = dados.treeSpaceRadius;

            monthSimulation = dados.monthSimulation;

            //Dados da Otimização
            seedPackageSize = dados.seedPackageSize;
            maxSeedNumber = dados.maxSeedNumber;
            maxNumberTrees = dados.maxNumberTrees;
            maxNumberCuts = dados.maxNumberCuts;
            maxTreePopulation = dados.maxTreePopulation;

            totalTimeSpan = dados.totalTimeSpan;
            decisionTimeStep = dados.decisionTimeStep;

            initialCutCost = dados.initialCutCost;
            treeCutCost = dados.treeCutCost;
            taxaJuros = dados.taxaJuros;

            initialDate = dados.initialDate;
            finalDate = dados.finalDate;

            rainProbability = new double[12];
            tempProbability = new double[12];

            for (int i = 0; i < 12; i++)
            {
                rainProbability[i] = dados.rainProbability[i];
                tempProbability[i] = dados.tempProbability[i];
            }
        }

        public void CopyConfigData(ConfigData dados)
        {
            //Dados da Simulação
            numberSeeds = dados.numberSeeds;             //Número de Sementes Inicial
            numberYoungPlants = dados.numberYoungPlants;
            numberAdultPlants = dados.numberAdultPlants;
            seedFallYoungP = dados.seedFallYoungP;
            seedFallAdultP = dados.seedFallAdultP;

            seedLostNumber = dados.seedLostNumber;
            plantLostNumber = dados.seedLostNumber;

            dominatLuminosity = dados.dominatLuminosity;

            seedSleepTime = dados.seedSleepTime;
            germGrowTime = dados.germGrowTime;
            minPrecipitation = dados.minPrecipitation; //mm chuva    

            plantArea = dados.plantArea;   //m²            
            treeSpaceRadius = dados.treeSpaceRadius;

            monthSimulation = dados.monthSimulation;

            //Dados da Otimização
            seedPackageSize = dados.seedPackageSize;
            maxSeedNumber = dados.maxSeedNumber;
            maxNumberTrees = dados.maxNumberTrees;
            maxNumberCuts = dados.maxNumberCuts;
            maxTreePopulation = dados.maxTreePopulation;

            totalTimeSpan = dados.totalTimeSpan;
            decisionTimeStep = dados.decisionTimeStep;

            initialCutCost = dados.initialCutCost;
            treeCutCost = dados.treeCutCost;
            taxaJuros = dados.taxaJuros;

            initialDate = dados.initialDate;
            finalDate = dados.finalDate;

            for (int i = 0; i < 12; i++)
            {
                rainProbability[i] = dados.rainProbability[i];
                tempProbability[i] = dados.tempProbability[i];
            }
        }
    }
}