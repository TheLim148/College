using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practice_4
{
    public class Toy : IComparableToy //Создание класса Toy, который наследует интерфейс
    {
        public string Name;
        public double Price;
        public int MinAge;
        public int MaxAge; //Обозначение полей

        public Toy(string name, double price, int minAge, int maxAge)
        {
            Name = name;
            Price = price;
            MinAge = minAge;
            MaxAge = maxAge;
        } //Консруктор для этих полей

        public void DisplayInfo()
        {
            Console.WriteLine($"{Name} - {Price} руб. Возраст: {MinAge}-{MaxAge} лет");
        } //Метод, который отображает информацию про товар

        public int CompareTo(Toy other)
        {
            return Price.CompareTo(other.Price);
        } //Реализация метода CompareTo, который сравнимает цену с другой ценой
    }

    public class ToyComparerByAge : IComparerToy //Создание класса, для сравнения товаров по подходящему возрасту
    {
        public int Compare(Toy x, Toy y)
        {
            return x.MinAge.CompareTo(y.MinAge); //Реализация метода Compare, который сравнимает два возраста и ищет минимальный
        }
    }
}
