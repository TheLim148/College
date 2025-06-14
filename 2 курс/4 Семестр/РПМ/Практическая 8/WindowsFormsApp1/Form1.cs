using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApp1
{
    public partial class Form1 : Form
    {
        public static class Globals
        {
            public static string data { get; set; }
        }

        Form2 childForm;
        Form3 refForm;
        //public string data1;
        public Form1()
        {
            
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void файлToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void выходToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void должностьToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Globals.data = "Должность";
            childForm = new Form2(Globals.data);
            
            //data1 = "Должность";
            //childForm = new Form2(data1);
            
            childForm.Show();
        }

        private void сотрудникиToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Globals.data = "Сотрудники";
            childForm = new Form2(Globals.data);

            //data1 = "Сотрудники";
            //childForm = new Form2(data1);
            
            childForm.Show();
        }

        private void оПрограммеToolStripMenuItem_Click(object sender, EventArgs e)
        {
            refForm = new Form3();
            refForm.Show();
        }
    }
}
