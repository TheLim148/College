using MySqlConnector;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace Kursovik
{
    public partial class OrdersForm : Form
    {
        public String ConString = "server=172.20.7.45; port=3306; user=st4996_23; password=pwd4996_23; database=db_4996_23_prog;";
        public OrdersForm()
        {
            InitializeComponent();
        }

        private void OrdersForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            Global.isActiveOrders = true;
        }

        private void OrdersForm_Load(object sender, EventArgs e)
        {
            ClientLoad();
            ServiceLoad();
            OrdersLoad();
            comboBoxStatus.Items.AddRange(new string[] { "В обработке", "Выполнен", "Отменён" });
        }

        private void ClientLoad()
        {
            MySqlConnection connect = new MySqlConnection(ConString);
            connect.Open();

            string query = "SELECT ClientID, FullName FROM Clients";
            MySqlDataAdapter adapter = new MySqlDataAdapter(query, connect);
            DataTable dt = new DataTable();
            adapter.Fill(dt);
            comboBoxClient.DataSource = dt;
            comboBoxClient.DisplayMember = "FullName";
            comboBoxClient.ValueMember = "ClientID";
            connect.Close();
        }

        private void ServiceLoad()
        {
            MySqlConnection connect = new MySqlConnection(ConString);
            connect.Open();
            string query = "SELECT ServiceID, ServiceName FROM Services";
            MySqlDataAdapter adapter = new MySqlDataAdapter(query, connect);
            DataTable dt = new DataTable();
            adapter.Fill(dt);
            comboBoxService.DataSource = dt;
            comboBoxService.DisplayMember = "ServiceName";
            comboBoxService.ValueMember = "ServiceID";
            connect.Close();
        }

        private void OrdersLoad()
        {
            MySqlConnection connect = new MySqlConnection(ConString);
            connect.Open();
            string query = @"SELECT Orders.OrderID, Clients.ClientID AS ClientID, Services.ServiceID AS ServiceID,
                        Orders.OrderDate, Orders.CompletionDate, Orders.Status
                        FROM Orders
                        JOIN Clients ON Orders.ClientID = Clients.ClientID
                        JOIN Services ON Orders.ServiceID = Services.ServiceID";
            MySqlDataAdapter adapter = new MySqlDataAdapter(query, connect);
            DataTable dt = new DataTable();
            adapter.Fill(dt);
            dataGridViewOrders.DataSource = dt;
            connect.Close();
        }

        private void AddOrder_Click(object sender, EventArgs e)
        {
            try
            {
                MySqlConnection connect = new MySqlConnection(ConString);
                connect.Open();


                string query = @"INSERT INTO Orders (ClientID, ServiceID, OrderDate, CompletionDate, Status)
                         VALUES (@clientId, @serviceId, @orderDate, @completionDate, @status)";
                MySqlCommand cmd = new MySqlCommand(query, connect);
                cmd.Parameters.AddWithValue("@clientId", comboBoxClient.SelectedValue);
                cmd.Parameters.AddWithValue("@serviceId", comboBoxService.SelectedValue);
                cmd.Parameters.AddWithValue("@orderDate", dateTimePickerOrder.Value);
                cmd.Parameters.AddWithValue("@completionDate", dateTimePickerComplete.Value);
                cmd.Parameters.AddWithValue("@status", comboBoxStatus.Text);
                cmd.ExecuteNonQuery();
                MessageBox.Show("Заказ добавлен успешно!");
                connect.Close();
                OrdersLoad();

            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка при добавлении заказа: " + ex.Message);
            }
        }

        private void DellService_Click(object sender, EventArgs e)
        {
            try
            {
                if (dataGridViewOrders.SelectedRows.Count > 0)
                {
                    int ordersId = Convert.ToInt32(dataGridViewOrders.SelectedRows[0].Cells["OrderID"].Value);

                    DialogResult dialogResult = MessageBox.Show("Вы уверены, что хотите удалить ?", "Подтверждение", MessageBoxButtons.YesNo);
                    if (dialogResult == DialogResult.Yes)
                    {
                        MySqlConnection connect = new MySqlConnection(ConString);
                        connect.Open();

                        string query = "DELETE FROM Orders WHERE OrderID = @ordersId";
                        MySqlCommand cmd = new MySqlCommand(query, connect);
                        cmd.Parameters.AddWithValue("ordersId", ordersId);

                        cmd.ExecuteNonQuery();
                        MessageBox.Show("Заказ успешно удалён!");

                        connect.Close();

                        OrdersLoad();
                    }
                }
                else
                {
                    MessageBox.Show("Выберите заказ для удаления.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка при удалении заказа: " + ex.Message);
            }


        }

        private void dataGridViewOrders_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dataGridViewOrders.Rows[e.RowIndex];

                comboBoxClient.SelectedValue = row.Cells["ClientID"].Value;
                comboBoxService.SelectedValue = row.Cells["ServiceID"].Value;


                dateTimePickerOrder.Value = Convert.ToDateTime(row.Cells["OrderDate"].Value);
                dateTimePickerComplete.Value = Convert.ToDateTime(row.Cells["CompletionDate"].Value);


                comboBoxStatus.SelectedItem = row.Cells["Status"].Value.ToString();

                orderIdToEdit = Convert.ToInt32(row.Cells["OrderID"].Value);
            }
        }



        private int orderIdToEdit = -1;
        private void EditServiceClient_Click(object sender, EventArgs e)
        {
            if (orderIdToEdit == -1)
            {
                MessageBox.Show("Выберите заказ для изменения!");
                return;
            }

            int clientId;
            int serviceId;
            DateTime orderDate = dateTimePickerOrder.Value;
            DateTime completionDate = dateTimePickerComplete.Value;
            string status = comboBoxStatus.Text;

            // Проверка клиента
            if (comboBoxClient.SelectedValue == null || !int.TryParse(comboBoxClient.SelectedValue.ToString(), out clientId))
            {
                MessageBox.Show("Выберите клиента!");
                return;
            }

            // Проверка услуги
            if (comboBoxService.SelectedValue == null || !int.TryParse(comboBoxService.SelectedValue.ToString(), out serviceId))
            {
                MessageBox.Show("Выберите услугу!");
                return;
            }

            // Проверка статуса
            if (string.IsNullOrWhiteSpace(status))
            {
                MessageBox.Show("Укажите статус заказа!");
                return;
            }

            try
            {
                MySqlConnection connect = new MySqlConnection(ConString);
                connect.Open();

                string query = @"UPDATE Orders 
                         SET ClientID = @clientId, ServiceID = @serviceId, 
                             OrderDate = @orderDate, CompletionDate = @completionDate, 
                             Status = @status 
                         WHERE OrderID = @orderId";

                MySqlCommand cmd = new MySqlCommand(query, connect);
                cmd.Parameters.AddWithValue("@clientId", clientId);
                cmd.Parameters.AddWithValue("@serviceId", serviceId);
                cmd.Parameters.AddWithValue("@orderDate", orderDate);
                cmd.Parameters.AddWithValue("@completionDate", completionDate);
                cmd.Parameters.AddWithValue("@status", status);
                cmd.Parameters.AddWithValue("@orderId", orderIdToEdit);

                cmd.ExecuteNonQuery();
                MessageBox.Show("Заказ успешно изменён!");

                connect.Close();
                OrdersLoad();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при изменении заказа: {ex.Message}");
            }
        }
    }
}
