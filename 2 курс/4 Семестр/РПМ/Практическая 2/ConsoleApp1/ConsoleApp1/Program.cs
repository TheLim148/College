using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    internal class Practice2
    {
        public static char[] CArray(char start, char end)
        {
            int Len = end - start + 1;
            char[] chArray = new char[Len];
            for (int i = 0; i < Len; i++)
            {
                chArray[i] = Convert.ToChar(start + i);
            }
            return chArray;
        }

        public static int[] CArray(int start, int end)
        {
            int len = end - start + 1;
            int[] intArray = new int[len];
            for (int i = 0; i < len; i++)
            {
                intArray[i] = start + i;
            }
            return intArray;
        }

        public static void ShowArray(int[] array)
        {
            foreach (int num in array)
            {
                Console.Write(num + " ");
            }
        }


        public static void ShowArray(char[] array)
        {
            foreach (char ch in array)
            {
                Console.Write(ch + " ");
            }
        }
        static void Main(string[] args)
        {


            //Task 1
            Console.WriteLine("TASK 1");
            Class1 A = new Class1(42, "Text1");
            Class1 B = new Class1(13, "Text2");
            Class1 C = new Class1(150, "Text3");
            Class1 D = new Class1(-1, "Text4");
            Class1 E = new Class1(54, "Text5");

            Console.WriteLine(A > B);
            Console.WriteLine(A < B);
            Console.WriteLine(D == C);
            Console.WriteLine(E != A);
            Console.WriteLine(D >= B);
            Console.WriteLine(C <= B);
            Console.WriteLine(C.GetHashCode());

            //Task 2
            Console.WriteLine("\nTASK 2");
            Class2 A1 = new Class2(14);
            Class2 B1 = new Class2(14);
            Class2 C1 = new Class2(49);
            Class2 D1 = new Class2(53);

            if (A1 & B1)
            {
                Console.WriteLine("A1 & B1");
            }
            if (A1 | B1)
            {
                Console.WriteLine("A1 | B1");
            }
            if (A1)
            {
                Console.WriteLine("A1");
            }
            if (B1)
            {
                Console.WriteLine("B1");
            }

            //Task 3
            Console.WriteLine("\nTASK 3");
            Class3 A3 = new Class3("Text");
            Console.WriteLine(A3.ToString());
            Console.WriteLine(A3.ToChar());
            

            //Task 4
            Console.WriteLine("\nTASK 4");
            Console.WriteLine("\nInt Array: ");
            int[] intArray = CArray(10, 15);
            ShowArray(intArray);

            Console.WriteLine("\n\nChar Array: ");
            char[] charArray = CArray('A', 'G');
            ShowArray(charArray);

            Console.ReadKey(true);
        }
    }
}
