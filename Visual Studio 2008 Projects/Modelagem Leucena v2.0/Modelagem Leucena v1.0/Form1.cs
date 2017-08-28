using System;
using System.Windows.Forms;
using System.Data;
using System.Numeric;
using System.Linq;
using System.Threading;

namespace Modelagem_Leucena_v1._0
{
    public partial class Form1 : Form
    {
        //Declaração de variaveis globais
        public DateTime dataInicial;
        DateTime InitialDate;
        DateTime FinalDate;

        double[,] costsMatrix;           //Matriz de Custos[numero de arvores][intervalo]

        ConfigData data = new ConfigData(true);
        PlantSimulation Plant;

        bool okGoSimulation;

        DataTable simuTable;

        enum YearMonths  {Janeiro, Fevereiro, Marco, Abril, Maio, Junho, Julho, Agosto,
            Setembro, Outubro, Novembro, Dezembro};

        public struct variables
        {
            public int trees;
            public int[] seeds;
            public int[] gSeeds;
            public int cutTrees;
            public DateTime dataAtual;
        }
        
        


        public Form1()
        {
            InitializeComponent();
            okGoSimulation = false;
        }

        public void generateReport()
        {
            string simulationText;
                        
            InitialDate = new DateTime();
            FinalDate = new DateTime();
            InitialDate = data.initialDate;
            FinalDate = data.finalDate;

            tabControl1.Visible = true;


            simulationText = "\r==============================================================\r\n";
            simulationText += "\r===                                                        ===\r\n";
            simulationText += "\r===       Simulação de Crescimento - SimuPlants v 1.0      ===\r\n";
            simulationText += "\r===                                                        ===\r\n";
            simulationText += "\r==============================================================\r\n\n";
            simulationText += "\rDados Técnicos da Planta\r\n";
            simulationText += "\r------------------------\r\n\n";
            simulationText += "\rNome Científico: " + textBoxSciName.Text + "\r\n";
            simulationText += "\rNome Popular:" + textBoxPlantName.Text + "\r\n";
            simulationText += "\rLatitude, Longitude, Altitude, Bioma\r\n";
            simulationText += "\rHabitat: Parque Ecológico da Pamplha\r\n\r\n";
            simulationText += "\rFator de Perda de Sementes: "+(data.seedLostNumber*100.0).ToString()+"%\r\n\nFator de Perda de Plantas: "+(data.plantLostNumber*100.0).ToString()+"%\r\n";
            simulationText += "\rData de Início:  " + InitialDate.Day + "/" + InitialDate.Month + "/" + InitialDate.Year + "\r\n";
            simulationText += "\rData de Término: " + FinalDate.Day + "/" + FinalDate.Month + "/" + FinalDate.Year + "\r\n\r\n\r\n";
            simulationText += "\rResultados da Simulação\r\n-----------------------\r\n\r\n";
            simulationText +=
@" _______________________________________________
| Valor           | Início     |     Término    |
|_________________|____________|________________|
|                 |            |                |
|Sementes         |         0  |          5000  |
|_________________|____________|________________|
|                 |            |                |
|Plantas Jovens   |         0  |           100  |
|_________________|____________|________________|
|                 |            |                |
|Plantas Adultas  |         1  |           200  |
|_________________|____________|________________|
";
            textBoxPresentDay.Text = data.initialDate.Day.ToString();
            textBoxPresentMonth.Text = data.initialDate.Month.ToString();
            textBoxPresentYear.Text = data.initialDate.Year.ToString();
            textBoxOutput.Text = simulationText;

            //Otimizar();
        }

