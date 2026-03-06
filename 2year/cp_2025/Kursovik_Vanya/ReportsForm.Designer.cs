namespace Kursovik
{
    partial class ReportsForm
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
            this.groupBoxFILTER = new System.Windows.Forms.GroupBox();
            this.CreateReport = new System.Windows.Forms.Button();
            this.dateTimePickerEnd = new System.Windows.Forms.DateTimePicker();
            this.dateTimePickerStart = new System.Windows.Forms.DateTimePicker();
            this.EndPeriod = new System.Windows.Forms.Label();
            this.StartPeriod = new System.Windows.Forms.Label();
            this.backgroundWorker1 = new System.ComponentModel.BackgroundWorker();
            this.dataGridViewORDER = new System.Windows.Forms.DataGridView();
            this.CountOrderText = new System.Windows.Forms.Label();
            this.SummText = new System.Windows.Forms.Label();
            this.Summ = new System.Windows.Forms.Label();
            this.SavePDF = new System.Windows.Forms.Button();
            this.CloseOrders = new System.Windows.Forms.Button();
            this.orderCount = new System.Windows.Forms.Label();
            this.groupBoxFILTER.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewORDER)).BeginInit();
            this.SuspendLayout();
            // 
            // groupBoxFILTER
            // 
            this.groupBoxFILTER.Controls.Add(this.CreateReport);
            this.groupBoxFILTER.Controls.Add(this.dateTimePickerEnd);
            this.groupBoxFILTER.Controls.Add(this.dateTimePickerStart);
            this.groupBoxFILTER.Controls.Add(this.EndPeriod);
            this.groupBoxFILTER.Controls.Add(this.StartPeriod);
            this.groupBoxFILTER.Location = new System.Drawing.Point(12, 23);
            this.groupBoxFILTER.Name = "groupBoxFILTER";
            this.groupBoxFILTER.Size = new System.Drawing.Size(448, 128);
            this.groupBoxFILTER.TabIndex = 0;
            this.groupBoxFILTER.TabStop = false;
            // 
            // CreateReport
            // 
            this.CreateReport.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.CreateReport.Location = new System.Drawing.Point(112, 89);
            this.CreateReport.Name = "CreateReport";
            this.CreateReport.Size = new System.Drawing.Size(230, 24);
            this.CreateReport.TabIndex = 4;
            this.CreateReport.Text = "Создать отчёт";
            this.CreateReport.UseVisualStyleBackColor = true;
            this.CreateReport.Click += new System.EventHandler(this.CreateReport_Click);
            // 
            // dateTimePickerEnd
            // 
            this.dateTimePickerEnd.Location = new System.Drawing.Point(242, 48);
            this.dateTimePickerEnd.Name = "dateTimePickerEnd";
            this.dateTimePickerEnd.Size = new System.Drawing.Size(190, 20);
            this.dateTimePickerEnd.TabIndex = 3;
            // 
            // dateTimePickerStart
            // 
            this.dateTimePickerStart.Location = new System.Drawing.Point(242, 16);
            this.dateTimePickerStart.Name = "dateTimePickerStart";
            this.dateTimePickerStart.Size = new System.Drawing.Size(190, 20);
            this.dateTimePickerStart.TabIndex = 2;
            // 
            // EndPeriod
            // 
            this.EndPeriod.AutoSize = true;
            this.EndPeriod.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.EndPeriod.Location = new System.Drawing.Point(6, 48);
            this.EndPeriod.Name = "EndPeriod";
            this.EndPeriod.Size = new System.Drawing.Size(207, 16);
            this.EndPeriod.TabIndex = 1;
            this.EndPeriod.Text = "Выберите дату конца периода";
            // 
            // StartPeriod
            // 
            this.StartPeriod.AutoSize = true;
            this.StartPeriod.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.StartPeriod.Location = new System.Drawing.Point(6, 16);
            this.StartPeriod.Name = "StartPeriod";
            this.StartPeriod.Size = new System.Drawing.Size(216, 16);
            this.StartPeriod.TabIndex = 0;
            this.StartPeriod.Text = "Выберите дату начала периода";
            // 
            // dataGridViewORDER
            // 
            this.dataGridViewORDER.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewORDER.Location = new System.Drawing.Point(13, 157);
            this.dataGridViewORDER.Name = "dataGridViewORDER";
            this.dataGridViewORDER.Size = new System.Drawing.Size(447, 112);
            this.dataGridViewORDER.TabIndex = 1;
            // 
            // CountOrderText
            // 
            this.CountOrderText.AutoSize = true;
            this.CountOrderText.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.CountOrderText.Location = new System.Drawing.Point(10, 286);
            this.CountOrderText.Name = "CountOrderText";
            this.CountOrderText.Size = new System.Drawing.Size(294, 16);
            this.CountOrderText.TabIndex = 2;
            this.CountOrderText.Text = "Кол-во заказов за выбранный период:";
            // 
            // SummText
            // 
            this.SummText.AutoSize = true;
            this.SummText.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.SummText.Location = new System.Drawing.Point(12, 311);
            this.SummText.Name = "SummText";
            this.SummText.Size = new System.Drawing.Size(292, 16);
            this.SummText.TabIndex = 4;
            this.SummText.Text = "Общая прибыль за выбранный период:";
            // 
            // Summ
            // 
            this.Summ.AutoSize = true;
            this.Summ.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Summ.Location = new System.Drawing.Point(310, 311);
            this.Summ.Name = "Summ";
            this.Summ.Size = new System.Drawing.Size(15, 16);
            this.Summ.TabIndex = 5;
            this.Summ.Text = "0";
            // 
            // SavePDF
            // 
            this.SavePDF.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.SavePDF.Location = new System.Drawing.Point(12, 340);
            this.SavePDF.Name = "SavePDF";
            this.SavePDF.Size = new System.Drawing.Size(201, 25);
            this.SavePDF.TabIndex = 6;
            this.SavePDF.Text = "Сохрнаить в PDF";
            this.SavePDF.UseVisualStyleBackColor = true;
            // 
            // CloseOrders
            // 
            this.CloseOrders.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.CloseOrders.Location = new System.Drawing.Point(259, 340);
            this.CloseOrders.Name = "CloseOrders";
            this.CloseOrders.Size = new System.Drawing.Size(201, 25);
            this.CloseOrders.TabIndex = 7;
            this.CloseOrders.Text = "Закрыть";
            this.CloseOrders.UseVisualStyleBackColor = true;
            this.CloseOrders.Click += new System.EventHandler(this.CloseOrders_Click);
            // 
            // orderCount
            // 
            this.orderCount.AutoSize = true;
            this.orderCount.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.orderCount.Location = new System.Drawing.Point(310, 286);
            this.orderCount.Name = "orderCount";
            this.orderCount.Size = new System.Drawing.Size(15, 16);
            this.orderCount.TabIndex = 8;
            this.orderCount.Text = "0";
            // 
            // ReportsForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(473, 386);
            this.Controls.Add(this.orderCount);
            this.Controls.Add(this.CloseOrders);
            this.Controls.Add(this.SavePDF);
            this.Controls.Add(this.Summ);
            this.Controls.Add(this.SummText);
            this.Controls.Add(this.CountOrderText);
            this.Controls.Add(this.dataGridViewORDER);
            this.Controls.Add(this.groupBoxFILTER);
            this.Name = "ReportsForm";
            this.Text = "ReportsForm";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.ReportsForm_FormClosed);
            this.groupBoxFILTER.ResumeLayout(false);
            this.groupBoxFILTER.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewORDER)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBoxFILTER;
        private System.Windows.Forms.Button CreateReport;
        private System.Windows.Forms.DateTimePicker dateTimePickerEnd;
        private System.Windows.Forms.DateTimePicker dateTimePickerStart;
        private System.Windows.Forms.Label EndPeriod;
        private System.Windows.Forms.Label StartPeriod;
        private System.ComponentModel.BackgroundWorker backgroundWorker1;
        private System.Windows.Forms.DataGridView dataGridViewORDER;
        private System.Windows.Forms.Label CountOrderText;
        private System.Windows.Forms.Label SummText;
        private System.Windows.Forms.Label Summ;
        private System.Windows.Forms.Button SavePDF;
        private System.Windows.Forms.Button CloseOrders;
        private System.Windows.Forms.Label orderCount;
    }
}