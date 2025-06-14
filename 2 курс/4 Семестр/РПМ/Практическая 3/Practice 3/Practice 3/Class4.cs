using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practice_3
{
    public class MyClass4
    {
        private int code;

        public MyClass4(char sign)
        {
            code = sign;
        }

        public int this[int index]
        {
            get => code;
            set => code = value;
        }
    }
}
