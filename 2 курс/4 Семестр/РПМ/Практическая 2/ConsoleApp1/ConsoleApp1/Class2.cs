using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    public class Class2
    {
        public int code;
        public Class2(int code)
        {
            this.code = code;
        }
        static public bool operator true(Class2 a)
        {
            switch (a.code)
            {
                case 2:
                case 3:
                case 5:
                case 7:
                    return true;
                default:
                    return false;

            }

        }
        static public bool operator false(Class2 a)
        {

            if (a.code < 1 || a.code > 10)
                return false;

            return true;



        }
        static public Class2 operator &(Class2 a, Class2 b)
        {

            if (a)
            {
                return b;
            }
            return a;
        }
        static public Class2 operator |(Class2 a, Class2 b)
        {

            if (a)
            {
                return a;
            }
            return b;
        }
    }
}
