// Двоичное число, введённое пользователем программы, преобразовать в десятичное число

fun main() {
    print("Введите двоичное число: ")
    val binary = readln()

    var i = binary.length - 1
    var base = 1
    var decimal = 0

    while(i >= 0) {
        val digit = binary[i] - '0'
        decimal += digit * base
        base *= 2
        i--
    }

    println("Десятичное число: $decimal")
}