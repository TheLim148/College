using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    public class Class3
    {
        public string text;
        public Class3(string text)
        {
            this.text = text;
        }
        public override string ToString()
        {
            string txt = "Text field: \"" + text + "\"";
            return txt;
        }
        public char ToChar()
        {
            char txt = text[0];
            return txt;
        }
        public static explicit operator Class3(int n)
        {
            string s = "";
            for (int i = 0; i < n; i++)
            {
                s = s + 'A';
            }
            Class3 t = new Class3(s);
            return t;
        }
        public static explicit operator int(Class3 obj)
        {
            return obj.text.Length;
        }
    }
}
