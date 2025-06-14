using System;
using System.Collections.Generic;
using System.IO;

namespace DebuggingPractice
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Расширенный калькулятор:");
            int a = 10;
            int b = 5;
            Console.WriteLine("Сложение: " + Calculator(a, b, '+'));
            Console.WriteLine("Разность: " + Calculator(a, b, '-'));
            Console.WriteLine("Умножение: " + Calculator(a, b, '*'));
            Console.WriteLine("Деление: " + Calculator(a, b, '/'));
            Console.WriteLine("Возведение в степень: " + Calculator(a, -2, '^'));

            int[] numbers = { 1, 100, 2, 3, 4, -20, 5, 6 };
            Console.WriteLine("Минимум: " + FindMin(numbers));
            Console.WriteLine("Максимум: " + FindMax(numbers));
            Console.WriteLine("Среднее значение: " + FindAverage(numbers));

            List<int> list = GenerateRandomNumbers(10, 1, 11);
            Console.WriteLine("Список чисел: " + string.Join(", ", list));

            int search = 3;
            if (FindInList(list, search) == true)
            {
                Console.WriteLine("Число " + search + " найдено: " + FindInList(list, search));
            }
            else { Console.WriteLine("Число " + search + " не найдено: "); }


            Console.WriteLine("Введите число для вычисления факториала:");
            int fact = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine("Факториал числа: " + Factorial(fact));

            Console.WriteLine("Проверка на простое число. Введите значение: ");
            int prime = Convert.ToInt32(Console.ReadLine());
            if (IsPrime(prime) == true)
            {
                Console.WriteLine("Число " + prime + " простое");
            }
            else
            {
                Console.WriteLine("Число " + prime + " не простое");
            }
        }

        static double Calculator(double x, double y, char op)
        {
            switch (op)
            {
                case '+': return x + y;
                case '-': return x - y;
                case '*': return x * y;
                case '/':
                    if (y != 0)
                    {
                        return x / y;
                    }
                    else
                    {
                        throw new DivideByZeroException("Деление на 0");
                    }
                case '^': return Math.Pow(x, y);
                default: throw new InvalidOperationException("Недопустимая операция");
            }
        }

        static int FindMin(int[] arr)
        {
            int Min = 1000000;
            for (int i = 0; i < arr.Length; i++)
            {

                if (Min > arr[i])
                {
                    Min = arr[i];
                }
            }
            return Min;
        } 
        static int FindMax(int[] arr)
        {
            int Max = -1000000;
            for (int i = 0; i < arr.Length; i++)
            {
                
                if (Max < arr[i])
                {
                    Max = arr[i];
                }
            }
            return Max;
        }
        static double FindAverage(int[] arr)
        {
            double sum = 0;
            for (int i = 0; i < arr.Length; i++)
            {
                sum += arr[i];
            }
            return sum / arr.Length; 
        }

        static List<int> GenerateRandomNumbers(int count, int min, int max)
        {
            Random rand = new Random();
            List<int> numbers = new List<int>();
            int num;
            
            for (int i = 0; i < count; i++)
            {
                do
                {
                    num = rand.Next(min, max);
                    if (!(numbers.Contains(num)))
                        break;
                } while (numbers.Contains(num));
                numbers.Add(num);
            }
            return numbers;
        }

        static bool FindInList(List<int> list, int target)
        {
            foreach (var item in list)
                if (item == target)
                {
                    return true;
                }
                return false;
        }
        static long Factorial(long n)
        {
            long n1 = n;
            long factorial = 1;
            for (int i = 1; i < n; i++)
            {
                factorial *= n1;
                n1 -= 1;
                if (factorial <= 1 || factorial > long.MaxValue)
                {
                    return 1;
                }
            }
            return factorial;
        }


        static bool IsPrime(int n)
        {
            if (n <= 1) return false;
            for (int i = 2; i < n; i++) 
            {
                if (n % i == 0) 
                {
                    return false;
                } 
            }
            return true;
        }
    }
}