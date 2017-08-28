namespace Modelagem_Leucena_v1._0
{
    partial class DateForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.labelTypeData = new System.Windows.Forms.Label();
            this.dateTimePickerDateForm = new System.Windows.Forms.DateTimePicker();
            this.buttonOK_DateForm = new System.Windows.Forms.Button();
            this.buttonCancel_DateForm = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // labelTypeData
            // 
            this.labelTypeData.AutoSize = true;
            this.labelTypeData.Location = new System.Drawing.Point(12, 9);
            this.labelTypeData.Name = "labelTypeData";
            this.labelTypeData.Size = new System.Drawing.Size(110, 13);
            this.labelTypeData.TabIndex = 0;
            this.labelTypeData.Text = "Escolha a Data Inicial";
            // 
            // dateTimePickerDateForm
            // 
            this.dateTimePickerDateForm.Location = new System.Drawing.Point(12, 43);
            this.dateTimePickerDateForm.Name = "dateTimePickerDateForm";
            this.dateTimePickerDateForm.Size = new System.Drawing.Size(231, 20);
            this.dateTimePickerDateForm.TabIndex = 1;
            // 
            // buttonOK_DateForm
            // 
            this.buttonOK_DateForm.Location = new System.Drawing.Point(15, 90);
            this.buttonOK_DateForm.Name = "buttonOK_DateForm";
            this.buttonOK_DateForm.Size = new System.Drawing.Size(75, 23);
            this.buttonOK_DateForm.TabIndex = 2;
            this.buttonOK_DateForm.Text = "OK";
            this.buttonOK_DateForm.UseVisualStyleBackColor = true;
            this.buttonOK_DateForm.Click += new System.EventHandler(this.buttonOK_DateForm_Click);
            // 
            // buttonCancel_DateForm
            // 
            this.buttonCancel_DateForm.Location = new System.Drawing.Point(168, 90);
            this.buttonCancel_DateForm.Name = "buttonCancel_DateForm";
            this.buttonCancel_DateForm.Size = new System.Drawing.Size(75, 23);
            this.buttonCancel_DateForm.TabIndex = 3;
            this.buttonCancel_DateForm.Text = "Cancela";
            this.buttonCancel_DateForm.UseVisualStyleBackColor = true;
            // 
            // DateForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(264, 125);
            this.Controls.Add(this.buttonCancel_DateForm);
            this.Controls.Add(this.buttonOK_DateForm);
            this.Controls.Add(this.dateTimePickerDateForm);
            this.Controls.Add(this.labelTypeData);
            this.Name = "DateForm";
            this.Text = "Data Inicial";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label labelTypeData;
        private System.Windows.Forms.DateTimePicker dateTimePickerDateForm;
        private System.Windows.Forms.Button buttonOK_DateForm;
        private System.Windows.Forms.Button buttonCancel_DateForm;
    }
}