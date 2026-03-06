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
using MySqlConnector;

namespace Kursovik
{
    public partial class ClientsForm : Form
    {
        public String ConString = "server=172.20.7.45; port=3306; user=st4996_23; password=pwd4996_23; database=db_4996_23_prog;";
        public ClientsForm()
        {
            InitializeComponent();
        }


        private void ClientsForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            Global.isActiveClient = true;
        }

        private void ClientsForm_Load(object sender, EventArgs e)
        {
            loadClients();
        }

        private void loadClients()
        {
            try
            {
                MySqlConnection connect = new MySqlConnection(ConString);
                connect.Open();


                string query = "SELECT ClientID, FullName, Phone, Email FROM Clients";
                MySqlCommand cmd = new MySqlCommand(query, connect);

                MySqlDataReader reader = cmd.ExecuteReader();

                DataTable dt = new DataTable();
                dt.Load(reader);

                dataGridViewClients.DataSource = dt;

                connect.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка при загрузке данных: " + ex.Message);
            }
        }

        private void addClient_Click(object sender, EventArgs e)
        {
            MySqlConnection connect = null;
            try
            {
                string name = textBoxName.Text;
                string phone = textBoxPhone.Text;
                string email = string.IsNullOrEmpty(textBoxEmail.Text) ? null : textBoxEmail.Text;


                if (string.IsNullOrEmpty(name) || name.Split(' ').Length < 2)
                {
                    MessageBox.Show("Имя и фамилия обязательны для заполнения и должны быть разделены пробелом!");
                    return;
                }

                if (string.IsNullOrEmpty(phone))
                {
                    MessageBox.Show("Телефон обязателен для заполнения!");
                    return;
                }

                string phoneforma = "^(\\+7|8)\\d{10}$";

                if (!Regex.IsMatch(phone, phoneforma))
                {
                    MessageBox.Show("Номер телефона должен начинаться с 8 или +7 и содержать 10 цифр!");
                    return;
                }

                connect = new MySqlConnection(ConString);
                connect.Open(); 

                string query = "INSERT INTO Clients (FullName, Phone, Email) VALUES (@name, @phone, @email)";
                MySqlCommand cmd = new MySqlCommand(query, connect);

                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@phone", phone);
                cmd.Parameters.AddWithValue("@email", email);

                cmd.ExecuteNonQuery();
                MessageBox.Show("Клиент добавлен успешно!");
                connect.Close();
                loadClients();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка: {ex.Message}");
            }
        }

        private void deleteClient_Click(object sender, EventArgs e)
        {
            try
            {
                if (dataGridViewClients.SelectedRows.Count > 0)
                {
                    int clientId = Convert.ToInt32(dataGridViewClients.SelectedRows[0].Cells["ClientID"].Value);

                    DialogResult dialogResult = MessageBox.Show("Вы уверены, что хотите удалить этого клиента?", "Подтверждение", MessageBoxButtons.YesNo);
                    if (dialogResult == DialogResult.Yes)
                    {
                        MySqlConnection connect = new MySqlConnection(ConString);
                        connect.Open();

                        string query = "DELETE FROM Clients WHERE ClientID = @clientID";
                        MySqlCommand cmd = new MySqlCommand(query, connect);
                        cmd.Parameters.AddWithValue("@clientId", clientId);

                        cmd.ExecuteNonQuery();
                        MessageBox.Show("Клиент успешно удалён!");

                        connect.Close();

                        loadClients();
                    }
                }
                else
                {
                    MessageBox.Show("Выберите клиента для удаления.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка при удалении клиента: " + ex.Message);
            }

        }

        private void dataGridViewClients_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dataGridViewClients.Rows[e.RowIndex];
                textBoxName.Text = row.Cells["FullName"].Value.ToString();
                textBoxPhone.Text = row.Cells["Phone"].Value.ToString();
                textBoxEmail.Text = row.Cells["Email"].Value.ToString();

                clientIdToEdit = Convert.ToInt32(row.Cells["ClientID"].Value);
            }
        }

        private int clientIdToEdit = -1;
        private void editClient_Click(object sender, EventArgs e)
        {
            string name = textBoxName.Text;
            string phone = textBoxPhone.Text;
            string email = string.IsNullOrEmpty(textBoxEmail.Text) ? null : textBoxEmail.Text;

            if (string.IsNullOrEmpty(name) || name.Split(' ').Length < 2)
            {
                MessageBox.Show("Имя и фамилия обязательны для заполнения и должны быть разделены пробелом!");
                return;
            }

            if (string.IsNullOrEmpty(phone))
            {
                MessageBox.Show("Телефон обязателен для заполнения!");
                return;
            }

            string phoneforma = "^(\\+7|8)\\d{10}$";

            if (!Regex.IsMatch(phone, phoneforma))
            {
                MessageBox.Show("Номер телефона должен начинаться с 8 или +7 и содержать 10 цифр!");
                return;
            }

            try
            {
                MySqlConnection connect = new MySqlConnection(ConString);
                connect.Open();

                string query = "UPDATE Clients SET FullName = @name, Phone = @phone, Email = @email WHERE ClientID = @clientId";
                MySqlCommand cmd = new MySqlCommand(query, connect);

                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@phone", phone);
                cmd.Parameters.AddWithValue("@email", email);
                cmd.Parameters.AddWithValue("@clientId", clientIdToEdit);

                cmd.ExecuteNonQuery();
                MessageBox.Show("Данные клиента успешно обновлены!");
                

                connect.Close();
                loadClients();

            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при обновлении: {ex.Message}");
            }
        }

        private void searchClient_Click(object sender, EventArgs e)
        {
            try
            {
                string searchQuery = "SELECT ClientID, FullName, Phone, Email FROM Clients WHERE FullName LIKE @searchTerm";

                if (string.IsNullOrEmpty(Search1.Text))
                {
                    MessageBox.Show("Пожалуйста, введите данные для поиска.");
                    return;
                }

                using (MySqlConnection connect = new MySqlConnection(ConString))
                {
                    connect.Open();

                    MySqlCommand cmd = new MySqlCommand(searchQuery, connect);
                    cmd.Parameters.AddWithValue("@searchTerm", "%" + Search1.Text + "%");

                    MySqlDataReader reader = cmd.ExecuteReader();

                    DataTable dt = new DataTable();
                    dt.Load(reader);
                    dataGridViewClients.DataSource = dt;
                    connect.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка: {ex.Message}");
            }
        }
    }
}
