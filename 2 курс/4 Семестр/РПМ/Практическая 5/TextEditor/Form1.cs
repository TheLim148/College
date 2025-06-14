using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace TextEditor
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void zap()
        {
            try
            {
                var wr = new System.IO.StreamWriter(saveFileDialog1.FileName, false, System.Text.Encoding.GetEncoding(1251));
                wr.Write(richTextBox1.Text);
                wr.Close();
                richTextBox1.Modified = false;
            }
            catch (Exception s)
            {
                MessageBox.Show(s.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void saveFileDialog1_FileOk(object sender, CancelEventArgs e)
        {

        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        { 
            openFileDialog1.ShowDialog(this);
            if(openFileDialog1.FileName == String.Empty)
            {
                return;
            }
            try
            {
                var rd = new System.IO.StreamReader(openFileDialog1.FileName, Encoding.GetEncoding(1251));
                richTextBox1.Text = rd.ReadToEnd();
                rd.Close();
            }

            catch (System.IO.FileLoadException s)
            {
                MessageBox.Show(s.Message + "\nThis file does not exist", "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }

            catch (Exception s)
            {
                MessageBox.Show(s.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }

        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            saveFileDialog1.FileName = openFileDialog1.FileName;
            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                zap();
            }

        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if(richTextBox1.Text == String.Empty)
            {
                return;
            }

            var MBox = MessageBox.Show("Text has been changed" + " Save changes?", "Edit", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Exclamation);
            if (MBox == DialogResult.No)
            {
                return;
            }
            else if (MBox == DialogResult.Cancel)
            {
                e.Cancel = true;
            }
            else if (MBox == DialogResult.Yes)
            {
                if (saveFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    zap();
                    return;
                }
                else
                {
                    e.Cancel = true;
                }
            }
        }

        private void copyToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Clipboard.SetDataObject(richTextBox1.SelectedText);
        }

        private void pasteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            richTextBox1.Text += Clipboard.GetText();
        }

        private void cutToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Clipboard.SetDataObject(richTextBox1.SelectedText);
            richTextBox1.SelectedText = "";
        }
    }
}
