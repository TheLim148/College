using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace Practice_3
{
    public class MyClass2
    {
        private string code;

        public MyClass2(uint _number)
        {
            number = _number;
        }

        public uint number
        {
            set
            {
                uint num;
                num = value;
                code = "";
                do {
                    code += (num % 2).ToString();
                    num >>= 1;
                } while (num != 0);
                char[] chars = code.ToCharArray();
                Array.Reverse(chars);
                code = new string(chars);
            }
        }

        public override string ToString()
        {
            return code;
        }
    }
}
