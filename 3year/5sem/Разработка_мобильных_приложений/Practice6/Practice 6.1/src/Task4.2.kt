// Задача 4: Максимальная разница
// Создайте массив из 100 случайных целых чисел в диапазоне от -100 до 100.
// Найдите максимальную разницу между двумя элементами массива, где больший элемент находится после меньшего.

import kotlin.random.Random

fun maxDiffManual(arr: Array<Int>): Int {
    var minValue = arr[0]
    var maxDiff = Int.MIN_VALUE

    for (i in 1 until arr.size) {
        val diff = arr[i] - minValue
        if (diff > maxDiff) maxDiff = diff
        if (arr[i] < minValue) minValue = arr[i]
    }
    return maxDiff
}

fun main() {
    val arr = Array(100) { Random.nextInt(-100, 101) }
    println("Массив: ${arr.contentToString()}")
    val result = maxDiffManual(arr)
    println("Максимальная разница: $result")
}
