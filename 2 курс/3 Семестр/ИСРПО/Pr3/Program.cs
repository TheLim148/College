//Task1
/*
Random rnd = new Random();
Console.WriteLine("Enter n: "); int n = Convert.ToInt32(Console.ReadLine());
int[] nums = new int[n];

for(int i = -1; i < n-1; i++)
{
    int number = rnd.Next(0, 100); 
    nums[i+1] = number;
}

foreach(int numbers in nums)
{
    Console.WriteLine(numbers);
}


void maxValue()
{
    Console.WriteLine(nums.Max());
}

void minValue()
{
    Console.WriteLine(nums.Min());
}

void Summa()
{
    Console.WriteLine(nums.Sum());
}

void Middle()
{
    Console.WriteLine(nums.Sum()/nums.Length);
}

Console.WriteLine("Max Value of Array "); maxValue();
Console.WriteLine("Min Value of Array "); minValue();
Console.WriteLine("Sum of Array "); Summa();
Console.WriteLine("Middle Value of Array "); Middle();
*/

//Task2
/*
Random rnd = new Random();
Console.WriteLine("Enter a: "); 
int a = Convert.ToInt32(Console.ReadLine());
int u = 2;
int j = 0;
int count = 0;

int[] nums = new int[a];
int[] primeNums = new int [count+1];

for(int i = -1; i < a-1; i++)
{
    int number = rnd.Next(0, 10);
    nums[i+1] = number;
    
    
}


foreach(int numbers in nums)
{
    
    Console.WriteLine(numbers);
}





/////////////////////////////
while (u*u <= n && j != 1) 
{
    if (n % u == 0)
    {
        j = 1;
        u++;
    }
    u++;

}
if (j  == 1)
{
    Console.WriteLine($"Number {n} is not prime");
}
else
{
    Console.WriteLine($"Number {n} is prime");
}


while (u*u <= numbers && j != 1) 
    {
        if (numbers % u == 0)
        {
            j = 1;
            u++;
        }
        u++;

    }
    if (j  == 1)
    {
        Console.WriteLine($"Number {numbers} is not prime");
    }
    else
    {
        primeNums[count+1] = numbers;
        Console.WriteLine($"Number {numbers} is prime");
        count++;
        
    }
*/

//Task3
/*
public class Strings
{
    static string Longest(string[] strings)
    {
        string longest = strings[0];
        foreach (string s in strings)
        {
            if (s.Length > longest.Length)
            {
                longest = s;
            }
        }
        return longest;
    }

    static int Count(string[] strings, int search)
    {
        int count = 0;
        foreach (string s in strings)
        {
            if (s.Length > search)
            {
                count++;
            }
        }
        return count;
    }
    static void Main()
    {
        Console.WriteLine("Enter strings separated by commas: ");
        string[] inputStrings = Console.ReadLine().Split(',');
        Console.WriteLine("Enter the string length to check ");
        int inputNumber = int.Parse(Console.ReadLine());

        Console.WriteLine("The longest string: " + Longest(inputStrings));
        Console.WriteLine("Amount of strings which length greater than " + inputNumber + ": " + Count(inputStrings, inputNumber));

    }
}
*/

//Task4
/*
public class Nums
{
    static int Count(int[] numbers, int search)
    {
        int count = 0;
        foreach (int n in numbers)
        {
            if (n > search)
            {
                count++;
            }
        }
        return count;
    }

    static void Main()
    {
        Console.WriteLine("Enter integers separated by commas: ");
        string[] inputNums = Console.ReadLine().Split(',');
        Console.WriteLine("Enter the string length to check ");
        int inputNumber = int.Parse(Console.ReadLine());

        Console.WriteLine("Amount of strings which length greater than " + inputNumber + ": " + Count(inputNums, inputNumber));

    }
}
*/

//Task5
/*
public class Sum
{
    static int Summa(int number)
    {
        int sum = 0;
        number = Math.Abs(number);

        while(number > 0)
        {
            sum += number % 10;
            number /= 10;
        }
        return sum;
    }
    public static void Main()
    {
        Console.WriteLine("Enter integer: ");
        int input = int.Parse(Console.ReadLine());

        Console.WriteLine("Sum of the digits of a number: " + Summa(input));
    }
}
*/