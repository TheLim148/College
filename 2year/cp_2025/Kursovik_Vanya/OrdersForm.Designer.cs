namespace Kursovik
{
    partial class OrdersForm
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
            this.PickClient = new System.Windows.Forms.Label();
            this.comboBoxClient = new System.Windows.Forms.ComboBox();
            this.PickService = new System.Windows.Forms.Label();
            this.DateService = new System.Windows.Forms.Label();
            this.DateComplete = new System.Windows.Forms.Label();
            this.Status = new System.Windows.Forms.Label();
            this.comboBoxService = new System.Windows.Forms.ComboBox();
            this.comboBoxStatus = new System.Windows.Forms.ComboBox();
            this.dateTimePickerOrder = new System.Windows.Forms.DateTimePicker();
            this.dateTimePickerComplete = new System.Windows.Forms.DateTimePicker();
            this.groupBoxINFO = new System.Windows.Forms.GroupBox();
            this.DellService = new System.Windows.Forms.Button();
            this.EditServiceClient = new System.Windows.Forms.Button();
            this.AddOrder = new System.Windows.Forms.Button();
            this.dataGridViewOrders = new System.Windows.Forms.DataGridView();
            this.groupBoxINFO.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewOrders)).BeginInit();
            this.SuspendLayout();
            // 
            // PickClient
            // 
            this.PickClient.AutoSize = true;
            this.PickClient.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.PickClient.Location = new System.Drawing.Point(18, 24);
            this.PickClient.Name = "PickClient";
            this.PickClient.Size = new System.Drawing.Size(129, 16);
            this.PickClient.TabIndex = 0;
            this.PickClient.Text = "Выберите клиента";
            // 
            // comboBoxClient
            // 
            this.comboBoxClient.FormattingEnabled = true;
            this.comboBoxClient.Location = new System.Drawing.Point(173, 19);
            this.comboBoxClient.Name = "comboBoxClient";
            this.comboBoxClient.Size = new System.Drawing.Size(248, 21);
            this.comboBoxClient.TabIndex = 1;
            // 
            // PickService
            // 
            this.PickService.AutoSize = true;
            this.PickService.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.PickService.Location = new System.Drawing.Point(6, 11);
            this.PickService.Name = "PickService";
            this.PickService.Size = new System.Drawing.Size(120, 16);
            this.PickService.TabIndex = 0;
            this.PickService.Text = "Выберите услугу";
            // 
            // DateService
            // 
            this.DateService.AutoSize = true;
            this.DateService.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.DateService.Location = new System.Drawing.Point(6, 57);
            this.DateService.Name = "DateService";
            this.DateService.Size = new System.Drawing.Size(89, 16);
            this.DateService.TabIndex = 1;
            this.DateService.Text = "Дата заказа";
            // 
            // DateComplete
            // 
            this.DateComplete.AutoSize = true;
            this.DateComplete.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.DateComplete.Location = new System.Drawing.Point(6, 103);
            this.DateComplete.Name = "DateComplete";
            this.DateComplete.Size = new System.Drawing.Size(114, 16);
            this.DateComplete.TabIndex = 2;
            this.DateComplete.Text = "Для выполнения";
            // 
            // Status
            // 
            this.Status.AutoSize = true;
            this.Status.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Status.Location = new System.Drawing.Point(6, 149);
            this.Status.Name = "Status";
            this.Status.Size = new System.Drawing.Size(53, 16);
            this.Status.TabIndex = 3;
            this.Status.Text = "Статус";
            // 
            // comboBoxService
            // 
            this.comboBoxService.FormattingEnabled = true;
            this.comboBoxService.Location = new System.Drawing.Point(153, 11);
            this.comboBoxService.Name = "comboBoxService";
            this.comboBoxService.Size = new System.Drawing.Size(247, 21);
            this.comboBoxService.TabIndex = 4;
            // 
            // comboBoxStatus
            // 
            this.comboBoxStatus.FormattingEnabled = true;
            this.comboBoxStatus.Location = new System.Drawing.Point(152, 149);
            this.comboBoxStatus.Name = "comboBoxStatus";
            this.comboBoxStatus.Size = new System.Drawing.Size(247, 21);
            this.comboBoxStatus.TabIndex = 5;
            // 
            // dateTimePickerOrder
            // 
            this.dateTimePickerOrder.Location = new System.Drawing.Point(152, 53);
            this.dateTimePickerOrder.Name = "dateTimePickerOrder";
            this.dateTimePickerOrder.Size = new System.Drawing.Size(247, 20);
            this.dateTimePickerOrder.TabIndex = 6;
            // 
            // dateTimePickerComplete
            // 
            this.dateTimePickerComplete.Location = new System.Drawing.Point(152, 103);
            this.dateTimePickerComplete.Name = "dateTimePickerComplete";
            this.dateTimePickerComplete.Size = new System.Drawing.Size(247, 20);
            this.dateTimePickerComplete.TabIndex = 7;
            // 
            // groupBoxINFO
            // 
            this.groupBoxINFO.Controls.Add(this.dateTimePickerComplete);
            this.groupBoxINFO.Controls.Add(this.dateTimePickerOrder);
            this.groupBoxINFO.Controls.Add(this.comboBoxStatus);
            this.groupBoxINFO.Controls.Add(this.comboBoxService);
            this.groupBoxINFO.Controls.Add(this.Status);
            this.groupBoxINFO.Controls.Add(this.DateComplete);
            this.groupBoxINFO.Controls.Add(this.DateService);
            this.groupBoxINFO.Controls.Add(this.PickService);
            this.groupBoxINFO.Location = new System.Drawing.Point(21, 69);
            this.groupBoxINFO.Name = "groupBoxINFO";
            this.groupBoxINFO.Size = new System.Drawing.Size(411, 198);
            this.groupBoxINFO.TabIndex = 2;
            this.groupBoxINFO.TabStop = false;
            // 
            // DellService
            // 
            this.DellService.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.DellService.Location = new System.Drawing.Point(310, 284);
            this.DellService.Name = "DellService";
            this.DellService.Size = new System.Drawing.Size(122, 30);
            this.DellService.TabIndex = 3;
            this.DellService.Text = "Удалить заказ";
            this.DellService.UseVisualStyleBackColor = true;
            this.DellService.Click += new System.EventHandler(this.DellService_Click);
            // 
            // EditServiceClient
            // 
            this.EditServiceClient.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.EditServiceClient.Location = new System.Drawing.Point(163, 284);
            this.EditServiceClient.Name = "EditServiceClient";
            this.EditServiceClient.Size = new System.Drawing.Size(122, 30);
            this.EditServiceClient.TabIndex = 4;
            this.EditServiceClient.Text = "Изменить заказ";
            this.EditServiceClient.UseVisualStyleBackColor = true;
            this.EditServiceClient.Click += new System.EventHandler(this.EditServiceClient_Click);
            // 
            // AddOrder
            // 
            this.AddOrder.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.AddOrder.Location = new System.Drawing.Point(16, 284);
            this.AddOrder.Name = "AddOrder";
            this.AddOrder.Size = new System.Drawing.Size(122, 30);
            this.AddOrder.TabIndex = 5;
            this.AddOrder.Text = "Добавить заказ";
            this.AddOrder.UseVisualStyleBackColor = true;
            this.AddOrder.Click += new System.EventHandler(this.AddOrder_Click);
            // 
            // dataGridViewOrders
            // 
            this.dataGridViewOrders.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewOrders.Location = new System.Drawing.Point(19, 338);
            this.dataGridViewOrders.Name = "dataGridViewOrders";
            this.dataGridViewOrders.Size = new System.Drawing.Size(412, 144);
            this.dataGridViewOrders.TabIndex = 6;
            this.dataGridViewOrders.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridViewOrders_CellClick);
            // OrdersForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(455, 511);
            this.Controls.Add(this.dataGridViewOrders);
            this.Controls.Add(this.AddOrder);
            this.Controls.Add(this.EditServiceClient);
            this.Controls.Add(this.DellService);
            this.Controls.Add(this.groupBoxINFO);
            this.Controls.Add(this.comboBoxClient);
            this.Controls.Add(this.PickClient);
            this.Name = "OrdersForm";
            this.Text = "OrdersForm";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.OrdersForm_FormClosed);
            this.Load += new System.EventHandler(this.OrdersForm_Load);
            this.groupBoxINFO.ResumeLayout(false);
            this.groupBoxINFO.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewOrders)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label PickClient;
        private System.Windows.Forms.ComboBox comboBoxClient;
        private System.Windows.Forms.Label PickService;
        private System.Windows.Forms.Label DateService;
        private System.Windows.Forms.Label DateComplete;
        private System.Windows.Forms.Label Status;
        private System.Windows.Forms.ComboBox comboBoxService;
        private System.Windows.Forms.ComboBox comboBoxStatus;
        private System.Windows.Forms.DateTimePicker dateTimePickerOrder;
        private System.Windows.Forms.DateTimePicker dateTimePickerComplete;
        private System.Windows.Forms.GroupBox groupBoxINFO;
        private System.Windows.Forms.Button DellService;
        private System.Windows.Forms.Button EditServiceClient;
        private System.Windows.Forms.Button AddOrder;
        private System.Windows.Forms.DataGridView dataGridViewOrders;
    }
}