        public void Otimizar()
        {
            int numberOfStages;      //Número de estágios para circular todas as decisões
            //int initialSeedNumber;
            //int initialGermSeedsNumber = numberYoungPlants;
            //int initialTreeNumber = numberAdultPlants;

            DataTable Results;

            DateTime Futuro;
            
            double[, , , ,] bestCostDecision; //[estagio,arvores,sementes jovens,sementes germinadas, numero de cortes]
            double[] bestCost;
            double[] testCost;
            //double[] custo;                   //Custo de cada árvore
            double custoPresente;
            //double custo;
            //double custoSim2;
            double custo;
            double custoMin;
            int cutTreeMin;
            int cutTreeMin2;
            int cutTreeMin3;
            int cutTreeMin4;
            int cutTreeMin5;

            //int nextCutTree;
            //int nextCutTree2;

            int stage;

            int trees;
            int gSeed;
            int seeds;

            int trees2;
            int seeds2;
            int gSeed2;
            int treesSim;
            
            //nextCutTree2 = 0;

            stage = 0;

            trees = 0;
            gSeed = 0;
            seeds = 0;

            gSeed2 = 0;
            seeds2 = 0;
            trees2 = 0;
            treesSim = 0;
           
            

            Plant.PresentDate = FinalDate;

            //plantPackSize = 10;

            numberOfStages = Convert.ToInt32(Math.Floor((data.finalDate.Date - data.initialDate.Date).TotalDays / 365)); //Pegar o numero de decisoes

            bestCost = new double[numberOfStages+1];
            testCost = new double[numberOfStages+1];
            bestCostDecision = new double[numberOfStages+1, data.maxNumberTrees+1, (data.maxSeedNumber/data.seedPackageSize)+1, (data.maxSeedNumber/data.seedPackageSize)+1, (data.maxNumberCuts)+1];
            
            if(tabControl1.Visible == false)
                tabControl1.Visible = true; 
            
            costsMatrix = getCostMatrix(data.totalTimeSpan+1, data.maxNumberCuts+1, data.initialCutCost, data.treeCutCost, data.taxaJuros);

            dataGridViewCost.DataSource = getDecisionCostsTable(data.totalTimeSpan, data.maxNumberCuts, costsMatrix);

            //Formatando os valores para preço e colunas
            //Primeira Coluna
            dataGridViewCost.Columns[0].Frozen = true;
            dataGridViewCost.Columns[0].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            //Demais colunas
            for (int i = 1; i <= data.totalTimeSpan; i++)
            {
                dataGridViewCost.Columns[i].DefaultCellStyle.Format = "c";
                dataGridViewCost.Columns[i].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
                dataGridViewCost.Columns[i].DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            }

             //Tempo em meses até virar planta adulta

            variables[] bestVar = new variables[numberOfStages+2];

            variables[] testVar = new variables[numberOfStages+2];

            for(int i = 0;i <= numberOfStages;i++)
            {
                bestVar[i].gSeeds = new int[Convert.ToInt32(data.germGrowTime)];
                bestVar[i].seeds = new int[Convert.ToInt32(data.seedSleepTime)];

                testVar[i].gSeeds = new int[Convert.ToInt32(data.germGrowTime)];
                testVar[i].seeds = new int[Convert.ToInt32(data.seedSleepTime)];
            }

            //Loop de Estágios
            //----------------
            //stage ->  estagio do loop, vai de 0 até o numero de anos da simulação
            //trees -> numero de arvores
            //seeds -> numero de sementes dentro dobanco de sementes
            //aSeed -> numero de sementes que quebraram a dormencia
            //cutTrees -> numero de árvores cortadas
            //
            //
            // Obs!! - Fazer a função do custo intercambiável
            //
            bestVar[0].trees = data.numberAdultPlants;
            bestVar[0].gSeeds[0] = data.numberYoungPlants;
            bestVar[0].seeds[0] = data.numberSeeds;
            bestVar[0].cutTrees = 0;
            bestVar[0].dataAtual = data.initialDate;

            testVar[0] = bestVar [0];

            stage = 0;
                
            cutTreeMin = testVar[stage].trees - data.maxNumberTrees;   //fala se chegou ao corte minimo de árvores
            if (cutTreeMin < 0)
                cutTreeMin = 0;
                        
            custoMin = getCost(stage,data.maxTreePopulation,data) * numberOfStages;//   -> Para evitar que não saia do zero
            
            //Primeiro Ano
            for (int cutTrees = cutTreeMin; cutTrees <= data.maxTreePopulation; cutTrees++)
            {
                //Cortando arvores
                testVar[stage].cutTrees = cutTrees;

                //Simulação
                Plant.OneYearSimulation(data,testVar[stage].seeds, testVar[stage].gSeeds, testVar[stage].trees - testVar[stage].cutTrees, testVar[stage].dataAtual,
                                out testVar[stage + 1].trees, out testVar[stage + 1].gSeeds, out testVar[stage + 1].seeds, out testVar[stage + 1].dataAtual);

                stage = 1;

                //Verificando o corte minimo para o segundo ano
                cutTreeMin2 = testVar[stage].trees - data.maxNumberTrees;   //fala se chegou ao corte minimo de árvores
                if (cutTreeMin2 < 0)
                    cutTreeMin2 = 0;
              
                //Segundo Ano
                for (int cutTrees2 = cutTreeMin2; cutTrees <= data.maxTreePopulation; cutTrees++)
                {
                    //Cortando arvores
                    testVar[stage].cutTrees = cutTrees2;

                    //Simulação
                    Plant.OneYearSimulation(data, testVar[stage].seeds, testVar[stage].gSeeds, testVar[stage].trees - testVar[stage].cutTrees, testVar[stage].dataAtual,
                                out testVar[stage + 1].trees, out testVar[stage + 1].gSeeds, out testVar[stage + 1].seeds, out testVar[stage + 1].dataAtual);

                    stage = 2;

                    cutTreeMin3 = testVar[stage].trees - data.maxNumberTrees;   //fala se chegou ao corte minimo de árvores
                    if (cutTreeMin3 < 0)
                        cutTreeMin3 = 0;

                    //Terceiro Ano
                    for (int cutTrees3 = cutTreeMin3; cutTrees3 <= data.maxTreePopulation; cutTrees3++)
                    {
                        //Cortando arvores
                        testVar[stage].cutTrees = cutTrees3;

                        //Simulação
                        Plant.OneYearSimulation(data, testVar[stage].seeds, testVar[stage].gSeeds, testVar[stage].trees - testVar[stage].cutTrees, testVar[stage].dataAtual,
                                out testVar[stage + 1].trees, out testVar[stage + 1].gSeeds, out testVar[stage + 1].seeds, out testVar[stage + 1].dataAtual);

                        stage = 3;

                        cutTreeMin4 = testVar[stage].trees - data.maxNumberTrees;   //fala se chegou ao corte minimo de árvores
                        if (cutTreeMin4 < 0)
                            cutTreeMin4 = 0;

                        //Quarto Ano
                        for (int cutTrees4 = cutTreeMin4; cutTrees4 <= data.maxTreePopulation; cutTrees4++)
                        {
                            //Cortando arvores
                            testVar[stage].cutTrees = cutTrees4;

                            //Simulação
                            Plant.OneYearSimulation(data, testVar[stage].seeds, testVar[stage].gSeeds, testVar[stage].trees - testVar[stage].cutTrees, testVar[stage].dataAtual,
                                out testVar[stage + 1].trees, out testVar[stage + 1].gSeeds, out testVar[stage + 1].seeds, out testVar[stage + 1].dataAtual);

                            stage = 4;

                            cutTreeMin5 = testVar[stage].trees - data.maxNumberTrees;   //fala se chegou ao corte minimo de árvores
                            if (cutTreeMin5 < 0)
                                cutTreeMin5 = 0;

                            testVar[stage].cutTrees = cutTreeMin5;

                            custoPresente = 0;

                            //Calculando o custo total!
                            for (int i = 0; i <= 4; i++)
                            {
                                custo = getCost(i, testVar[i].cutTrees, data);
                                testCost[i] = custo;
                                custoPresente += custo;
                            }

                            if ((custoPresente < custoMin)/*&&(testVar[4].trees <= 30)*/)
                            {
                                bestVar = testVar;
                                custoMin = custoPresente;
                                bestCost = testCost;
                            }
                        }
                    }


                    //É preciso ver se continua dando certo depois!!!...
                    //Continuar a partir daqui

                }

            }

            //Notas!!! - o bestVar do primeiro estágio esta dando valores muito grandes OK
            // - ajustar o corte de arvores para o minimo pensando no numero maximo de arvores OK
            //ajustar variavel de numero máximo de arvores possivel, ele é diferente e maior do data.maxNumberTrees OK
            //
            // - Problema na simulação averiguar as variaveis LastSeedNumber, GermNumber e AdultPlants
            // - 
            //
            Results = getResultTable(numberOfStages + 1, bestVar, bestCost);


            dataGridViewResults.DataSource = Results;

            for (int i = 0; i < dataGridViewResults.Columns.Count; i++)
            {
                dataGridViewResults.Columns[i].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft;
                dataGridViewResults.Columns[i].DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            }         
            dataGridViewResults.Columns["Resultado"].DefaultCellStyle.Format = "c";
            tabControl1.SelectTab(tabPageResultTable);
        }

      
        //Função que retorna uma matriz com o valor de arvores cortadas ao longo do tempo
        private double[,] getCostMatrix(int numberYears, int numberTrees, double initialCost, double treeCost, double taxaJuros)
        {
            double[,] matrizCusto = new double[numberTrees, numberYears+1];


            for (int tree = 0; tree < numberTrees; tree++)
            {
                if (tree == 0) //Se não tiver nenhuma árvore para cortar
                {
                    for (int year = 0; year < numberYears; year++)
                    {
                        matrizCusto[tree, year] = (treeCost * tree) / Math.Pow((1 + taxaJuros), ((double)year));
                    }
                }
                else          //Caso contrário somar custo adicional
                {
                    for (int year = 0; year < numberYears; year++)
                    {
                        matrizCusto[tree, year] = initialCost + (treeCost * tree) / Math.Pow((1 + taxaJuros), ((double)year));
                    }
                }
            }

            return matrizCusto;

        }

