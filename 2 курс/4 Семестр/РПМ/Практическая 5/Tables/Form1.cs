using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace Tables
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            var HC = "\r\n";
            String[] Names = {"Max", "Ilya", "Vanya", "Semen", "Masya"};
            String[] Telephones = {"88005553535", "86666666666", "+79537282000", "+584658439089", "+19993325676"};
            int i = 0;

            foreach (var n in Names)
            {
                richTextBox1.Text += String.Format("{0,-21}{1,-21}" + HC, n, Telephones[i]);
                i++;
            }

            var wr = new System.IO.StreamWriter(saveFileDialog1.FileName, false, System.Text.Encoding.GetEncoding(1251));
            wr.Write(richTextBox1.Text);
            wr.Close();

            var HTML_Writer = new System.IO.StreamWriter(@"C:\Users\Lima148\Desktop\Table.html");

            HTML_Writer.WriteLine("<html>");
            HTML_Writer.WriteLine("<head>");
            HTML_Writer.WriteLine("<style> table, th, td, tr { border: 1px solid; }</style>");
            HTML_Writer.WriteLine("</head>");
            HTML_Writer.WriteLine("<body>");
            HTML_Writer.WriteLine("<table>");
            HTML_Writer.WriteLine("<tr>");
            HTML_Writer.WriteLine("<th>Names</th>");
            HTML_Writer.WriteLine("<th>Telephones</th>");
            HTML_Writer.WriteLine("</tr>");
            HTML_Writer.WriteLine("<tr>");
            HTML_Writer.WriteLine($"<td>{Names[0]}</td>");
            HTML_Writer.WriteLine($"<td>{Telephones[0]}</td>");
            HTML_Writer.WriteLine("</th>");
            HTML_Writer.WriteLine("<tr>");
            HTML_Writer.WriteLine($"<td>{Names[1]}</td>");
            HTML_Writer.WriteLine($"<td>{Telephones[1]}</td>");
            HTML_Writer.WriteLine("</th>");
            HTML_Writer.WriteLine("<tr>");
            HTML_Writer.WriteLine($"<td>{Names[2]}</td>");
            HTML_Writer.WriteLine($"<td>{Telephones[2]}</td>");
            HTML_Writer.WriteLine("</th>");
            HTML_Writer.WriteLine("<tr>");
            HTML_Writer.WriteLine($"<td>{Names[3]}</td>");
            HTML_Writer.WriteLine($"<td>{Telephones[3]}</td>");
            HTML_Writer.WriteLine("</th>");
            HTML_Writer.WriteLine("<tr>");
            HTML_Writer.WriteLine($"<td>{Names[4]}</td>");
            HTML_Writer.WriteLine($"<td>{Telephones[4]}</td>");
            HTML_Writer.WriteLine("</th>");
            HTML_Writer.WriteLine("</table>");
            HTML_Writer.WriteLine("</body>");
            HTML_Writer.WriteLine("</html>");
            HTML_Writer.Close();
            //System.Diagnostics.Process.Start("iexplorer", @"C:\Users\Lima148\Desktop\Practice 5\Tables\Table.html");

            DataTable tabl = new DataTable();
            tabl.Columns.Add("Names", typeof(String));
            tabl.Columns.Add("Phones", typeof(String));
            for (int j = 0; j < Names.Length; j++)
            {
                tabl.Rows.Add(Names[j], Telephones[j]);
            }
            dataGridView1.DataSource = tabl;
        }

        private void fileToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void showTableInToolStripMenuItem_Click(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Process.Start("Notepad", @"C:\Users\Student\Desktop\Table.txt");
            }
            catch (Exception situation)
            {
                MessageBox.Show(situation.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }

        }

        private void dataViewToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
