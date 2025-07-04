using MySqlConnector;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using IncomesAndExpenses;

namespace IncomesAndExpenses
{
    public partial class Form1 : Form
    {
        public String ConString = "server=172.20.7.12; port=3306; user=iz3992_23; password=pwd3992_23; database=um3992_23;";
        public Form1()
        {
            InitializeComponent();
        }

        private void dataGridViewIncomes_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            dataGridViewIncomes.Rows.Clear();
            dataGridViewExpenses.Rows.Clear();

            using (var conn = new MySqlConnection(ConString))
            {
                conn.Open();

                using (var cmd = new MySqlCommand("SELECT * FROM Transactions", conn))
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string type = reader.GetString("Type");
                        string category = reader.GetString("Category");
                        decimal amount = reader.GetDecimal("Amount");
                        DateTime date = reader.GetDateTime("Date");

                        if (type == "income")
                            dataGridViewIncomes.Rows.Add(date.ToShortDateString(), category, amount);
                        else if (type == "expense")
                            dataGridViewExpenses.Rows.Add(date.ToShortDateString(), category, amount);
                    }
                }
            }
        }

        private void buttonAddIncome_Click(object sender, EventArgs e)
        {
            AddTransaction("income");
        }

        private void buttonAddExpense_Click(object sender, EventArgs e)
        {
            AddTransaction("expense");
        }

        private void AddTransaction(string type)
        {
            string category = textBoxCategory.Text.Trim();
            string amountText = textBoxAmount.Text.Trim();
            DateTime date = dateTimePickerTransactionDate.Value.Date;

            if (string.IsNullOrWhiteSpace(category))
            {
                MessageBox.Show("Введите категорию.");
                return;
            }

            if (!decimal.TryParse(amountText, out decimal amount) || amount <= 0)
            {
                MessageBox.Show("Введите корректную сумму.");
                return;
            }

            using (var conn = new MySqlConnection(ConString))
            {
                conn.Open();
                string sql = "INSERT INTO Transactions (Type, Category, Amount, Date) VALUES (@type, @cat, @amt, @date)";
                using (var cmd = new MySqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@type", type);
                    cmd.Parameters.AddWithValue("@cat", category);
                    cmd.Parameters.AddWithValue("@amt", amount);
                    cmd.Parameters.AddWithValue("@date", date);
                    cmd.ExecuteNonQuery();
                }
            }

            if (type == "income")
                dataGridViewIncomes.Rows.Add(date.ToShortDateString(), category, amount);
            else if (type == "expense")
                dataGridViewExpenses.Rows.Add(date.ToShortDateString(), category, amount);

            textBoxCategory.Text = "";
            textBoxAmount.Text = "";
            dateTimePickerTransactionDate.Value = DateTime.Today;
        }

        private void buttonCalculate_Click(object sender, EventArgs e)
        {
            var incomes = new List<BudgetEntry>();
            var expenses = new List<BudgetEntry>();

            foreach (DataGridViewRow row in dataGridViewIncomes.Rows)
            {
                if (row.IsNewRow) continue;

                incomes.Add(new BudgetEntry
                {
                    Date = DateTime.Parse(row.Cells[0].Value.ToString()),
                    Amount = Convert.ToDecimal(row.Cells[2].Value)
                });
            }

            foreach (DataGridViewRow row in dataGridViewExpenses.Rows)
            {
                if (row.IsNewRow) continue;

                expenses.Add(new BudgetEntry
                {
                    Date = DateTime.Parse(row.Cells[0].Value.ToString()),
                    Amount = Convert.ToDecimal(row.Cells[2].Value)
                });
            }

            DateTime start = dateTimePickerStart.Value.Date;
            DateTime end = dateTimePickerEnd.Value.Date;

            decimal totalIncome = BudgetLogic.GetTotal(incomes, start, end);
            decimal totalExpense = BudgetLogic.GetTotal(expenses, start, end);
            decimal balance = totalIncome - totalExpense;

            labelResult.Text = $"Incomes: {totalIncome} ₽ | Expenses: {totalExpense} ₽ | Balance: {balance} ₽";
        }

        private void dataGridViewIncomes_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            
        }
    }
}
