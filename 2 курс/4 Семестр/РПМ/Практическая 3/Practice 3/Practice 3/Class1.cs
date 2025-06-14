using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.ExceptionServices;
using System.Text;
using System.Threading.Tasks;

namespace Practice_3
{
    public class MyClass1
    {
        public int first;
        public int last;
        public readonly int number;

        public MyClass1(int _first, int _last)
        {
            first = _first;
            last = _last;   
        }

        public int Number
        {
            get { 
                return (first + last);
            }
        }
    }
}
