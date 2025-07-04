using System;
using System.Data;
using System.Windows.Forms;
using System.Data.OleDb;
using System.IO; 
using System.Collections.Generic; 

namespace EventNotificationSystem
{
    public partial class MainForm : Form
    {

        //private string dbFilePath = "C:\\Users\\Ярослав\\OneDrive\\Рабочий стол\\Database1.mdb"; 
        private string dbFilePath = "C:\\Users\\Lima148\\Desktop\\Новая папка\\Database1.mdb";
        private string connectionString = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Persist Security Info=False;";

        private OleDbConnection connection;
        private DataTable eventsTable;
        private int currentEventId = -1; 

        public MainForm()
        {
            InitializeComponent();
            InitializeDatabase();
            LoadEvents();
            
            SetFormState(false);
        }

        private void InitializeDatabase()
        {
            connectionString = string.Format(connectionString, dbFilePath); 
            if (!File.Exists(dbFilePath)) 
            {
                MessageBox.Show($"Файл базы данных не найден по пути: {dbFilePath}", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                SetEditableControlsEnabled(false); 
                return;
            }

            try
            {
                connection = new OleDbConnection(connectionString);
                connection.Open();
               
                if (connection.State == ConnectionState.Open)
                {
                    
                }
            }
            catch (OleDbException ex)
            {
                MessageBox.Show($"Ошибка подключения к базе данных: {ex.Message}", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                
                SetEditableControlsEnabled(false);
            }
        }

        private void LoadEvents()
        {
            eventsTable = new DataTable();
            string query = "SELECT Id, EventName, Description, EventDateTime FROM Events"; 

           

            if (connection.State != ConnectionState.Open)
            {
                return;
            }

            using (OleDbDataAdapter adapter = new OleDbDataAdapter(query, connection))
            {
                try
                {
                    adapter.Fill(eventsTable);
                    dgvEvents.DataSource = eventsTable; 

                  
                    dgvEvents.Columns["Id"].Visible = false; 
                    dgvEvents.Columns["EventName"].HeaderText = "Название события";
                    dgvEvents.Columns["Description"].HeaderText = "Описание";
                    dgvEvents.Columns["EventDateTime"].HeaderText = "Дата и время";
                

            
                    dgvEvents.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
                }
                catch (OleDbException ex)
                {
                    MessageBox.Show($"Ошибка при загрузке событий: {ex.Message}", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }

      
        private void SetFormState(bool isEditing)
        {
            txtEventName.Enabled = isEditing;
            txtDescription.Enabled = isEditing;
            dtpEventDateTime.Enabled = isEditing;
         

            btnSave.Enabled = isEditing;
          

          
            btnAdd.Enabled = !isEditing;
            btnEdit.Enabled = !isEditing && dgvEvents.Rows.Count > 0; 
            btnDelete.Enabled = !isEditing && dgvEvents.Rows.Count > 0; 
        }

   
        private void SetEditableControlsEnabled(bool enabled)
        {
            txtEventName.Enabled = enabled;
            txtDescription.Enabled = enabled;
            dtpEventDateTime.Enabled = enabled;
         
        }

    
        private void btnAdd_Click(object sender, EventArgs e)
        {
            currentEventId = -1;
            txtEventName.Text = "";
            txtDescription.Text = "";
            dtpEventDateTime.Value = DateTime.Now; 
     

            SetFormState(true); 
            txtEventName.Focus(); 
        }

        
        private void btnEdit_Click(object sender, EventArgs e)
        {
            if (dgvEvents.SelectedRows.Count > 0)
            {
                DataGridViewRow selectedRow = dgvEvents.SelectedRows[0];
                currentEventId = Convert.ToInt32(selectedRow.Cells["Id"].Value); 

                txtEventName.Text = selectedRow.Cells["EventName"].Value.ToString();
                txtDescription.Text = selectedRow.Cells["Description"].Value.ToString();
                dtpEventDateTime.Value = Convert.ToDateTime(selectedRow.Cells["EventDateTime"].Value);
           

                SetFormState(true);
                txtEventName.Focus();
            }
            else
            {
                MessageBox.Show("Пожалуйста, выберите событие для изменения.", "Нет выбора", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

     
        private void btnDelete_Click(object sender, EventArgs e)
        {
            if (dgvEvents.SelectedRows.Count > 0)
            {
                if (MessageBox.Show("Вы уверены, что хотите удалить выбранное событие?", "Подтверждение удаления", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                {
                    DataGridViewRow selectedRow = dgvEvents.SelectedRows[0];
                    int eventIdToDelete = Convert.ToInt32(selectedRow.Cells["Id"].Value);

                    if (DeleteEvent(eventIdToDelete))
                    {
                        MessageBox.Show("Событие успешно удалено.", "Успех", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        LoadEvents(); 
                        ClearInputFields();
                        SetFormState(false);
                    }
                }
            }
            else
            {
                MessageBox.Show("Пожалуйста, выберите событие для удаления.", "Нет выбора", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

    
        private void btnSave_Click(object sender, EventArgs e)
        {
            if (ValidateInput()) 
            {
                if (currentEventId == -1) 
                {
                    if (AddEvent())
                    {
                        MessageBox.Show("Событие успешно добавлено.", "Успех", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        LoadEvents(); 
                        ClearInputFields(); 
                        SetFormState(false); 
                    }
                }
                else 
                {
                    if (UpdateEvent(currentEventId))
                    {
                        MessageBox.Show("Событие успешно обновлено.", "Успех", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        LoadEvents(); 
                        ClearInputFields(); 
                        SetFormState(false);
                    }
                }
            }
        }

   
        private void ClearInputFields()
        {
            txtEventName.Text = "";
            txtDescription.Text = "";
            dtpEventDateTime.Value = DateTime.Now;
            errorProvider1.Clear(); 
        }

        
        private bool ValidateInput()
        {
            errorProvider1.Clear(); 

            if (string.IsNullOrWhiteSpace(txtEventName.Text))
            {
                errorProvider1.SetError(txtEventName, "Название события не может быть пустым.");
                return false;
            }
            return true;
        }

   
        private bool AddEvent()
        {
            string query = "INSERT INTO Events (EventName, Description, EventDateTime) VALUES (@EventName, @Description, @EventDateTime)";
            

            if (connection.State != ConnectionState.Open) return false;

            using (OleDbCommand cmd = new OleDbCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@EventName", txtEventName.Text);
                cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                cmd.Parameters.AddWithValue("@EventDateTime", dtpEventDateTime.Value);
     

                try
                {
                    cmd.ExecuteNonQuery();
                    return true;
                }
                catch (OleDbException ex)
                {
                    MessageBox.Show($"Ошибка при добавлении события: {ex.Message}", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return false;
                }
            }
        }

        private bool UpdateEvent(int id)
        {
            string query = "UPDATE Events SET EventName = @EventName, Description = @Description, EventDateTime = @EventDateTime WHERE Id = @Id";

            if (connection.State != ConnectionState.Open) return false;

            using (OleDbCommand cmd = new OleDbCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.Parameters.AddWithValue("@EventName", txtEventName.Text);
                cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                cmd.Parameters.AddWithValue("@EventDateTime", dtpEventDateTime.Value);

                try
                {
                    cmd.ExecuteNonQuery();
                    return true;
                }
                catch (OleDbException ex)
                {
                    MessageBox.Show($"Ошибка при обновлении события: {ex.Message}", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return false;
                }
            }
        }
        private bool DeleteEvent(int id)
        {
            string query = "DELETE FROM Events WHERE Id = @Id";

            if (connection.State != ConnectionState.Open) return false;

            using (OleDbCommand cmd = new OleDbCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@Id", id);

                try
                {
                    cmd.ExecuteNonQuery();
                    return true;
                }
                catch (OleDbException ex)
                {
                    MessageBox.Show($"Ошибка при удалении события: {ex.Message}", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return false;
                }
            }
        }

        private void dgvEvents_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0 || dgvEvents.SelectedRows.Count == 0)
            {
                return;
            }


            if (!txtEventName.Enabled) 
            {
                DataGridViewRow selectedRow = dgvEvents.SelectedRows[0];
                

                txtEventName.Text = selectedRow.Cells["EventName"].Value.ToString();
                txtDescription.Text = selectedRow.Cells["Description"].Value.ToString();
                dtpEventDateTime.Value = Convert.ToDateTime(selectedRow.Cells["EventDateTime"].Value);
           
            }
        }


        protected override void OnFormClosing(FormClosingEventArgs e)
        {
            if (connection != null && connection.State == ConnectionState.Open)
            {
                connection.Close();
            }
            base.OnFormClosing(e);
        }
    }
}