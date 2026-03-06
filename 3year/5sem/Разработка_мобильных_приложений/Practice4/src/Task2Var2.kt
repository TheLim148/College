// Число больше или меньше

import kotlin.random.Random

fun main() {
    val num = Random.nextInt(1, 100)
    var tries = 0
    var x = -1

    println("Угадай число от 1 до 100")

    while (x != 0 && x != num) {
        print("Вы ввели: ")
        x = readln().toInt()
        tries++

        if (x == 0) {
            println("Выход")
        } else if (x > num) {
            println("Загаданное число меньше")
        } else if (x < num) {
            println("Загаданное число больше")
        } else {
            println("Вы угадали за $tries попыток!")
        }
    }
}