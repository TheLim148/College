using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Practice_6
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            richTextBox1.Clear();
            richTextBox1.TabIndex = 0;
            button1.TabIndex = 1;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            var Word1 = new Microsoft.Office.Interop.Word.Application();
            var Doc1 = Word1.Documents.Add();

            Doc1.Words.First.InsertBefore(richTextBox1.Text);
            Doc1.CheckSpelling();

            string correctedText = Doc1.Content.Text;
            richTextBox1.Text = correctedText;

            Word1.Documents.Close(false);
            Word1.Quit(true);
            Word1 = null;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string[] names = {"Semen", "Vasya", "Nika"};
            string[] phones = {"+71234567890", "+21322678534", "+561488412345"};

            var Word1 = new Microsoft.Office.Interop.Word.Application();
            
            Word1.Visible = true;
            Word1.Documents.Add();
            Word1.Selection.TypeText("Table of phone numbers");

            Word1.ActiveDocument.Tables.Add(Word1.Selection.Range, names.Length + 1, 2);

            for(int i = 0; i < names.Length; i++)
            {
                Word1.ActiveDocument.Tables[1].Cell(i + 1, 1).Range.InsertAfter(names[i]);
                Word1.ActiveDocument.Tables[1].Cell(i + 1, 2).Range.InsertAfter(phones[i]);
            }
        }
    }
}