        private double getCost(int presentYear, int numberTrees, ConfigData dadosConfiguracao)
        {
            if (numberTrees == 0) //Se não tiver nenhuma árvore para cortar
            {
                return 0;
            }
            else          //Caso contrário somar custo adicional
            {
                return dadosConfiguracao.initialCutCost + (dadosConfiguracao.treeCutCost * numberTrees) / Math.Pow((1 + dadosConfiguracao.taxaJuros), ((double)presentYear));
            }
        }

        private DataTable getDecisionCostsTable(int numberMonths, int numberTrees, double[,] matrizCusto)
        {
            DataTable tabelaFinal = new DataTable("Tabela de Custos");
            DataRow myLine;
                       
            string columnName; 
       

            tabelaFinal.Columns.Add("Árvores Cortadas",typeof(int));

            for(int i = 1; i <= numberMonths; i++)
            {
                columnName = "Ano " + i.ToString();
                tabelaFinal.Columns.Add(columnName,typeof(double));
            }

            //Criando as linhas de acordo com o numero de colunas
            for (int i = 0; i < numberTrees; i++)
            {
                myLine = tabelaFinal.NewRow();
                myLine[0] = i;
                for(int j = 1; j <= numberMonths; j++)
                {
                    myLine[j] = matrizCusto[i, j-1];
                }
                tabelaFinal.Rows.Add(myLine);
            }
            
            return tabelaFinal;
        }

