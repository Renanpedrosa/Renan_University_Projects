using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
//using System.Convert;

namespace Modelagem_Leucena_v1._0
{
    public partial class SimulationConfig : Form
    {

        ConfigData dadosCfg = new ConfigData(true); //Dados inicializados
        public string[] Months = new string[12]
        {
            "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto",
            "Setembro", "Outubro", "Novembro", "Dezembro"
        };
        DataTable PrecipitationTable;
        DataTable TempTable;
        DataRow myLine;
                

        public SimulationConfig()
        {
            InitializeComponent();
            dadosCfg = new ConfigData(false);

            PrecipitationTable = CreatePrecipitationTable(dadosCfg);
            TempTable = CreateTempTable(dadosCfg);

            dataGridViewRain.DataSource = PrecipitationTable;
            dataGridViewTemp.DataSource = TempTable;

            FillBoxesWithData(dadosCfg);
            

        }

        private void buttonCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void buttonClearAll_Click(object sender, EventArgs e)
        {
            textBoxAdultPlantNumber.Text = "0";
            textBoxFallSeedAdult.Text = "0";
            textBoxFallSeedYoung.Text = "0";
            textBoxPlantArea.Text = "0";
            textBoxPlantLostFactor.Text = "0";
            textBoxSeedLostFactor.Text = "0";
            textBoxSeedNumber.Text = "0";
            textBoxYoungPlantNumber.Text = "0";
        }

