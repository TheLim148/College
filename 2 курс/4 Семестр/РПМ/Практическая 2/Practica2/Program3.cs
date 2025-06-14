using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practica_Peregruzka2
{
    internal class Quest3
    {
        static void Main()
        {
            MyClass A = new MyClass("text");
            A.ToString();
            A.ToChar();

        }
    }
    class MyClass
    {
        public string text;
        public MyClass(string text)
        {
            this.text = text;
        }
        public override string ToString()
        {
            string txt = "Текстовое поле: \" " + text + "\"";
            return txt;
        }
        public char ToChar()
        {
            char txt = text[0];
            return txt;
        }
        public static explicit operator MyClass(int n)
        {
            string s = "";
            for (int i = 0; i < n; i++)
            {
                s = s + 'A';
            }
            MyClass t = new MyClass(s);
            return t;
        }
        public static explicit operator int(MyClass obj)
        {
            return obj.text.Length;
        }
    }

}
