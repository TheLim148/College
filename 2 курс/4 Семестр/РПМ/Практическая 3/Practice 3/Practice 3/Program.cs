using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practice_3
{
    public class Program
    {
        static void Main(string[] args)
        {
            //Task 1
            Console.WriteLine("Task 1");
            MyClass1 class1 = new MyClass1(1, 9);
            class1.first = 1;
            class1.last = 2;
            Console.WriteLine(class1.Number + "\n");

            //Task 2
            Console.WriteLine("Task 2");
            MyClass2 class2 = new MyClass2(128);
            Console.WriteLine("Binary number: " + class2.ToString() + '\n');

            //Task 3
            Console.WriteLine("Task 3");
            MyClass3 class3 = new MyClass3();
            Console.WriteLine("Initial content: " + class3.content);

            class3.Element = 42;
            class3.Element = 14;
            class3.Element = 66;;
            Console.WriteLine("After adding some elements: " + class3.content);

            int[] A = class3.Data;
            Console.WriteLine("Content of an array A: " + "{" + string.Join(", ", A) + "}");
            class3.Element = 20;
            Console.WriteLine("Content after adding element: " + class3.content);

            int[] B = {1, 2, 3, 4};
            class3.Data = B;
            Console.WriteLine("After assignment new array B: " + class3.content);

            B[0] = 0;
            Console.WriteLine("Changed first element of array: " + class3.content + "\n");

            //Task 4
            Console.WriteLine("Task 4");
            MyClass4 class4 = new MyClass4('A');

            Console.WriteLine("Start value: " + class4[0]);

            for(int i = 1; i < 10; i++)
            {
                Console.WriteLine("Increment: " + (class4[0] + i));
            }

            class4[0] = 'B';
            Console.WriteLine("New value 'B': " + class4[0]);

            class4[-1] = 67;
            Console.WriteLine("Assignment a negarive index: " + class4[0] + "\n");

            //Task 5
            Console.WriteLine("Task 5");
            MyClass5 class5 = new MyClass5(5, 5);
            Console.WriteLine("Empty array: ");
            class5.PrintArray();

            Console.WriteLine();
            class5[0, 0] = 'A';
            class5[1, 1] = 'B';
            class5[2, 2] = 'C';
            class5[3, 3] = 'D';
            class5[4, 4] = 'E';
            Console.WriteLine("Array after adding symbols: ");
            class5.PrintArray();

            Console.WriteLine();
            class5[0, 0] = 'F';
            class5[1, 1] = 'G';
            Console.WriteLine("Array after override previous values");
            class5.PrintArray();

            Console.ReadKey(true);
        }
    }
}
