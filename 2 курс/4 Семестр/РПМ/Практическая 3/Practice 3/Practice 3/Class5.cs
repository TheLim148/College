using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practice_3
{
    public class MyClass5
    {
        private char[,] symbols;

        public MyClass5(int n, int m)
        {
            symbols = new char[n, m];
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < m; j++) {
                    symbols[i, j] = '0';
                }
            }
        }

        public void PrintArray()
        {
            for (int i = 0; i < symbols.GetLength(0); i++) {
                for (int j = 0; j < symbols.GetLength(1); j++) {
                    Console.Write(symbols[i, j] + " ");
                }
                Console.WriteLine();
            }
        }

        public char this[int n, int m]
        {
            get => symbols[n, m];
            set => symbols[n, m] = value;
        }
    }
}
