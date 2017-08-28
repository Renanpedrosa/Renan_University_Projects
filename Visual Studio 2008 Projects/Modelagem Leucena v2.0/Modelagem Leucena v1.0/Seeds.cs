using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;




namespace Modelagem_Leucena_v1._0
{
     
    public class PlantSimulation
    {

        //string SpecieName;
        //string ScientificName;
        //Double GroupAge;                 //Idade em meses
        public Int32 LastSeedNumber;              //Quantidade de sementes
        public Int32 LastGermNumber;
        public Int32 LastPlantNumber;
        int[] seedAgeNumber;
        int[] germAgeNumber;
        
        public ConfigData data;

        //Int32 TimeSpan;                 //Numero de meses que a simulação vai rodar

        public DateTime CreationDate;          //Data de inicio da simulação
        public DateTime FinalDate;             //Data de término da simulação
        public DateTime LastDate;              //Para retroceder 1 mês no tempo
        public DateTime PresentDate;           //Data mostrada no menu de simulação
        
        Random lumiRnd = new Random();
        Random climateRnd = new Random();


        enum Light { claro, escuro };

        Double[,] GermProb = new Double[3, 2] { { 0.792, 0.834 }, { 0.924, 0.956 }, { 0.924, 0.9 } };

        //Light luz;
        

        //public PlantSimulation(ConfigData dt)
        //{
            //GroupAge = 0;
            //LastSeedNumber = 1;
            //CreationDate = DateTime.Now.Date;
            //seedAgeNumber = new Int32[
        //}

        public PlantSimulation(DateTime initTime, DateTime finalTime, ConfigData dt)
        {
            CreationDate = initTime;
            FinalDate = finalTime;
            data = dt;
            PresentDate = CreationDate;
            LastSeedNumber = data.numberSeeds;
            LastGermNumber = data.numberYoungPlants;
            LastPlantNumber = data.numberAdultPlants;

            seedAgeNumber = new int[Convert.ToInt32(data.seedSleepTime)]; //Numero de meses para quebra
            seedAgeNumber[0] = data.numberSeeds;

            germAgeNumber = new int[Convert.ToInt32(data.germGrowTime)]; //Tempo até virar planta adulta
            germAgeNumber[0] = data.numberYoungPlants;

            for (int i = 1; i < seedAgeNumber.Length; i++)
            {
                seedAgeNumber[i] = 0;
            }

            for (int i = 1; i < germAgeNumber.Length; i++)
            {
                germAgeNumber[i] = 0;
            }
        }

        public PlantSimulation(PlantSimulation simulationP)
        {
            data = simulationP.data;
            PresentDate = simulationP.PresentDate;
            //LastSeedNumber = data.numberSeeds;
            //LastGermNumber = data.numberYoungPlants;
            //LastPlantNumber = data.numberAdultPlants;

            seedAgeNumber = new int[Convert.ToInt32(data.seedSleepTime)]; //Numero de meses para quebra
            seedAgeNumber[0] = data.numberSeeds;

            germAgeNumber = new int[Convert.ToInt32(data.germGrowTime)]; //Tempo até virar planta adulta
            germAgeNumber[0] = data.numberYoungPlants;

            for (int i = 1; i < seedAgeNumber.Length; i++)
            {
                seedAgeNumber[i] = 0;
            }

            for (int i = 1; i < germAgeNumber.Length; i++)
            {
                germAgeNumber[i] = 0;
            }
        }

        public bool NextMonth()
        {
            if (PresentDate.Date <= FinalDate.Date)
            {
                //LastSeedNumber = GetSeedNumber();
                //LastGermNumber = data.numberYoungPlants;
                //LastPlantNumber = data.numberAdultPlants;
                //LastDate = PresentDate;

                PresentDate = PresentDate.AddMonths(1);           //Avanço de um mês


                data.numberAdultPlants += Convert.ToInt32(germAgeNumber.Last() *data.plantLostNumber);

                germAgeNumber[germAgeNumber.Length-1] += Convert.ToInt32(germAgeNumber[germAgeNumber.Length - 2] * data.plantLostNumber);

                for (int i = germAgeNumber.Length-2; i > 0; i--)
                {
                    germAgeNumber[i] = Convert.ToInt32(germAgeNumber[i - 1] * data.plantLostNumber); //As semestes do prox mes é o numero de sementes do
                }                                                                    //mes anterior menos a perda de sementes
                if (IsEnougthRain(PresentDate))
                {
                    germAgeNumber[0] = Convert.ToInt32(seedAgeNumber.Last() * data.seedLostNumber * NewGerminationProb(PresentDate));
                    seedAgeNumber[seedAgeNumber.Length-1] = 0;
                }
                else
                {
                    seedAgeNumber[seedAgeNumber.Length-1] += Convert.ToInt32(seedAgeNumber[seedAgeNumber.Length - 2] * data.seedLostNumber);
                }


                for (int i = seedAgeNumber.Length-1; i > 0; i--)
                {
                    seedAgeNumber[i] = Convert.ToInt32(seedAgeNumber[i - 1] * data.seedLostNumber); //As semestes do prox mes é o numero de sementes do
                    //mes anterior menos a perda de sementes
                }                                                                    
                seedAgeNumber[0] = (data.numberAdultPlants * data.seedFallAdultP) + (data.numberYoungPlants * data.seedFallYoungP);

                return true;
            }

            else
            {
                return false;
            }

        }

