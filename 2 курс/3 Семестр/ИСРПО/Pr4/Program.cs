/*
class QuickSort
{
    public static void Sort(int [] arr, int left, int right)
    {
        if (left < right)
        {
            int pivot = Partition(arr, left, right);
            Sort(arr, left, pivot - 1);
            Sort(arr, pivot + 1, right);
        }
    }

    private static int Partition(int [] arr, int left, int right)
    {
        int pivot = arr[right];
        int i = left - 1;
        for (int j = left; j < right; j++)
        {
            if (arr[j] <= pivot)
            {
                i++;
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
        int temp1 = arr[i + 1];
        arr[i + 1] = arr[right];
        arr[right] = temp1;
        return i + 1;
    }

    static void Main()
    {
        int [] ints = { 8, 875, 7, 9, 764, 55 };
        Console.WriteLine("Array:");
        foreach (int i in ints)
        {
            Console.WriteLine(i);
        }
        Sort(ints, 0, 5);
        Console.WriteLine("Sorted array:");
        foreach (int i in ints)
        {
            Console.WriteLine(i);
        }
    }
}
*/

//Task1
/*
Console.WriteLine("Enter a: "); double a = Convert.ToDouble(Console.ReadLine()); 
Console.WriteLine("Enter h: "); double h = Convert.ToDouble(Console.ReadLine());
Console.WriteLine("Enter r: "); double r = Convert.ToDouble(Console.ReadLine());
Console.WriteLine("Enter m: "); double m = Convert.ToDouble(Console.ReadLine());

double one = a*a*a;
double two = Math.PI*r*r*h;

if (one>=m && two>=m)
{
    Console.WriteLine("Жидкость поместится в обе ёмкости");
    if (one>=m && two<m)
    {
        Console.WriteLine("Жидкость поместится только в кубическую ёмкость");
        if (one == m)
        {
            Console.WriteLine("Жидкость поместится только в циллиндрическую ёмкость");
            if (one<m && two<m)
            {
                Console.WriteLine("Жидкость никуда не поместится");
            }
        }
    }
}
*/

//Task2
/*
Random rnd = new Random();

Console.WriteLine("Введите размерность массива");
int n = Convert.ToInt32(Console.ReadLine());
int[] arr1 = new int[n];

Console.WriteLine("\n\n");
for(int i = 0; i < n; i++) {
    arr1[i] = rnd.Next(-20, 30);
    Console.Write($"{arr1[i],4}  ");
}
Console.WriteLine();

int maxIndex = Array.LastIndexOf(arr1, arr1.Max());
int minIndex = Array.IndexOf(arr1, arr1.Min());
int tmp = arr1[maxIndex];
arr1[maxIndex] = arr1[minIndex];
arr1[minIndex] = tmp;

for(int i = 0; i < n; i++) {
    Console.Write($"{arr1[i],4}  ");
}
*/

//Task3
/*
public class  Matrix
{
    public static void Main()
    {
        int[][] arr1 = {
            new int[] {1, 9, 4},
            new int[] {2, 4, 3},
            new int[] {7, 6, 5}
        };
        Console.WriteLine(arr1.Max(x=>x.Average()));
////////////////////////////////////////////////////////////////////
        Random rnd = new Random();

        Console.WriteLine("Введите размерность массива(N x M) ");
        int n = Convert.ToInt32(Console.ReadLine());
        int m = Convert.ToInt32(Console.ReadLine());
        int[,] arr1 = new int[n, m];
        
        for (int i=0; i < arr1.GetLength(0); i++)
        {
            for (int j=0; j < arr1.GetLength(1); j++)
            {
                arr1[i, j]=rnd.Next(0, 30);
                Console.Write(arr1[i, j] + " ");
            }
        } 
///////////////////////////////////////////////////////////////////
    }
}
*/
