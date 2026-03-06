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
    public partial class MainForm : Form
    {
        
        public MainForm()
        {
            InitializeComponent();
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
        }

        private void Clients_Click(object sender, EventArgs e)
        {
            ClientsForm clientsForm = new ClientsForm();
            if (Global.isActiveClient)
            {
                clientsForm.Show();
                Global.isActiveClient = false;
            }
            
        }

        private void Clients_Closed(object sender, EventArgs e)
        {

        }

        private void Service_Click(object sender, EventArgs e)
        {
            ServiceForm serviceForm = new ServiceForm();
            if (Global.isActiveService)
            {
                serviceForm.Show();
                Global.isActiveService = false;
            }
        }

        private void Orders_Click(object sender, EventArgs e)
        {
            OrdersForm ordersForm = new OrdersForm();
            if (Global.isActiveOrders)
            {
                ordersForm.Show();
                Global.isActiveOrders = false;
            }
        }

        private void Reports_Click(object sender, EventArgs e)
        {
            ReportsForm reportsForm = new ReportsForm();
            if (Global.isActiveReports)
            {
                reportsForm.Show();
                Global.isActiveReports = false;
            }

            
        }
    }
}
