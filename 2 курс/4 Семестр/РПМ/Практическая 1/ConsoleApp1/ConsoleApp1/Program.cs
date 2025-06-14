using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    internal class Program
    {
        static void Main(string[] args)
        {
            //Третий вариант
            try
            {
                ZHEK zhek = new ZHEK("Западный", 42, 5000, 4500);
                zhek.Info();
                zhek.TenantsDebts();
                Console.ReadKey(true);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                Console.ReadKey(true);
            }
        }
    }
}
