using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practice_4
{
    internal class Program
    {
        static void Main(string[] args)
        {
            //Number 7
            //Tasks 4.1 - 4.2
            Console.WriteLine("TASKS 4.1 - 4.2");
            Console.WriteLine("Class 1");
            Iy class1 = new Class1(); //Интерфейсная переменная, которой присваивается объект класса
            class1.F0(180);
            class1.F1(14); //Поочередный вызов методов F0 и F1

            Console.WriteLine("\nClass 2");
            Iz class2 = new Class2();
            class2.F0(10);
            class2.F1();

            //Task 4.3
            Console.WriteLine("\nTASK 4.3");

            List<Toy> toys = new List<Toy>()
            {
                new Toy("Car", 500, 3, 6),
                new Toy("Dolly", 800, 4, 8),
                new Toy("Lego", 3500, 5, 12),
                new Toy("Soft bear", 700, 2, 7),
                new Toy("Puzzle", 2000, 6, 14)
            }; //Создание списка с объектами класса Toy

            int minAge = 3;
            int maxAge = 8; //Обозначение минимального и максимального возраста

            List<Toy> filteredToys = toys.FindAll(toy => toy.MinAge <= maxAge && toy.MaxAge >= minAge); //Создание списка, в который входят все элементы в заданном диапазоне
            filteredToys.Sort((toys1, toys2) => toys1.CompareTo(toys2)); //Сортировка с помощью стороннего метода CompareTo

            Console.WriteLine("Toys sorted by price");
            foreach (var toy in filteredToys)
            {
                toy.DisplayInfo();
            } //Вывод всех элементов, отсортированных по цене

            filteredToys.Sort(new ToyComparerByAge().Compare);

            Console.WriteLine("\nToys sorted by age");
            foreach (var toy in filteredToys)
            {
                toy.DisplayInfo();
            } //Вывод списка, отсортированного по возрасту

            //Task 4.4
            //Number 1
            Console.WriteLine("\nTASK 4.4");
            int size = 7; 
            DerivedArray array = new DerivedArray(size); //Создание объекта класса с заданным размером
            for (int i = 0; i < size; i++)
            {
                array[i] = i;
            } //Заполнение массива числами

            array.PrintArray(); //Вызов метода для принта массива

            Console.WriteLine($"Element with index of 5: {array[5]}"); //Проверка индексатора
            Console.ReadKey(true);
        }
    }
}
