using System;
using System.Windows.Forms;

namespace EventNotificationSystem
{
    partial class MainForm
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
            this.components = new System.ComponentModel.Container(); // Для ErrorProvider
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            this.dgvEvents = new System.Windows.Forms.DataGridView();
            this.labelEventName = new System.Windows.Forms.Label();
            this.txtEventName = new System.Windows.Forms.TextBox();
            this.labelDescription = new System.Windows.Forms.Label();
            this.txtDescription = new System.Windows.Forms.TextBox();
            this.labelEventDateTime = new System.Windows.Forms.Label();
            this.dtpEventDateTime = new System.Windows.Forms.DateTimePicker();
            // this.labelDuration = new System.Windows.Forms.Label(); // Если есть длительность
            // this.txtDuration = new System.Windows.Forms.TextBox(); // Если есть длительность
            this.btnAdd = new System.Windows.Forms.Button();
            this.btnEdit = new System.Windows.Forms.Button();
            this.btnDelete = new System.Windows.Forms.Button();
            this.btnSave = new System.Windows.Forms.Button();
            // this.btnCancel = new System.Windows.Forms.Button(); // Если есть кнопка Отмена
            this.errorProvider1 = new System.Windows.Forms.ErrorProvider(this.components);

            // --- Настройка формы ---
            this.SuspendLayout();

