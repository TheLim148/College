// Вариант 13, задания 1 и 3
// Вводим число, получаем время года, к которому относиться месяц

fun main() {
    val number: Int = readln().toInt()

    when(number) {
        1 -> print("Зима")
        2 -> print("Зима")
        3 -> print("Весна")
        4 -> print("Весна")
        5 -> print("Весна")
        6 -> print("Лето")
        7 -> print("Лето")
        8 -> print("Лето")
        9 -> print("Осень")
        10 -> print("Осень")
        11 -> print("Осень")
        12 -> print("Зима")
        else -> print("Каникулы.")
    }
}