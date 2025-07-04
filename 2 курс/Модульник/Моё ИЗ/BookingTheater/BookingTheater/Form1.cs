using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MySqlConnector;
namespace BookingTheater
{
    public partial class Form1 : Form
    {
        public String ConString = "server=172.20.7.12; port=3306; user=iz3992_23; password=pwd3992_23; database=um3992_23;";
        public Form1()
        {
            InitializeComponent();
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            MySqlConnection connect = new MySqlConnection(ConString);
            connect.Open();

            string query = "SELECT id, title, description, duration FROM spectacles";
            MySqlDataAdapter adapter = new MySqlDataAdapter(query, connect);
            DataTable dt = new DataTable();
            adapter.Fill(dt);

            dataGridView1.DataSource = null;
            dataGridView1.Columns.Clear();
            dataGridView1.AutoGenerateColumns = true;

            dataGridView1.DataSource = dt;
            connect.Close();
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            string name = txtName.Text.Trim();
            string desc = txtDesc.Text.Trim();
            string durationText = txtDuration.Text.Trim();

            if (string.IsNullOrWhiteSpace(name) || string.IsNullOrWhiteSpace(durationText))
            {
                MessageBox.Show("Введите название и длительность спектакля.");
                return;
            }

            if (!int.TryParse(durationText, out int duration))
            {
                MessageBox.Show("Длительность должна быть числом.");
                return;
            }

            try
            {
                MySqlConnection connection = new MySqlConnection(ConString);

                connection.Open();
                string query = "INSERT INTO spectacles (title, description, duration) VALUES (@title, @desc, @duration)";
                MySqlCommand cmd = new MySqlCommand(query, connection);
                
                cmd.Parameters.AddWithValue("@title", name);
                cmd.Parameters.AddWithValue("@desc", desc);
                cmd.Parameters.AddWithValue("@duration", duration);
                cmd.ExecuteNonQuery();

                connection.Close();

                MessageBox.Show("Запись успешно добавлена.");

                txtName.Text = "";
                txtDesc.Text = "";
                txtDuration.Text = "";

                Form1_Load(null, null);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка при добавлении записи: " + ex.Message);
            }
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0 && dataGridView1.Rows[e.RowIndex].Cells["id"].Value != DBNull.Value)
            {
                txtName.Text = dataGridView1.Rows[e.RowIndex].Cells["title"].Value.ToString();
                txtDesc.Text = dataGridView1.Rows[e.RowIndex].Cells["description"].Value.ToString();
                txtDuration.Text = dataGridView1.Rows[e.RowIndex].Cells["duration"].Value.ToString();
            }
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            if (dataGridView1.SelectedRows.Count == 0)
            {
                MessageBox.Show("Выберите запись для удаления.");
                return;
            }

            int selectedId = Convert.ToInt32(dataGridView1.SelectedRows[0].Cells["id"].Value);

            DialogResult result = MessageBox.Show("Вы уверены, что хотите удалить запись?", "Подтверждение", MessageBoxButtons.YesNo);
            if (result != DialogResult.Yes)
            {
                return;
            }

            try
            {
                MySqlConnection connection = new MySqlConnection(ConString);
                connection.Open();

                string query = "DELETE FROM spectacles WHERE id = @id";
                MySqlCommand cmd = new MySqlCommand(query, connection);
                cmd.Parameters.AddWithValue("@id", selectedId);
                cmd.ExecuteNonQuery();

                connection.Close();

                MessageBox.Show("Запись успешно удалена.");
                Form1_Load(null, null);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка при удалении записи: " + ex.Message);
            }
        }

        private void btnChange_Click(object sender, EventArgs e)
        {
            if (dataGridView1.SelectedRows.Count == 0)
            {
                MessageBox.Show("Выберите запись для изменения.");
                return;
            }

            int selectedId = Convert.ToInt32(dataGridView1.SelectedRows[0].Cells["id"].Value);

            string name = txtName.Text.Trim();
            string desc = txtDesc.Text.Trim();
            string durationText = txtDuration.Text.Trim();

            if (string.IsNullOrWhiteSpace(name) || string.IsNullOrWhiteSpace(durationText))
            {
                MessageBox.Show("Введите название и длительность.");
                return;
            }

            if (!int.TryParse(durationText, out int duration))
            {
                MessageBox.Show("Длительность должна быть числом.");
                return;
            }

            try
            {
                MySqlConnection connection = new MySqlConnection(ConString);
                connection.Open();

                string query = "UPDATE spectacles SET title = @title, description = @desc, duration = @duration WHERE id = @id";
                MySqlCommand cmd = new MySqlCommand(query, connection);

                cmd.Parameters.AddWithValue("@title", name);
                cmd.Parameters.AddWithValue("@desc", desc);
                cmd.Parameters.AddWithValue("@duration", duration);
                cmd.Parameters.AddWithValue("@id", selectedId);

                cmd.ExecuteNonQuery();
                connection.Close();

                MessageBox.Show("Запись успешно обновлена.");

                txtName.Text = "";
                txtDesc.Text = "";
                txtDuration.Text = "";

                Form1_Load(null, null);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка при обновлении: " + ex.Message);
            }
        }
    }
}
