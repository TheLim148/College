// Задача 4: Максимальная разница
// Создайте массив из 100 случайных целых чисел в диапазоне от -100 до 100.
// Найдите максимальную разницу между двумя элементами массива, где больший элемент находится после меньшего.

import kotlin.random.Random

fun maxDiffBuiltIn(arr: Array<Int>): Int {
    var maxDiff = Int.MIN_VALUE

    for (i in arr.indices) {
        val rightPart = arr.drop(i + 1)
        if (rightPart.isEmpty()) continue

        val maxAfter = rightPart.maxOrNull()!!
        val diff = maxAfter - arr[i]

        if (diff > maxDiff) {
            maxDiff = diff
        }
    }

    return maxDiff
}


fun main() {
    val arr = Array(100) { Random.nextInt(-100, 101) }
    println("Массив: ${arr.contentToString()}")
    val result = maxDiffBuiltIn(arr)
    println("Максимальная разница: $result")
}
