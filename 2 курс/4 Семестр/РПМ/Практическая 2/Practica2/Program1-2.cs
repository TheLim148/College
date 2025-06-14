using System;
using System.CodeDom;
using System.Linq;
using System.Runtime.InteropServices;


namespace Practica_Peregruzka
{
    internal class Program
    {
        static void Main()
        {
            MyClass A= new MyClass(12,"HELLO");
            MyClass B = new MyClass(5, "H");
            MyClass D = new MyClass(12, "FVR");
            MyClass E = new MyClass(7, "DFVD");
            Console.WriteLine(A>B);
            Console.WriteLine(D <= B);
            Console.WriteLine(D == A);
            Console.WriteLine(D !=A );
            Console.WriteLine("______________________________");
            MyClass2 A2 = new MyClass2(5);
            MyClass2 B2 = new MyClass2(1);
            MyClass2 C2 = new MyClass2(12);
            MyClass2 D2 = new MyClass2(-90);
            if (A2 & B2)
            {
                Console.WriteLine("A2 & B2");
            }
            if (A2 | B2)
            {
                Console.WriteLine("A2 | B2");
            }
            if (A2)
            {
                Console.WriteLine("A2");
            }
            if (B2)
            {
                Console.WriteLine("B2");
            }


        }
    }
    class MyClass2
    {
        public int code;
        public MyClass2 (int code)
        {
            this.code = code;
        }
        static public bool operator true (MyClass2 a)
        {
            switch (a.code)
            {
                case 2:
                case 3:
                case 5:
                case 7:
                    return true;
                default:
                    return false;

            }
                
        }
        static public bool operator false(MyClass2 a)
        {
            
                if (a.code < 1 || a.code > 10)
                    return false;
                
                    return true;

            

        }
        static public MyClass2 operator&( MyClass2 a,  MyClass2 b)
        {

            if (a)
            {
                return b;
            }
            return a;
        }
        static public MyClass2 operator |(MyClass2 a, MyClass2 b)
        {

            if (a)
            {
                return a;
            }
            return b;
        }
    }
    class MyClass
    {
        public int code;
        public string txt;
        public MyClass(int code, string txt)
        {
            this.code = code;
            this.txt = txt;
        }

        static public bool operator== (MyClass x, MyClass y)
        {
            return (x.txt).Length == (y.txt).Length;
        }
        static public bool operator!=(MyClass x, MyClass y)
        {
            return (x.txt).Length != (y.txt).Length ;
        }
        static public bool operator <(MyClass x, MyClass y)
        {
            return (x.txt).Length < (y.txt).Length;
        }
        static public bool operator >(MyClass x, MyClass y)
        {
            return (x.txt).Length > (y.txt).Length;
        }
        static public bool operator>= (MyClass x, MyClass y)
        {
            return x.code >= y.code;
        }
        static public bool operator <=(MyClass x, MyClass y)
        {
            return x.code <= y.code;
        }
        override public int GetHashCode()
        {
            return code ^ txt[0];
        }
         public bool Equals(MyClass obj)
        {
            MyClass t;
            t = obj;
            if (t == this)
            {
                return true;
            }
            return false;
        }
    }

}
