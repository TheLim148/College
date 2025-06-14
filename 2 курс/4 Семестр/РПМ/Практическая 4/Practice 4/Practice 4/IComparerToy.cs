using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practice_4
{
    interface IComparerToy
    {
        int Compare(Toy x, Toy y); //Интерфейс с методом который тоже сравнимает поля
    }
}
