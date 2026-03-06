// Вариант 13, задания 1 и 3
// Ввести цифру и получить номер дня недели

fun main() {
    val number: Int = readln().toInt()

    when(number) {
        1 -> print("Понедельник")
        2 -> print("Вторник")
        3 -> print("Среда")
        4 -> print("Четверг")
        5 -> print("Пятница")
        6 -> print("Суббота")
        7 -> print("Воскресенье")
        else -> print("Недели нет.")
    }
}