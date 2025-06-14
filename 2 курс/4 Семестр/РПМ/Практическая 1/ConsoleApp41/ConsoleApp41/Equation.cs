using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp41
{
    class Equation
    {
        private const int infinity = Int32.MaxValue;
        private double a, b, c = 0;
        private int count = -1;
        private double x1, x2;

        public Equation(params double[] coef)
        {
            switch (coef.Length)
            {
                case 3:
                    a = coef[0];
                    b = coef[1];
                    c = coef[2];
                    break;
                case 2:
                    a = coef[0];
                    b = coef[1];
                    break;
                case 1:
                    a = coef[0];
                    break;
                case 0:
                    break;
                default:
                    throw new Exception("Некорректный набор коэффициентов");
            }
        }
        public void Solve()
        {
            if (a == 0)
            {
                if (b == 0)
                {
                    if (c == 0)
                    {
                        count = infinity;
                    }
                    else
                    {
                        count = 0;
                    }
                }
                else
                {
                    LinSolve();
                }
            }
            else
            {
                QSolve();
            }
        }
        public void QSolve()
        {
            double disc = Math.Pow(b, 2) - 4 * a * c;
            if (disc < 0)
            {
                count = 0;
            }
            else if (disc == 0)
            {
                count = 1;
                x1 = -b / 2 * a;
            }
            else
            {
                count = 2;
                x1 = (-b + Math.Sqrt(disc)) / 2 * a;
                x2 = (-b - Math.Sqrt(disc)) / 2 * a;
            }
        }
        public void LinSolve()
        {
            count = 1;
            x1 = -c / b;
        }
        public double A
        {
            get { return a; }
            set { a = value; }
        }
        public double B
        {
            get { return b; }
            set { b = value; }
        }
        public double C
        {
            get { return c; }
            set { c = value; }
        }
        public int Count
        {
            get { return count; }
        }
        public double this[int i]
        {
            get
            {
                if (count == -1)
                {
                    throw new Exception("Уравнение ещё не решено");
                }
                if ((count == 1 || count == 2) && i == 1)
                {
                    return x1;
                }
                if (count == 2 && i == 2)
                {
                    return x2;
                }
                throw new Exception("Уравнение не имеет корня с номером " + i);
            }
        }
        public void PrintSolution()
        {
            switch (count)
            {
                case -1:
                    {
                        Console.WriteLine("Операция не проводилась");
                        break;
                    }
                case 0:
                    {
                        Console.WriteLine("У тебя нет корней");
                        break;
                    }
                case 1:
                    {
                        Console.WriteLine($"{count} корень: {x1}");
                        break;
                    }
                case 2:
                    {
                        Console.WriteLine($"{count} корней: {x1} и {x2}");
                        break;
                    }
                default:
                    {
                        throw new Exception("Непредсказуемое количество коэффициентов");
                    }
            }
            Console.WriteLine();
        }
    }
}
