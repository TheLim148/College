using MySqlConnector;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Kursovik
{
    public partial class ServiceForm : Form
    {
        public String ConString = "server=172.20.7.45; port=3306; user=st4996_23; password=pwd4996_23; database=db_4996_23_prog;";
        public ServiceForm()
        {
            InitializeComponent();
        }

        private void ServiceForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            Global.isActiveService = true;
        }

        private void ServiceForm_Load(object sender, EventArgs e)
        {
           loadService();
        }


        private void loadService()
        {
            try
            {
                MySqlConnection connect = new MySqlConnection(ConString);
                connect.Open();


                string query = "SELECT ServiceID, ServiceName, Description, Price FROM Services";
                MySqlCommand cmd = new MySqlCommand(query, connect);

                MySqlDataReader reader = cmd.ExecuteReader();

                DataTable dt = new DataTable();
                dt.Load(reader);

                dataGridViewService.DataSource = dt;

                connect.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка при загрузке данных: " + ex.Message);
            }
        }

        private void AddService_Click(object sender, EventArgs e)
        {
            MySqlConnection connect = null;
            try
            {
                string name = textBoxName.Text;
                string desc = textBoxDesc.Text;
                string prices = textBoxPrice.Text;


                if (string.IsNullOrEmpty(name))
                {
                    MessageBox.Show("Название услуги не должно отсутствовать!");
                    return;
                }

                if (string.IsNullOrEmpty(desc))
                {
                    MessageBox.Show("Описание обязательно для заполнения!");
                    return;
                }

                if (string.IsNullOrEmpty(prices))
                {
                    MessageBox.Show("Цена обязательна для заполнения!");
                    return;
                }
                
                decimal price;
                if (!decimal.TryParse(prices, out price) || price <= 0)
                {
                    MessageBox.Show("Цена должна быть положительным числом!");
                    return;
                }

                connect = new MySqlConnection(ConString);
                connect.Open();

                string query = "INSERT INTO Services (ServiceName, Description, Price) VALUES (@name, @desc, @price)";
                MySqlCommand cmd = new MySqlCommand(query, connect);

                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@desc", desc);
                cmd.Parameters.AddWithValue("@price", price);

                cmd.ExecuteNonQuery();
                MessageBox.Show("Услуга добавлена успешно!");

                loadService();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка: {ex.Message}");
            }
            finally
            {
                if (connect != null && connect.State == System.Data.ConnectionState.Open)
                {
                    connect.Close();
                }
            }
        }

        private void DeleteService_Click(object sender, EventArgs e)
        {
            try
            {
                if (dataGridViewService.SelectedRows.Count > 0)
                {
                    int serviceId = Convert.ToInt32(dataGridViewService.SelectedRows[0].Cells["ServiceID"].Value);

                    DialogResult dialogResult = MessageBox.Show("Вы уверены, что хотите удалить ?", "Подтверждение", MessageBoxButtons.YesNo);
                    if (dialogResult == DialogResult.Yes)
                    {
                        MySqlConnection connect = new MySqlConnection(ConString);
                        connect.Open();

                        string query = "DELETE FROM Services WHERE ServiceID = @serviceId";
                        MySqlCommand cmd = new MySqlCommand(query, connect);
                        cmd.Parameters.AddWithValue("serviceId", serviceId);

                        cmd.ExecuteNonQuery();
                        MessageBox.Show("Клиент успешно удалён!");

                        connect.Close();

                       loadService();
                    }
                }
                else
                {
                    MessageBox.Show("Выберите услугу для удаления.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка при удалении услуги: " + ex.Message);
            }
        }

        private void dataGridViewService_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dataGridViewService.Rows[e.RowIndex];
                textBoxName.Text = row.Cells["ServiceName"].Value.ToString();
                textBoxDesc.Text = row.Cells["Description"].Value.ToString();
                textBoxPrice.Text = row.Cells["Price"].Value.ToString();

                serviceIdToEdit = Convert.ToInt32(row.Cells["ServiceID"].Value);
            }
        }
        private int serviceIdToEdit = -1;

        private void EditService_Click(object sender, EventArgs e)
        {
            string name = textBoxName.Text;
            string desc = textBoxDesc.Text;
            string prices = textBoxPrice.Text;


            if (string.IsNullOrEmpty(name))
            {
                MessageBox.Show("Название услуги не должно отсутствовать!");
                return;
            }

            if (string.IsNullOrEmpty(desc))
            {
                MessageBox.Show("Описание обязательно для заполнения!");
                return;
            }

            if (string.IsNullOrEmpty(prices))
            {
                MessageBox.Show("Цена обязательна для заполнения!");
                return;
            }

            decimal price;
            if (!decimal.TryParse(prices, out price) || price <= 0)
            {
                MessageBox.Show("Цена должна быть положительным числом!");
                return;
            }

            try
            {
                MySqlConnection connect = new MySqlConnection(ConString);
                connect.Open();

                string query = "UPDATE Services SET ServiceName = @name, Description = @desc, Price = @price WHERE ServiceID = @serviceId";
                MySqlCommand cmd = new MySqlCommand(query, connect);

                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@desc", desc);
                cmd.Parameters.AddWithValue("@price", price);
                cmd.Parameters.AddWithValue("@serviceId", serviceIdToEdit);

                cmd.ExecuteNonQuery();
                MessageBox.Show("Услуга успешно изменена!");


                connect.Close();
                loadService();

            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при изменении: {ex.Message}");
            }
        }
    }
}
