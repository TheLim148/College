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

namespace Kursovik
{
    public partial class ReportsForm : Form
    {
        public String ConString = "server=172.20.7.45; port=3306; user=st4996_23; password=pwd4996_23; database=db_4996_23_prog;";
        public ReportsForm()
        {
            InitializeComponent();
        }

        private void ReportsForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            Global.isActiveReports = true;
        }

        private void CreateReport_Click(object sender, EventArgs e)
        {
            DateTime startDate = dateTimePickerStart.Value.Date;
            DateTime endDate = dateTimePickerEnd.Value.Date;

            MySqlConnection connect = new MySqlConnection(ConString);
            connect.Open();

            string query = @"
            SELECT Orders.OrderID, Clients.FullName AS Client, Services.ServiceName AS Service, 
                   Orders.OrderDate, Orders.CompletionDate, Orders.Status, Services.Price
            FROM Orders
            JOIN Clients ON Orders.ClientID = Clients.ClientID
            JOIN Services ON Orders.ServiceID = Services.ServiceID
            WHERE Orders.OrderDate BETWEEN @startDate AND @endDate";

            MySqlCommand cmd = new MySqlCommand(query, connect);
            cmd.Parameters.AddWithValue("@startDate", startDate);
            cmd.Parameters.AddWithValue("@endDate", endDate);

            MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);
            dataGridViewORDER.DataSource = dt;

            orderCount.Text = $"{dt.Rows.Count}";
            
            decimal totalProfit = 0;
            foreach (DataRow row in dt.Rows)
            {
                totalProfit += Convert.ToDecimal(row["Price"]);
            }
            Summ.Text = $"{totalProfit}";
        }

        private void CloseOrders_Click(object sender, EventArgs e)
        {
            Close();
        }
    }
}
