// Вариант 13, задания 1 и 3
// Склонение рублей

fun main() {
    val number: Int = readln().toInt()
    when(number){
        1 -> print("$number рубль")
        in 2..4 -> print("$number рубля")
        in 5..100 -> print("$number рублей")
        else -> print("Чересчур богатый?")
    }
}
