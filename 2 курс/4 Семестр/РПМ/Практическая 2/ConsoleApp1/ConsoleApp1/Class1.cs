using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    public class Class1
    {
        public int code;
        public string txt;
        public Class1(int code, string txt)
        {
            this.code = code;
            this.txt = txt;
        }

        static public bool operator ==(Class1 x, Class1 y)
        {
            return Equals((x.txt).Length, (y.txt).Length);
        }
        static public bool operator !=(Class1 x, Class1 y)
        {
            return !Equals((x.txt).Length, (y.txt).Length);
        }
        static public bool operator <(Class1 x, Class1 y)
        {
            return (x.txt).Length < (y.txt).Length;
        }
        static public bool operator >(Class1 x, Class1 y)
        {
            return (x.txt).Length > (y.txt).Length;
        }
        static public bool operator >=(Class1 x, Class1 y)
        {
            return x.code >= y.code;
        }
        static public bool operator <=(Class1 x, Class1 y)
        {
            return x.code <= y.code;
        }
        override public int GetHashCode()
        {
            return code ^ txt[0];
        }
        public bool Equals(Class1 obj)
        {
            Class1 t;
            t = obj;
            if (t == this)
            {
                return true;
            }
            return false;
        }
    }
}
