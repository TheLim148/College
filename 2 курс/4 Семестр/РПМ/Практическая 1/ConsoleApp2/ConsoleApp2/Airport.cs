using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    public class Airport
    {
        private string airportName;
        private double ticketPrice = 400.0;
        private int numberOfSeatsInAllPlanes;
        private int numberOfTicketsSold;

        public Airport(string airportName, int numberOfSeatsInAllPlanes, int numberOfTicketsSold)
        {
            this.airportName = airportName;
            //this.ticketPrice = ticketPrice;
            this.numberOfSeatsInAllPlanes = numberOfSeatsInAllPlanes;
            this.numberOfTicketsSold = numberOfTicketsSold;
        }

        public void Info()
        {
            Console.WriteLine($"Название аэропорта: {airportName}\nКоличество мест во всех самолетах: {numberOfSeatsInAllPlanes}\nКоличество проданных билетов: {numberOfTicketsSold}");
        }

        public void CostOfTicketsSold()
        {
            Console.WriteLine($"\nОбщая стоимость проданных билетов - {ticketPrice*numberOfTicketsSold}");
        }
    }
}
