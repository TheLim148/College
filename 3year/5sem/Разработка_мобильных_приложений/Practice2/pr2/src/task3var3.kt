import kotlin.math.pow
import kotlin.math.floor

// Вариант 13, задания 1 и 3
// Равен ли квадрат двузначного числа учетвёренной сумме кубов его цифр

fun main() {
    val number: Int = readln().toInt()

    if(number in 10..99) {
        val quad_number = number.toDouble().pow(2).toInt()
        val first_digit = number % 10
        val second_digit = floor((number / 10).toDouble()).toInt()
        val foo = 4 * (first_digit.toDouble().pow(3) + second_digit.toDouble().pow(3)).toInt()
        if (foo == quad_number) {
            print("$quad_number $foo")
        }
    } else {
        print("$number is not 2-digit")
    }
}