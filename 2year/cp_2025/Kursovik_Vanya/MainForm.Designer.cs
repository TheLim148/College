namespace Kursovik
{
    partial class MainForm
    {
        /// <summary>
        /// Обязательная переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Требуемый метод для поддержки конструктора — не изменяйте 
        /// содержимое этого метода с помощью редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.Reports = new System.Windows.Forms.Button();
            this.Orders = new System.Windows.Forms.Button();
            this.Clients = new System.Windows.Forms.Button();
            this.Service = new System.Windows.Forms.Button();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label1.Location = new System.Drawing.Point(178, 27);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(147, 25);
            this.label1.TabIndex = 0;
            this.label1.Text = "ФОТОЦЕНТР";
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.Reports);
            this.panel1.Controls.Add(this.Orders);
            this.panel1.Controls.Add(this.Clients);
            this.panel1.Controls.Add(this.Service);
            this.panel1.Location = new System.Drawing.Point(98, 95);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(300, 250);
            this.panel1.TabIndex = 1;
            // 
            // Reports
            // 
            this.Reports.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Reports.Location = new System.Drawing.Point(25, 185);
            this.Reports.Name = "Reports";
            this.Reports.Size = new System.Drawing.Size(250, 40);
            this.Reports.TabIndex = 3;
            this.Reports.Text = "Отчёты";
            this.Reports.UseVisualStyleBackColor = true;
            this.Reports.Click += new System.EventHandler(this.Reports_Click);
            // 
            // Orders
            // 
            this.Orders.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Orders.Location = new System.Drawing.Point(25, 130);
            this.Orders.Name = "Orders";
            this.Orders.Size = new System.Drawing.Size(250, 40);
            this.Orders.TabIndex = 2;
            this.Orders.Text = "Заказы";
            this.Orders.UseVisualStyleBackColor = true;
            this.Orders.Click += new System.EventHandler(this.Orders_Click);
            // 
            // Clients
            // 
            this.Clients.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Clients.Location = new System.Drawing.Point(25, 20);
            this.Clients.Name = "Clients";
            this.Clients.Size = new System.Drawing.Size(250, 40);
            this.Clients.TabIndex = 0;
            this.Clients.Text = "Клиенты";
            this.Clients.UseVisualStyleBackColor = true;
            this.Clients.Click += new System.EventHandler(this.Clients_Click);
            // 
            // Service
            // 
            this.Service.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Service.Location = new System.Drawing.Point(25, 75);
            this.Service.Name = "Service";
            this.Service.Size = new System.Drawing.Size(250, 40);
            this.Service.TabIndex = 1;
            this.Service.Text = "Услуги";
            this.Service.UseVisualStyleBackColor = true;
            this.Service.Click += new System.EventHandler(this.Service_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(504, 405);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.label1);
            this.Name = "MainForm";
            this.Text = "Main Window";
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.panel1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button Reports;
        private System.Windows.Forms.Button Orders;
        private System.Windows.Forms.Button Clients;
        private System.Windows.Forms.Button Service;
    }
}

