using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practice_4
{
    public class Class1 : Iy
    {
        void Iy.F0(double w)
        {
            Console.WriteLine($"Sine of {w} equals: " + Math.Sin(w));
        }

        void Iy.F1(double w) 
        {
            Console.WriteLine($"{w} + 2 equals: " + (w + 2));
        } //Явная реализация методов
    }
}