            // 
            // dgvEvents
            // 
            this.dgvEvents.AllowUserToAddRows = false; // Запрещаем добавление строк через UI
            this.dgvEvents.AllowUserToDeleteRows = false; // Запрещаем удаление строк через UI
            this.dgvEvents.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvEvents.DefaultCellStyle = dataGridViewCellStyle1;
            this.dgvEvents.Location = new System.Drawing.Point(12, 12); // Примерное положение
            this.dgvEvents.MultiSelect = false; // Разрешаем выбирать только одну строку
            this.dgvEvents.Name = "dgvEvents";
            this.dgvEvents.ReadOnly = true; // Делаем только для чтения, чтобы избежать случайных изменений
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            dataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvEvents.RowHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvEvents.RowHeadersVisible = false; // Скрываем номера строк
            this.dgvEvents.RowTemplate.Height = 24;
            this.dgvEvents.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect; // Выбирать всю строку
            this.dgvEvents.Size = new System.Drawing.Size(760, 300); // Примерный размер
            this.dgvEvents.TabIndex = 0;
            this.dgvEvents.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvEvents_CellClick); // Подписываемся на событие клика

            // 
            // labelEventName
            // 
            this.labelEventName.AutoSize = true;
            this.labelEventName.Location = new System.Drawing.Point(15, 330); // Примерное положение
            this.labelEventName.Name = "labelEventName";
            this.labelEventName.Size = new System.Drawing.Size(80, 16);
            this.labelEventName.TabIndex = 1;
            this.labelEventName.Text = "Название:";

            // 
            // txtEventName
            // 
            this.txtEventName.Enabled = false; // По умолчанию поля ввода отключены
            this.txtEventName.Location = new System.Drawing.Point(100, 327); // Примерное положение
            this.txtEventName.Name = "txtEventName";
            this.txtEventName.Size = new System.Drawing.Size(300, 22); // Примерный размер
            this.txtEventName.TabIndex = 2;

            // 
            // labelDescription
            // 
            this.labelDescription.AutoSize = true;
            this.labelDescription.Location = new System.Drawing.Point(15, 360); // Примерное положение
            this.labelDescription.Name = "labelDescription";
            this.labelDescription.Size = new System.Drawing.Size(70, 16);
            this.labelDescription.TabIndex = 3;
            this.labelDescription.Text = "Описание:";

            // 
            // txtDescription
            // 
            this.txtDescription.Enabled = false;
            this.txtDescription.Location = new System.Drawing.Point(100, 357); // Примерное положение
            this.txtDescription.Multiline = true; // Позволяет многострочный ввод
            this.txtDescription.Name = "txtDescription";
            this.txtDescription.Size = new System.Drawing.Size(300, 60); // Примерный размер
            this.txtDescription.TabIndex = 4;

            // 
            // labelEventDateTime
            // 
            this.labelEventDateTime.AutoSize = true;
            this.labelEventDateTime.Location = new System.Drawing.Point(15, 430); // Примерное положение
            this.labelEventDateTime.Name = "labelEventDateTime";
            this.labelEventDateTime.Size = new System.Drawing.Size(75, 16);
            this.labelEventDateTime.TabIndex = 5;
            this.labelEventDateTime.Text = "Дата и время:";

            // 
            // dtpEventDateTime
            // 
            this.dtpEventDateTime.Enabled = false;
            this.dtpEventDateTime.Format = System.Windows.Forms.DateTimePickerFormat.Time; // Устанавливаем формат дата и время
            this.dtpEventDateTime.Location = new System.Drawing.Point(100, 427); // Примерное положение
            this.dtpEventDateTime.Name = "dtpEventDateTime";
            this.dtpEventDateTime.Size = new System.Drawing.Size(200, 22); // Примерный размер
            this.dtpEventDateTime.TabIndex = 6;

            // 
            // btnAdd
            // 
            this.btnAdd.Location = new System.Drawing.Point(420, 327); // Примерное положение
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(100, 30); // Примерный размер
            this.btnAdd.TabIndex = 7;
            this.btnAdd.Text = "Добавить";
            this.btnAdd.UseVisualStyleBackColor = true;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click); // Привязываем обработчик события

            // 
            // btnEdit
            // 
            this.btnEdit.Enabled = false; // По умолчанию отключена
            this.btnEdit.Location = new System.Drawing.Point(420, 370); // Примерное положение
            this.btnEdit.Name = "btnEdit";
            this.btnEdit.Size = new System.Drawing.Size(100, 30); // Примерный размер
            this.btnEdit.TabIndex = 8;
            this.btnEdit.Text = "Изменить";
            this.btnEdit.UseVisualStyleBackColor = true;
            this.btnEdit.Click += new System.EventHandler(this.btnEdit_Click);

            // 
            // btnDelete
            // 
            this.btnDelete.Enabled = false; // По умолчанию отключена
            this.btnDelete.Location = new System.Drawing.Point(420, 413); // Примерное положение
            this.btnDelete.Name = "btnDelete";
            this.btnDelete.Size = new System.Drawing.Size(100, 30); // Примерный размер
            this.btnDelete.TabIndex = 9;
            this.btnDelete.Text = "Удалить";
            this.btnDelete.UseVisualStyleBackColor = true;
            this.btnDelete.Click += new System.EventHandler(this.btnDelete_Click);

            // 
            // btnSave
            // 
            this.btnSave.Enabled = false; // По умолчанию отключена
            this.btnSave.Location = new System.Drawing.Point(550, 327); // Примерное положение (рядом с полями ввода)
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(100, 30); // Примерный размер
            this.btnSave.TabIndex = 10;
            this.btnSave.Text = "Сохранить";
            this.btnSave.UseVisualStyleBackColor = true;
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);

            // 
            // errorProvider1
            // 
            this.errorProvider1.ContainerControl = this;

            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 600); // Размер окна
            this.Controls.Add(this.btnSave);
            // this.Controls.Add(this.btnCancel); // Если есть Отмена
            this.Controls.Add(this.btnDelete);
            this.Controls.Add(this.btnEdit);
            this.Controls.Add(this.btnAdd);
            this.Controls.Add(this.dtpEventDateTime);
            this.Controls.Add(this.labelEventDateTime);
            this.Controls.Add(this.txtDescription);
            this.Controls.Add(this.labelDescription);
            this.Controls.Add(this.txtEventName);
            this.Controls.Add(this.labelEventName);
            this.Controls.Add(this.dgvEvents);
            this.Name = "MainForm";
            this.Text = "Система уведомлений о событиях"; // Заголовок окна
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MainForm_FormClosing); // Подписываемся на событие закрытия формы
            ((System.ComponentModel.ISupportInitialize)(this.dgvEvents)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            throw new NotImplementedException();
        }

        #endregion

        private System.Windows.Forms.DataGridView dgvEvents;
        private System.Windows.Forms.Label labelEventName;
        private System.Windows.Forms.TextBox txtEventName;
        private System.Windows.Forms.Label labelDescription;
        private System.Windows.Forms.TextBox txtDescription;
        private System.Windows.Forms.Label labelEventDateTime;
        private System.Windows.Forms.DateTimePicker dtpEventDateTime;
        private System.Windows.Forms.Button btnAdd;
        private System.Windows.Forms.Button btnEdit;
        private System.Windows.Forms.Button btnDelete;
        private System.Windows.Forms.Button btnSave;
        private System.Windows.Forms.ErrorProvider errorProvider1;
    }
}