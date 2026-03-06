namespace Kursovik
{
    partial class ClientsForm
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
            this.dataGridViewClients = new System.Windows.Forms.DataGridView();
            this.ClientInfo = new System.Windows.Forms.GroupBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.checkBoxRegular = new System.Windows.Forms.CheckBox();
            this.textBoxPhone = new System.Windows.Forms.TextBox();
            this.textBoxEmail = new System.Windows.Forms.TextBox();
            this.textBoxName = new System.Windows.Forms.TextBox();
            this.groupBoxButton = new System.Windows.Forms.GroupBox();
            this.searchClient = new System.Windows.Forms.Button();
            this.deleteClient = new System.Windows.Forms.Button();
            this.editClient = new System.Windows.Forms.Button();
            this.addClient = new System.Windows.Forms.Button();
            this.Search1 = new System.Windows.Forms.TextBox();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewClients)).BeginInit();
            this.ClientInfo.SuspendLayout();
            this.groupBoxButton.SuspendLayout();
            this.SuspendLayout();
            // 
            // dataGridViewClients
            // 
            this.dataGridViewClients.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.dataGridViewClients.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dataGridViewClients.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewClients.Location = new System.Drawing.Point(19, 355);
            this.dataGridViewClients.Name = "dataGridViewClients";
            this.dataGridViewClients.Size = new System.Drawing.Size(363, 167);
            this.dataGridViewClients.TabIndex = 0;
            this.dataGridViewClients.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridViewClients_CellClick);
            // 
            // ClientInfo
            // 
            this.ClientInfo.Controls.Add(this.label3);
            this.ClientInfo.Controls.Add(this.label2);
            this.ClientInfo.Controls.Add(this.label1);
            this.ClientInfo.Controls.Add(this.checkBoxRegular);
            this.ClientInfo.Controls.Add(this.textBoxPhone);
            this.ClientInfo.Controls.Add(this.textBoxEmail);
            this.ClientInfo.Controls.Add(this.textBoxName);
            this.ClientInfo.Location = new System.Drawing.Point(19, 12);
            this.ClientInfo.Name = "ClientInfo";
            this.ClientInfo.Size = new System.Drawing.Size(363, 183);
            this.ClientInfo.TabIndex = 1;
            this.ClientInfo.TabStop = false;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label3.Location = new System.Drawing.Point(49, 113);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(41, 16);
            this.label3.TabIndex = 6;
            this.label3.Text = "Email";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label2.Location = new System.Drawing.Point(23, 66);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(67, 16);
            this.label2.TabIndex = 5;
            this.label2.Text = "Телефон";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F);
            this.label1.Location = new System.Drawing.Point(56, 28);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(34, 13);
            this.label1.TabIndex = 4;
            this.label1.Text = "ФИО";
            // 
            // checkBoxRegular
            // 
            this.checkBoxRegular.AutoSize = true;
            this.checkBoxRegular.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.checkBoxRegular.Location = new System.Drawing.Point(143, 146);
            this.checkBoxRegular.Name = "checkBoxRegular";
            this.checkBoxRegular.RightToLeft = System.Windows.Forms.RightToLeft.Yes;
            this.checkBoxRegular.Size = new System.Drawing.Size(153, 20);
            this.checkBoxRegular.TabIndex = 3;
            this.checkBoxRegular.Text = "постоянный клиент";
            this.checkBoxRegular.UseVisualStyleBackColor = true;
            // 
            // textBoxPhone
            // 
            this.textBoxPhone.Location = new System.Drawing.Point(96, 66);
            this.textBoxPhone.Name = "textBoxPhone";
            this.textBoxPhone.Size = new System.Drawing.Size(200, 20);
            this.textBoxPhone.TabIndex = 2;
            // 
            // textBoxEmail
            // 
            this.textBoxEmail.Location = new System.Drawing.Point(96, 109);
            this.textBoxEmail.Name = "textBoxEmail";
            this.textBoxEmail.Size = new System.Drawing.Size(200, 20);
            this.textBoxEmail.TabIndex = 1;
            // 
            // textBoxName
            // 
            this.textBoxName.Location = new System.Drawing.Point(96, 25);
            this.textBoxName.Name = "textBoxName";
            this.textBoxName.Size = new System.Drawing.Size(200, 20);
            this.textBoxName.TabIndex = 0;
            // 
            // groupBoxButton
            // 
            this.groupBoxButton.Controls.Add(this.searchClient);
            this.groupBoxButton.Controls.Add(this.deleteClient);
            this.groupBoxButton.Controls.Add(this.editClient);
            this.groupBoxButton.Controls.Add(this.addClient);
            this.groupBoxButton.Location = new System.Drawing.Point(19, 201);
            this.groupBoxButton.Name = "groupBoxButton";
            this.groupBoxButton.Size = new System.Drawing.Size(363, 117);
            this.groupBoxButton.TabIndex = 2;
            this.groupBoxButton.TabStop = false;
            // 
            // searchClient
            // 
            this.searchClient.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.searchClient.Location = new System.Drawing.Point(199, 63);
            this.searchClient.Name = "searchClient";
            this.searchClient.Size = new System.Drawing.Size(132, 30);
            this.searchClient.TabIndex = 3;
            this.searchClient.Text = "Поиск";
            this.searchClient.UseVisualStyleBackColor = true;
            this.searchClient.Click += new System.EventHandler(this.searchClient_Click);
            // 
            // deleteClient
            // 
            this.deleteClient.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.deleteClient.Location = new System.Drawing.Point(25, 63);
            this.deleteClient.Name = "deleteClient";
            this.deleteClient.Size = new System.Drawing.Size(132, 30);
            this.deleteClient.TabIndex = 2;
            this.deleteClient.Text = "Удалить";
            this.deleteClient.UseVisualStyleBackColor = false;
            this.deleteClient.Click += new System.EventHandler(this.deleteClient_Click);
            // 
            // editClient
            // 
            this.editClient.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.editClient.Location = new System.Drawing.Point(199, 19);
            this.editClient.Name = "editClient";
            this.editClient.Size = new System.Drawing.Size(132, 30);
            this.editClient.TabIndex = 1;
            this.editClient.Text = "Редактировать";
            this.editClient.UseVisualStyleBackColor = true;
            this.editClient.Click += new System.EventHandler(this.editClient_Click);
            // 
            // addClient
            // 
            this.addClient.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.addClient.Location = new System.Drawing.Point(25, 19);
            this.addClient.Name = "addClient";
            this.addClient.Size = new System.Drawing.Size(132, 30);
            this.addClient.TabIndex = 0;
            this.addClient.Text = "Добавить";
            this.addClient.UseVisualStyleBackColor = true;
            this.addClient.Click += new System.EventHandler(this.addClient_Click);
            // 
            // Search1
            // 
            this.Search1.Location = new System.Drawing.Point(19, 324);
            this.Search1.Name = "Search1";
            this.Search1.Size = new System.Drawing.Size(363, 20);
            this.Search1.TabIndex = 3;
            // 
            // ClientsForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(399, 534);
            this.Controls.Add(this.Search1);
            this.Controls.Add(this.groupBoxButton);
            this.Controls.Add(this.ClientInfo);
            this.Controls.Add(this.dataGridViewClients);
            this.Name = "ClientsForm";
            this.Text = "ClientsForm";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.ClientsForm_FormClosed);
            this.Load += new System.EventHandler(this.ClientsForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewClients)).EndInit();
            this.ClientInfo.ResumeLayout(false);
            this.ClientInfo.PerformLayout();
            this.groupBoxButton.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dataGridViewClients;
        private System.Windows.Forms.GroupBox ClientInfo;
        private System.Windows.Forms.GroupBox groupBoxButton;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.CheckBox checkBoxRegular;
        private System.Windows.Forms.TextBox textBoxPhone;
        private System.Windows.Forms.TextBox textBoxEmail;
        private System.Windows.Forms.TextBox textBoxName;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button searchClient;
        private System.Windows.Forms.Button deleteClient;
        private System.Windows.Forms.Button editClient;
        private System.Windows.Forms.Button addClient;
        private System.Windows.Forms.TextBox Search1;
    }
}