        private void buttonOK_Click(object sender, EventArgs e)
        {
            dadosCfg.numberSeeds = Convert.ToInt32(textBoxSeedNumber.Text);
            dadosCfg.numberAdultPlants = Convert.ToInt32(textBoxAdultPlantNumber.Text);
            dadosCfg.numberYoungPlants = Convert.ToInt32(textBoxYoungPlantNumber.Text);
            dadosCfg.plantArea = Convert.ToDouble(textBoxPlantArea.Text);

            dadosCfg.seedFallAdultP = Convert.ToInt32(textBoxFallSeedAdult.Text);
            dadosCfg.seedFallYoungP = Convert.ToInt32(textBoxFallSeedYoung.Text);
            dadosCfg.seedLostNumber = Convert.ToDouble(textBoxSeedLostFactor.Text);
            dadosCfg.plantLostNumber = Convert.ToDouble(textBoxPlantLostFactor.Text);

            dadosCfg.dominatLuminosity = Convert.ToDouble(textBoxNormalLuminosity.Text);
            dadosCfg.seedSleepTime = Convert.ToInt32(textBoxDormancyBrake.Text);
            dadosCfg.treeSpaceRadius= Convert.ToDouble(textBoxTreeRadius.Text);
            dadosCfg.minPrecipitation= Convert.ToDouble(textBoxMinimalPrecipitation.Text);

            //Dados da aba Otimização
            dadosCfg.seedPackageSize= Convert.ToInt32(textBoxSeedPackageNumber.Text);
            dadosCfg.maxSeedNumber = Convert.ToInt32(textBoxMaxNumberSeeds.Text);
            dadosCfg.maxNumberCuts = Convert.ToInt32(textBoxMaxTreeCuts.Text);
            dadosCfg.maxNumberTrees = Convert.ToInt32(textBoxMaxTreeNumber.Text);
            dadosCfg.maxTreePopulation = Convert.ToInt32(textBoxMaxTreePopulation.Text);
   

            dadosCfg.decisionTimeStep = Convert.ToInt32(textBoxTimeBtwDecsion.Text);
            dadosCfg.initialCutCost = Convert.ToDouble(textBoxInitialCost.Text);
            dadosCfg.treeCutCost =  Convert.ToDouble(textBoxTreeCost.Text);
            dadosCfg.taxaJuros = Convert.ToDouble(textBoxAnnualTax.Text);

            dadosCfg.initialDate = dateTimePicker1.Value.Date;
            dadosCfg.finalDate = dateTimePicker2.Value.Date;


            this.Close();
        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        private void buttonDefaultValues_Click(object sender, EventArgs e)
        {
            dadosCfg = new ConfigData(true);
            FillBoxesWithData(dadosCfg);
                        
        }

        private void FillBoxesWithData(ConfigData dadoscfg)
        {
            //Dados da aba Simulação
            textBoxSeedNumber.Text = dadoscfg.numberSeeds.ToString();
            textBoxYoungPlantNumber.Text = dadoscfg.numberYoungPlants.ToString();
            textBoxAdultPlantNumber.Text = dadoscfg.numberAdultPlants.ToString();
            textBoxPlantArea.Text = dadoscfg.plantArea.ToString();

            textBoxFallSeedAdult.Text = dadoscfg.seedFallAdultP.ToString();
            textBoxFallSeedYoung.Text = dadoscfg.seedFallYoungP.ToString();
            textBoxSeedLostFactor.Text = dadoscfg.seedLostNumber.ToString();
            textBoxPlantLostFactor.Text = dadoscfg.plantLostNumber.ToString();

            textBoxNormalLuminosity.Text = dadoscfg.dominatLuminosity.ToString();
            textBoxDormancyBrake.Text = dadoscfg.seedSleepTime.ToString();
            textBoxTreeRadius.Text = dadoscfg.treeSpaceRadius.ToString();
            textBoxMinimalPrecipitation.Text = dadoscfg.minPrecipitation.ToString();

            //Dados da aba Otimização
            textBoxSeedPackageNumber.Text = dadoscfg.seedPackageSize.ToString();
            textBoxMaxNumberSeeds.Text = dadoscfg.maxSeedNumber.ToString();
            textBoxMaxTreeCuts.Text = dadoscfg.maxNumberCuts.ToString();
            textBoxMaxTreeNumber.Text = dadoscfg.maxNumberTrees.ToString();
            textBoxMaxTreePopulation.Text = dadosCfg.maxTreePopulation.ToString();

            textBoxTimeBtwDecsion.Text = dadoscfg.decisionTimeStep.ToString();
            textBoxInitialCost.Text = dadoscfg.initialCutCost.ToString();
            textBoxTreeCost.Text = dadoscfg.treeCutCost.ToString();
            textBoxAnnualTax.Text = dadoscfg.taxaJuros.ToString();

            myLine = PrecipitationTable.NewRow();         
            for (int i = 0; i < 12; i++)
            {
                myLine[i] = dadoscfg.rainProbability[i];
            }
            PrecipitationTable.Rows.RemoveAt(0);
            PrecipitationTable.Rows.Add(myLine);

            //dataGridViewRain.DataSource = PrecipitationTable;

            myLine = TempTable.NewRow();
            for (int i = 0; i < 12; i++)
            {
                myLine[i] = dadoscfg.tempProbability[i];
            }
            TempTable.Rows.RemoveAt(0);
            TempTable.Rows.Add(myLine);
            //dataGridViewTemp.DataSource = TempTable;
        }


        private DataTable CreatePrecipitationTable(ConfigData dados)
        {
            DataTable tabelaPrec = new DataTable("Precipitação");
            
            DataRow myLine;
            string columnName; 

            for (int i = 0; i < 12; i++)
            {
                columnName = Months[i];
                tabelaPrec.Columns.Add(columnName, typeof(double));
            }
            myLine = tabelaPrec.NewRow();
            for (int i = 0; i < 12; i++)
            {
                myLine[i] = dados.rainProbability[i];
            }
            tabelaPrec.Rows.Add(myLine);

            return tabelaPrec;
        }

        private DataTable CreateTempTable(ConfigData dados)
        {
            DataTable tabelaTemp = new DataTable("Temperatura");
            
            DataRow myLine;
            string columnName;

            for (int i = 0; i < 12; i++)
            {
                columnName = Months[i];
                tabelaTemp.Columns.Add(columnName, typeof(double));
            }
            myLine = tabelaTemp.NewRow();
            for (int i = 0; i < 12; i++)
            {
                myLine[i] = dados.tempProbability[i];
            }
            tabelaTemp.Rows.Add(myLine);

            return tabelaTemp;
        }

        public ConfigData GetConfigData()
        {
            return dadosCfg;
        }

    }
}
