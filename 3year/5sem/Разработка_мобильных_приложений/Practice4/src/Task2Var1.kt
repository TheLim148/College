// Кодовый замок

import kotlin.random.Random

fun main() {
    val code = Random.nextInt(100, 1000)
    println(code)
    var attempts = 5

    println("Кодовый замок. У вас $attempts попыток, чтобы отгадать 3-х значный код")
    println("Введите 0 для выхода")

    var input: Int

    while(true) {
        print("Введите число: ")
        input = readln().toInt()

        if(input == 0) {
            println("Программа завершена")
            break
        }

        if(input == code) {
            println("Добро пожаловать")
            break
        }

        attempts--
        if(attempts == 0) {
            println("Попыток больше не осталось. Замок заблокирован")
            break
        } else {
            println("Неверно. Осталось попыток $attempts")
        }
    }
}