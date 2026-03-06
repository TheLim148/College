// Задача 2: Объединение массивов
// Создайте два массива из целых чисел (по 15 элементов в каждом).
// Объедините их в один массив, исключив дубликаты, и отсортируйте результат по возрастанию.
// Пример входных данных:
// Массив 1 - (5, 3, 8, 1, 2, 7, 4, 9, 6, 10, 3, 5, 2, 8, 1)
// Массив 2 - (15, 12, 11, 14, 13, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
// Выходные данные: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

fun contains(list: ArrayList<Int>, v: Int): Boolean {
    for (x in list) if (x == v) return true
    return false
}

fun bubbleSort(list: ArrayList<Int>) {
    for (i in 0 until list.size - 1) {
        for (j in 0 until list.size - i - 1) {
            if (list[j] > list[j + 1]) {
                val temp = list[j]
                list[j] = list[j + 1]
                list[j + 1] = temp
            }
        }
    }
}

fun main() {
    val a = arrayOf(5, 3, 8, 1, 2, 7, 4, 9, 6, 10, 3, 5, 2, 8, 1)
    val b = arrayOf(15, 12, 11, 14, 13, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

    val unique = ArrayList<Int>(a.size + b.size)
    for (x in a) if (!contains(unique, x)) unique.add(x)
    for (x in b) if (!contains(unique, x)) unique.add(x)

    bubbleSort(unique)

    println("Объединённый и отсортированный: $unique")
}
