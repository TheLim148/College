// Вариант 13, задания 1 и 3
// Ввести стороны треугольника и вывести какой это треугольник

fun main()
{
    val a = readln().toDouble()
    val b = readln().toDouble()
    val c = readln().toDouble()

    if(a + b <= c || a + c <= b || b + c <= a) {
        print("Не существует")
    } else if(a == b && a == c) {
        print("Равносторонний")
    } else if (a == b || a == c || b == c) {
        print("Равнобедренный")
    } else {
        print("Разносторонний")
    }
}