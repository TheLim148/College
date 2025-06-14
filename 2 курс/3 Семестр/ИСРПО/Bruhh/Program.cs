/*
string binary = "1010";
int decimalNumber = Convert.ToInt32(binary, 2);
Console.WriteLine(decimalNumber);
*/

/*
int decimalNum = 255;
string hex = Convert.ToString(decimalNum, 16);
Console.WriteLine(hex);
*/

/*
string binary = "101010";
int decimalNumber = Convert.ToInt32(binary, 2);
string hex = Convert.ToString(decimalNumber, 16);
Console.WriteLine(hex);
*/

//Task 6.1
/*
int a = 5;
int b = 9;

Console.WriteLine($"Before swap: a = {a}, b = {b}");

a ^= b;
b = a ^ b;
a ^= b;

Console.WriteLine($"After swap: a = {a}, b = {b}");
*/

/*
int MyInteger = 10;
double MyDouble = 5.75;
char MyChar = 'A';
string MyString = "Hello, World!";
bool MyBool = true;

Console.WriteLine(MyInteger);
Console.WriteLine(MyDouble);
Console.WriteLine(MyChar);
Console.WriteLine(MyString);
Console.WriteLine(MyBool);
*/

/*
int num1 = 15;
int num2 = 4;

int sum = num1 + num2;
int dif = num1 - num2;
int prod = num1 * num2;
int quot = num1 / num2;
int rem = num1 % num2;

Console.WriteLine($"Sum: {sum}");
Console.WriteLine($"Difference: {dif}");
Console.WriteLine($"Product: {prod}");
Console.WriteLine($"Quotient: {quot}");
Console.WriteLine($"Remainder: {rem}");
*/

/*
int a = 6;
int b = 3;

int andResult = a & b;
int orResult = a | b;
int xorResult = a ^ b;
int notResult = ~a;
int shiftRight = a << 1;
int shiftLeft = a >> 1;

Console.WriteLine("AND Result: " + andResult);
Console.WriteLine("OR Result: " + orResult);
Console.WriteLine("XOR Result: " + xorResult);
Console.WriteLine("NOT Result: " + notResult);
Console.WriteLine("Shift Right Result: " + shiftRight);
Console.WriteLine("Shift Left Result: " + shiftLeft);
*/

/*
int num = 10;
double doubleNUm = num;
Console.WriteLine("Double: " + doubleNUm);

double myDouble = 9.78;
int myInt = (int) myDouble;
Console.WriteLine("Int: " + myInt);
*/

//Task 6.2
/*
int a = Convert.ToInt32(Console.ReadLine());
string binary = Convert.ToString(a, 2);
string hex = Convert.ToString(a, 16);
Console.WriteLine("Decimal: " + a);
Console.WriteLine("Binary: " + binary);
Console.WriteLine("Hex: " + hex);
*/

//Task 6.3
/*
string binary = "101010";
int octal = Convert.ToInt32(binary, 2);
Console.WriteLine(Convert.ToString(octal, 8));
*/

/*
double power = Math.Pow(2, 3);
double sqrt = Math.Sqrt(16);
double absolute = Math.Abs(-10);
double sinValue = Math.Sin(Math.PI / 2);
double rounded = Math.Round(3.14159, 4);

Console.WriteLine(power);
Console.WriteLine(sqrt);
Console.WriteLine(absolute);
Console.WriteLine(sinValue);
Console.WriteLine(rounded);
*/
