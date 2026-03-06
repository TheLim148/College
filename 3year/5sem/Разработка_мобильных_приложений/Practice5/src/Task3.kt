// Сортировка массива и бинарный поиск

import kotlin.random.Random

fun fillArray(size: Int, min: Int, max: Int): IntArray {
    val array = IntArray(size)
    for (i in 0 until size) {
        array[i] = Random.nextInt(min, max + 1)
    }

    return array
}

fun sortArray(array: IntArray): IntArray {
    val sorted = array.copyOf()
    sorted.sort()
    return sorted
}

fun binarySearch(array: IntArray, target: Int): Boolean {
    var left = 0
    var right = array.size - 1

    while (left <= right) {
        val mid = (left + right) / 2
        if (array[mid] == target) {
            return true
        } else if (array[mid] < target) {
            left = mid + 1
        } else {
            right = mid -1
        }
    }
    return false
}

fun main() {
    print("Введите размер массива: ")
    val size = readln().toInt()

    print("Введите минимальное значение диапазона: ")
    val min = readln().toInt()

    print("Введите максимальное значение диапазона: ")
    val max = readln().toInt()

    val array = fillArray(size, min, max)
    println("Исходный массив: ${array.joinToString(", ")}")

    val sortedArray = sortArray(array)
    println("Отсортированный массив: ${sortedArray.joinToString(", ")}")

    print("Введите число для поиска: ")
    val target = readln().toInt()

    val found = binarySearch(sortedArray, target)

    if (found)
        println("Число $target найдено в массиве.")
    else
        println("Число $target не найдено.")
}