using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.ConstrainedExecution;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    public class ZHEK
    {
        private string discrict;
        private int ZHEKnumber;
        private int numberOfResidents;
        private double paymentPerMonth = 5000.0;
        private int numberOfPaid;

        public ZHEK(string discrict, int ZHEKnumber, int numberOfResidents, int numberOfPaid)
        {
            this.discrict = discrict;
            this.ZHEKnumber = ZHEKnumber;
            this.numberOfResidents = numberOfResidents;
            this.numberOfPaid = numberOfPaid;
            
            if(numberOfPaid > numberOfResidents)
            {
                throw new Exception("Количество оплативших не может быть больше количества проживающих");
            }
        }

        public void Info()
        {
            Console.WriteLine($"Оплата за месяц: {paymentPerMonth}\n");
            Console.WriteLine($"Район: {discrict}\nНомер ЖЭКА: {ZHEKnumber}\nКоличество жителей: {numberOfResidents}\nЧисло оплативших: {numberOfPaid}");
        }

        public void TenantsDebts()
        {
            Console.WriteLine($"\nОбщая задолженность жильцов: {(numberOfResidents - numberOfPaid) * paymentPerMonth}");
        }
    }
}
