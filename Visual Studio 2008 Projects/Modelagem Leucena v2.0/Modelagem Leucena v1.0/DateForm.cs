using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Modelagem_Leucena_v1._0
{
    public partial class DateForm : Form
    {
        public DateForm()
        {
            InitializeComponent();
        }

        public DateForm(bool InitTrue,DateTime dataAnterior)
        {
            InitializeComponent();
            if (InitTrue == false)
            {
                this.Text = "Data Final";
                this.labelTypeData.Text = "Escolha a Data Final";
            }
            dateTimePickerDateForm.Value = dataAnterior.Date;
            
        }

        private void buttonOK_DateForm_Click(object sender, EventArgs e)
        {
            Form1  frm1 = (Form1)Application.OpenForms["Form1"];

            frm1.dataInicial = dateTimePickerDateForm.Value;
            this.Enabled = false;
            this.Dispose();
            
        }

    }
}