        private DataTable getResultTable(int numStages, variables[] melhorResultado, double[] melhorCusto)
        {
            DataTable tabelaFinal = new DataTable("Tabela de Resultados");
            DataRow myLine;

            Int64 linhas;

            tabelaFinal.Columns.Add("Ano", typeof(int));
            tabelaFinal.Columns.Add("Árvores", typeof(int));
            tabelaFinal.Columns.Add("Germinações", typeof(int));
            tabelaFinal.Columns.Add("Sementes", typeof(int));
            tabelaFinal.Columns.Add("Cortes", typeof(int));
            tabelaFinal.Columns.Add("Resultado", typeof(double));

            linhas = numStages;

            //Criando as linhas de acordo com o numero de colunas
            for (int stg = 0; stg < numStages; stg++)
            {
                                myLine = tabelaFinal.NewRow();
                                myLine[0] = stg;
                                myLine[1] = melhorResultado[stg].trees;
                                myLine[2] = melhorResultado[stg].gSeeds.Sum();
                                myLine[3] = melhorResultado[stg].seeds.Sum();
                                myLine[4] = melhorResultado[stg].cutTrees;
                                myLine[5] = melhorCusto[stg];
                                tabelaFinal.Rows.Add(myLine);               
            }
            return tabelaFinal;
        }

        
        private bool Optimize()
        {
            return true;
        }


        private void buttonClearAll_Click(object sender, EventArgs e)
        {
            textBoxOutput.Text = "";
            textBoxPresentDay.Text = "";
            textBoxPresentMonth.Text = "";
            textBoxPresentYear.Text = "";
        }

        private void gerarRelatórioToolStripMenuItem_Click(object sender, EventArgs e)
        {
            generateReport();
        }

        private void dataInicialToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //dateTimePickerInit.Focus();
        }

