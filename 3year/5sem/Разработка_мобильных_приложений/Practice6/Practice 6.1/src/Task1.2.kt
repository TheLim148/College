// Создайте массив из 30 строк.
// Перемешайте элементы массива случайным образом
// (используя функцию random - для решения задачи вторым способом) и выведите результат.

import kotlin.random.Random

fun main() {
    val list = ArrayList<String>(30)
    for (i in 1..30) list.add("i_$i")

    for (i in list.size - 1 downTo 1) {
        val j = Random.nextInt(i + 1)
        list[i] = list[j].also { list[j] = list[i] }
    }

    println("Перемешанный вручную: ${list.joinToString()}")
}