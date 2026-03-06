namespace Kursovik
{
    partial class ServiceForm
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
            this.NameService = new System.Windows.Forms.Label();
            this.Description = new System.Windows.Forms.Label();
            this.Price = new System.Windows.Forms.Label();
            this.textBoxName = new System.Windows.Forms.TextBox();
            this.textBoxDesc = new System.Windows.Forms.TextBox();
            this.textBoxPrice = new System.Windows.Forms.TextBox();
            this.AddService = new System.Windows.Forms.Button();
            this.DeleteService = new System.Windows.Forms.Button();
            this.EditService = new System.Windows.Forms.Button();
            this.dataGridViewService = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewService)).BeginInit();
            this.SuspendLayout();
            // 
            // NameService
            // 
            this.NameService.AutoSize = true;
            this.NameService.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.NameService.Location = new System.Drawing.Point(21, 21);
            this.NameService.Name = "NameService";
            this.NameService.Size = new System.Drawing.Size(121, 16);
            this.NameService.TabIndex = 0;
            this.NameService.Text = "Название услуги";
            // 
            // Description
            // 
            this.Description.AutoSize = true;
            this.Description.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Description.Location = new System.Drawing.Point(21, 62);
            this.Description.Name = "Description";
            this.Description.Size = new System.Drawing.Size(72, 16);
            this.Description.TabIndex = 1;
            this.Description.Text = "Описание";
            // 
            // Price
            // 
            this.Price.AutoSize = true;
            this.Price.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Price.Location = new System.Drawing.Point(21, 105);
            this.Price.Name = "Price";
            this.Price.Size = new System.Drawing.Size(40, 16);
            this.Price.TabIndex = 2;
            this.Price.Text = "Цена";
            // 
            // textBoxName
            // 
            this.textBoxName.Location = new System.Drawing.Point(164, 21);
            this.textBoxName.Name = "textBoxName";
            this.textBoxName.Size = new System.Drawing.Size(213, 20);
            this.textBoxName.TabIndex = 3;
            // 
            // textBoxDesc
            // 
            this.textBoxDesc.Location = new System.Drawing.Point(164, 62);
            this.textBoxDesc.Name = "textBoxDesc";
            this.textBoxDesc.Size = new System.Drawing.Size(213, 20);
            this.textBoxDesc.TabIndex = 4;
            // 
            // textBoxPrice
            // 
            this.textBoxPrice.Location = new System.Drawing.Point(164, 101);
            this.textBoxPrice.Name = "textBoxPrice";
            this.textBoxPrice.Size = new System.Drawing.Size(214, 20);
            this.textBoxPrice.TabIndex = 5;
            // 
            // AddService
            // 
            this.AddService.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.AddService.Location = new System.Drawing.Point(24, 148);
            this.AddService.Name = "AddService";
            this.AddService.Size = new System.Drawing.Size(112, 21);
            this.AddService.TabIndex = 6;
            this.AddService.Text = "Добавить";
            this.AddService.UseVisualStyleBackColor = true;
            this.AddService.Click += new System.EventHandler(this.AddService_Click);
            // 
            // DeleteService
            // 
            this.DeleteService.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.DeleteService.Location = new System.Drawing.Point(145, 148);
            this.DeleteService.Name = "DeleteService";
            this.DeleteService.Size = new System.Drawing.Size(112, 21);
            this.DeleteService.TabIndex = 7;
            this.DeleteService.Text = "Удалить";
            this.DeleteService.UseVisualStyleBackColor = true;
            this.DeleteService.Click += new System.EventHandler(this.DeleteService_Click);
            // 
            // EditService
            // 
            this.EditService.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.EditService.Location = new System.Drawing.Point(266, 148);
            this.EditService.Name = "EditService";
            this.EditService.Size = new System.Drawing.Size(112, 21);
            this.EditService.TabIndex = 8;
            this.EditService.Text = "Изменить";
            this.EditService.UseVisualStyleBackColor = true;
            this.EditService.Click += new System.EventHandler(this.EditService_Click);
            // 
            // dataGridViewService
            // 
            this.dataGridViewService.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewService.Location = new System.Drawing.Point(24, 195);
            this.dataGridViewService.Name = "dataGridViewService";
            this.dataGridViewService.Size = new System.Drawing.Size(354, 174);
            this.dataGridViewService.TabIndex = 9;
            this.dataGridViewService.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridViewService_CellClick);
            // 
            // ServiceForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(397, 400);
            this.Controls.Add(this.dataGridViewService);
            this.Controls.Add(this.EditService);
            this.Controls.Add(this.DeleteService);
            this.Controls.Add(this.AddService);
            this.Controls.Add(this.textBoxPrice);
            this.Controls.Add(this.textBoxDesc);
            this.Controls.Add(this.textBoxName);
            this.Controls.Add(this.Price);
            this.Controls.Add(this.Description);
            this.Controls.Add(this.NameService);
            this.Name = "ServiceForm";
            this.Text = "ServiceForm";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.ServiceForm_FormClosed);
            this.Load += new System.EventHandler(this.ServiceForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewService)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label NameService;
        private System.Windows.Forms.Label Description;
        private System.Windows.Forms.Label Price;
        private System.Windows.Forms.TextBox textBoxName;
        private System.Windows.Forms.TextBox textBoxDesc;
        private System.Windows.Forms.TextBox textBoxPrice;
        private System.Windows.Forms.Button AddService;
        private System.Windows.Forms.Button DeleteService;
        private System.Windows.Forms.Button EditService;
        private System.Windows.Forms.DataGridView dataGridViewService;
    }
}