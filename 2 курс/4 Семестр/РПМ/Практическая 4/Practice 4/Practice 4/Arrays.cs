using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practice_4
{
    abstract class Array //Создание абстрактного класса
    {
        protected int[] array; //Защищённое поле с целочисленным массивом

        public Array(int size)
        {
            array = new int[size];
        } //Конструктор класса который задаёт размер массива

        public abstract void PrintArray(); //Обозначение абстракного метода для вывода массива

        public int this[int index]
        {
            get { return array[index]; }
            set { array[index] = value; }
        } //Индексатор
    }

    class DerivedArray : Array //Производный от абстрактного класса
    {
        public DerivedArray(int size) : base(size) { } //Вызов родительского конструктора
        public override void PrintArray() //Перезапись метода PrintArray
        {
            Console.Write("Array: ");
            for(int i = 0; i < array.Length; i++)
            {
                Console.Write(array[i] + " ");
            }
            Console.WriteLine(); //Вывод элементов массива в консоль
        }
    }
}
