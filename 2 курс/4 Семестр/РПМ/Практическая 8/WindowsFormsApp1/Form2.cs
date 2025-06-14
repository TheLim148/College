using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using WindowsFormsApp1.EmployeeDataSetTableAdapters;

namespace WindowsFormsApp1
{
    public partial class Form2 : Form
    {
        public string S;
        public Form2(string data)
        {
            InitializeComponent();
            S = data;
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void Form2_Load(object sender, EventArgs e)
        {
            this.сотрудникиTableAdapter.Fill(this.employeeDataSet.Сотрудники);
            this.должностьTableAdapter.Fill(this.employeeDataSet.Должность);

            if (S == "Должность")
            {
                dataGridView1.DataSource = должностьBindingSource;
            }

            else if (S == "Сотрудники")
            {
                dataGridView1.DataSource = сотрудникиBindingSource;
            }
        }

        private void Form2_FormClosing(object sender, FormClosingEventArgs e)
        {
            должностьTableAdapter.Adapter.Update(employeeDataSet.Должность);
            сотрудникиTableAdapter.Adapter.Update(employeeDataSet.Сотрудники);
        }
    }
}