        private void setarDataFinalToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //dateTimePickerFinal.Focus();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            CarregarDados();
        }


        private void buttonAdvanceMonth_Click(object sender, EventArgs e)
        {
            DataRow myLine;
            //try
            //{
                //Dados não carregados de acordo
                if (okGoSimulation == false)
                {
                    System.Windows.Forms.MessageBox.Show("Dados não preenchidos.");
                }
                else
                {
                    if (Plant.NextMonth() == false)//Se chegou ao final
                    {
                        System.Windows.Forms.MessageBox.Show("Fim da Simulação");
                    }
                    else
                    {
                        myLine = simuTable.NewRow();
                        myLine["Data"] = Plant.PresentDate.Date;
                        myLine["NP"] = Plant.GetAdultPlantNumber();
                        myLine["NS"] = Plant.GetSeedNumber();
                        myLine["NG"] = Plant.GetYoungPlantNumber();
                        simuTable.Rows.Add(myLine);

                        textBoxAdultPlantsNumber.Text = myLine["NP"].ToString();
                        textBoxSeedNumber.Text = myLine["NS"].ToString();
                        textBoxYouthPlantsNumber.Text = myLine["NG"].ToString();
                        textBoxPresentDay.Text = Plant.PresentDate.Day.ToString();
                        textBoxPresentMonth.Text = Plant.PresentDate.Month.ToString();
                        textBoxPresentYear.Text = Plant.PresentDate.Year.ToString();
                    }
                }

            //}
            //catch (Exception ex )
            //{
                //System.Windows.Forms.MessageBox.Show("Mensagem de Erro: " + ex.ToString());
            //}

        }

        private void CarregarDados()
        {
            SimulationConfig simucfg = new SimulationConfig();
            DataRow myLine;
            if (simucfg.ShowDialog(this) == DialogResult.OK)
            {
                data.CopyConfigData(simucfg.GetConfigData()); //Se a pessoa apertou ok copiar os dados
                System.Windows.Forms.MessageBox.Show("Dados Salvos com Sucesso");
                okGoSimulation = true;

                simuTable = new DataTable("Tabela de Simulação");
                simuTable.Columns.Add("Data",System.Type.GetType("System.DateTime"));
                simuTable.Columns.Add("NP", System.Type.GetType("System.Int32"));
                simuTable.Columns.Add("NS", System.Type.GetType("System.Int32"));
                simuTable.Columns.Add("NG", System.Type.GetType("System.Int32"));

                
                costsMatrix = new double[data.maxNumberCuts, data.totalTimeSpan];

                tabControl1.Visible = true;

                InitialDate = data.initialDate;
                FinalDate = data.finalDate;
                Plant = new PlantSimulation(data.initialDate, data.finalDate, data);

                myLine = simuTable.NewRow();
                myLine["Data"] = Plant.PresentDate.Date;
                myLine["NP"] = Plant.GetAdultPlantNumber();
                myLine["NS"] = Plant.GetSeedNumber();
                myLine["NG"] = Plant.GetYoungPlantNumber();
                simuTable.Rows.Add(myLine);

                dataGridViewSimulation.DataSource = simuTable;
                dataGridViewSimulation.Columns["Data"].DefaultCellStyle.Format = "d";
                //dataGridViewSimulation.Columns["NP"].DefaultCellStyle.Format = "g";
                //dataGridViewSimulation.Columns["NG"].DefaultCellStyle.Format = "f";
                //dataGridViewSimulation.Columns["NS"].DefaultCellStyle.Format = "f";

                                                
            }
            else
            {
                System.Windows.Forms.MessageBox.Show("Utilizando dados Padrão");
                okGoSimulation = false;
            }
            textBoxInitialDate.Text = data.initialDate.ToShortDateString();
            textBoxFinalDate.Text = data.finalDate.ToShortDateString();
            textBoxSeedNumber.Text = data.numberSeeds.ToString();
            textBoxYouthPlantsNumber.Text = data.numberYoungPlants.ToString();
            textBoxAdultPlantsNumber.Text = data.numberAdultPlants.ToString();
            textBoxSimulationTime.Text = (data.finalDate.Date- data.initialDate.Date).TotalDays.ToString() + " dias";
            simucfg.Dispose();
        }

        
        private void preencherDadosToolStripMenuItem_Click(object sender, EventArgs e)
        {
            CarregarDados();
        }

        private void otimizaçãoToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Otimizar();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Otimizar();
        }


      

       
    }
}





/*
 * Proximos passos:
 * 
 * - Loop que faz diversos calculos de cada ano. O modelo é sequencial e faz o calculo de benefício apenas no final dos loops
 * - Exemplo:
 *      
 *                    CA
 *                  /
 *                C31 - CB
 *              / 
 *            C21- C32 - CA
 *          /        \
 *       C1          CB
 *          \
 *            C22 - C33 - CA
 *             |      \
 *            C34      CB
 *           /   \
 *          CA   CB
 * 
 * 
 *   Cada traço é a simulação de um ano, e os custos com letras são a soma de todos os cortes de arvores
 *   O loop sera dessa forma:
 *   
 *   menor custo = maximo custo    -> Para evitar que não saia do zero
 *   
 *   //Primeiro Ano
 *   for(cortes = min ;cortes < numArvores
 *   { 
 *      numArv maior que o numMax?
 *      Corta!
 *      Simula()
 *   
 *      //Segundo Ano
 *      for(cortes = min ;cortes < numArvores
 *      {
 *         numArv maior que o numMax?
 *         Corta!
 *         Simula()
 *         
 *         //Terceiro Ano
 *         for(cortes = min ;cortes < numArvores
 *         {
 *            numArv maior que o numMax?
 *            Corta!
 *            Simula()
 *            Custo = soma de todos os cortes
 *            
 *            É o menor custo?
 *            Armazena todas as variaveis!
 *         }
 *      }
 *   }
 * 
*/