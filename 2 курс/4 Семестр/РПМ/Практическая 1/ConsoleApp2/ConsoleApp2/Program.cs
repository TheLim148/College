using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Airport airport = new Airport("Пулково", 1000, 500);
            airport.Info();
            airport.CostOfTicketsSold();

            Console.ReadKey(true);
        }
    }
}