        public bool NextYear()
        {
            for (int year = 0; year < 12; year++)
            {
                if (PresentDate.Date <= FinalDate.Date)
                {
                    LastSeedNumber = GetSeedNumber();
                    LastGermNumber = data.numberYoungPlants;
                    LastPlantNumber = data.numberAdultPlants;
                    LastDate = PresentDate;

                    PresentDate = PresentDate.AddMonths(1);           //Avanço de um mês

                    data.numberAdultPlants += Convert.ToInt32(germAgeNumber.Last() * data.plantLostNumber);

                    germAgeNumber[germAgeNumber.Length - 1] += Convert.ToInt32(germAgeNumber[germAgeNumber.Length - 2] * data.plantLostNumber);

                    for (int i = germAgeNumber.Length - 2; i > 0; i--)
                    {
                        germAgeNumber[i] = Convert.ToInt32(germAgeNumber[i - 1] * data.plantLostNumber); //As semestes do prox mes é o numero de sementes do
                    }                                                                    //mes anterior menos a perda de sementes
                    if (IsEnougthRain(PresentDate))
                    {
                        germAgeNumber[0] = Convert.ToInt32(seedAgeNumber.Last() * data.seedLostNumber * NewGerminationProb(PresentDate));
                        seedAgeNumber[seedAgeNumber.Length - 1] = 0;
                    }
                    else
                    {
                        seedAgeNumber[seedAgeNumber.Length - 1] += Convert.ToInt32(seedAgeNumber[seedAgeNumber.Length - 2] * data.seedLostNumber);
                    }


                    for (int i = seedAgeNumber.Length - 1; i > 0; i--)
                    {
                        seedAgeNumber[i] = Convert.ToInt32(seedAgeNumber[i - 1] * data.seedLostNumber); //As semestes do prox mes é o numero de sementes do
                        //mes anterior menos a perda de sementes
                    }
                    seedAgeNumber[0] = (data.numberAdultPlants * data.seedFallAdultP) + (data.numberYoungPlants * data.seedFallYoungP);

                }
                else
                {
                    return false;
                }
            }
            return true;
        }

        //De acordo com a classe e os atuais da simulação da planta,
        //Ele simula um anos depois como ficaria a simulação.
        public void OneYearSimulation(ConfigData data, uint[] numSementes, uint[] numSemGerm, uint numArvores,DateTime dataInicio,out uint resultadoArvores, out uint[] resultadoGerm, out uint[] resultadoSementes, out DateTime dataFinal)
        {
            uint[] seedAgeNumber = new uint[numSementes.Length];

            uint[] germNumber = new uint[Convert.ToInt32(data.germGrowTime)]; //Tempo em meses até virar planta adulta
            germNumber = numSemGerm;
            seedAgeNumber = numSementes;

            resultadoArvores = numArvores;

            DateTime dataFim,dataAtual;
            dataAtual = dataInicio;
            dataFim = dataInicio.AddYears(1);

            while(dataAtual.Date < dataFim.Date)
            {
                resultadoArvores += Convert.ToInt32(germNumber[Convert.ToInt32(data.germGrowTime)-1] * data.plantLostNumber); //Dadas as plantulas quantas viraram adultas?

                germNumber[germNumber.Length - 1] -= Convert.ToInt32(germNumber.Last() * data.plantLostNumber);  //Subtrair das plantulas o numero que virou adulto

                if (resultadoArvores > data.maxTreePopulation) //O numero de arvores não pode ultrapassar o limite do local
                {
                    resultadoArvores = data.maxTreePopulation;
                }

                germNumber[germNumber.Length - 1] += Convert.ToInt32(germNumber[germNumber.Length - 2] * data.plantLostNumber);

                for (int i = germNumber.Length - 2; i > 0; i--)
                {
                    germNumber[i] = Convert.ToInt32(germNumber[i - 1] * data.plantLostNumber); //As semestes do prox mes é o numero de sementes do
                }                                                                    //mes anterior menos a perda de sementes

                germNumber[germNumber.Length-1]= Convert.ToInt32(germNumber.Last() * data.plantLostNumber);


                if (IsEnougthRain(dataAtual)) //Choveu o suficiente para as sementes quebrarem a dormência?
                {
                    germNumber[0] = Convert.ToUInt32(seedAgeNumber.Last() * data.seedLostNumber * NewGerminationProb(dataAtual));
                    seedAgeNumber[seedAgeNumber.Length - 1] = 0;
                }
                else
                {
                    seedAgeNumber[seedAgeNumber.Length - 1] += Convert.ToInt32(seedAgeNumber[seedAgeNumber.Length - 2] * data.seedLostNumber);
                }

                for (int i = seedAgeNumber.Length - 1; i > 0; i--) //Calculo da perda de sementes todos os meses
                {
                    seedAgeNumber[i] = Convert.ToInt32(seedAgeNumber[i - 1] * data.seedLostNumber); //As semestes do prox mes é o numero de sementes do
                    //mes anterior menos a perda de sementes
                }

                //Queda de sementes por árvores e plantulas
                seedAgeNumber[0] = (resultadoArvores * data.seedFallAdultP) + (germNumber.Last() * data.seedFallYoungP); //Apenas as ultimas germinações mandam sementes

                dataAtual = dataAtual.AddMonths(1);           //Avanço de um mês
            }

            //Numero de sementes
            resultadoSementes = seedAgeNumber;
                        
            //Numero de germinações
            resultadoGerm = germNumber;

            dataFinal = dataFim;
                                  
 
        }

