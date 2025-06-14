using System;
using System.Threading.Tasks;
class Program4
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
      
        Console.WriteLine("Целочисл. массив:");
        int[] intArray = CArray(10, 15);
        ShowArray(intArray);
        Console.WriteLine();
        Console.WriteLine("________________________________________");
        Console.WriteLine("Символьный массив:");
        char[] chArray = CArray('A', 'B');
        ShowArray(chArray);
    }
}