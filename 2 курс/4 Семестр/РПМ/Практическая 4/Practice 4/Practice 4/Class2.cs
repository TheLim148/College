using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practice_4
{
    public class Class2 : Iz
    {
        void Iz.F0(double w)
        {
            Console.WriteLine($"2 / {w} + ln({w}) equals: " + (2 / w + Math.Log(w)));
        }

        void Iz.F1()
        {
            Console.WriteLine("This thing do nothing");
        } //Явная реализация методов
    }
}