        //Função que zera as variaveis de simulação, mantendo os dados do clima,
        //pluviosidade, etc... e coloca novos dados de sementes e plantas
        public void NewData(int numSementes, int numSemGerm, int numArvores)
        {
            data.numberSeeds = numSementes;
            data.numberYoungPlants = numSemGerm;
            data.numberAdultPlants = numArvores;

            seedAgeNumber[0] = data.numberSeeds;

            germAgeNumber = new int[Convert.ToInt32(data.germGrowTime)]; //Tempo em meses até virar planta adulta
            germAgeNumber[0] = data.numberYoungPlants;

            for (int i = 1; i < seedAgeNumber.Length; i++)
            {
                seedAgeNumber[i] = 0;
            }

            for (int i = 1; i < germAgeNumber.Length; i++)
            {
                germAgeNumber[i] = 0;
            }

            LastSeedNumber = 0;
            LastGermNumber = 0;
            LastPlantNumber = 0;
        }

        private Light NewLuminosity()    //Retorna um valor aleatório de claro ou escuro
        {                                           //dependendo da porcentagem da luminosidade
            if (lumiRnd.NextDouble() >= data.dominatLuminosity)
            {
                return Light.escuro;
            }
            else
            {
                return Light.claro;
            }
        }

        public int GetSeedNumber()
        {
            int result = 0;
            for (int i = 0; i < data.seedSleepTime; i++)
            {
                result += seedAgeNumber[i];
            }
            if (result > data.maxSeedNumber)
            {
                result = data.maxSeedNumber;
            }
            return result;
        }

        public int GetYoungPlantNumber()
        {
            int result = 0;
            for (int i = 0; i < germAgeNumber.Length; i++)
            {
                result += germAgeNumber[i];
            }
            return result;
        }
        public int GetYoungPlantNumber(int numMaximoSementes)
        {
            int result = 0;
            for (int i = 0; i < germAgeNumber.Length; i++)
            {
                result += germAgeNumber[i];
            }
            if (result > numMaximoSementes)    //Fazer uma mudança para colocar maximo de sementes germinadas
            {
                result = numMaximoSementes;
            }
            return result;
        }

        public int GetAdultPlantNumber()
        {
            return data.numberAdultPlants;
        }

        private bool IsEnougthRain(DateTime dataAtual) //Joga na sorte se o mes está para cuva maior que o minimo ou nao
        {
            if (climateRnd.NextDouble() <= data.rainProbability[PresentDate.Month-1])
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private Double NewGerminationProb(DateTime dataAtual)
        {
            if (lumiRnd.NextDouble() < data.dominatLuminosity)
            {
                if (climateRnd.NextDouble() <= data.tempProbability[dataAtual.Month-1])
                {
                    return GermProb[1, 1];
                }
                else
                {
                    return GermProb[0, 1];
                }
            }
            else
            {
                if(climateRnd.NextDouble() <= data.tempProbability[dataAtual.Month-1])
                {
                    return GermProb[1, 0];
                }
                else
                {
                    return GermProb[0, 0];
                }
            }
        }
    }
}