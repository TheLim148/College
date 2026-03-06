fun main() {
    val arr: Array<Int> = arrayOf(5, 3, 9, 3, 1, 8, 2, 7, 4, 6)

    println("Исходный массив: ${arr.contentToString()}")

    // 1) map - применение функции к каждому элементу
    val mapped = arr.map { it * it }
    println("1) map (квадраты): $mapped")

    // 2) filter - отбор по предикату
    val filtered = arr.filter { it % 2 == 0 }
    println("2) filter (чётные): $filtered")

    // 3) any - хотя-бы один элемент, удовлетворяюший условию
    val anyGreater8 = arr.any { it > 8 }
    println("3) any (> 8): $anyGreater8")

    // 4) all - все элементы должны удовлетворять условию
    val allPositive = arr.all { it > 0 }
    println("4) all (> 0): $allPositive")

    // 5) count - количество элементов, удовлетворяющих условию
    val countOdd = arr.count { it % 2 != 0 }
    println("5) count (нечётных): $countOdd")

    // 6) find - первый подходящий элемент или null
    val firstGreaterThan6 = arr.find { it > 6 }
    println("6) find (> 6): $firstGreaterThan6")

    // 7) findLast - последний подходящий элемент или null
    val lastLessThan5 = arr.findLast { it < 5 }
    println("7) findLast (< 5): $lastLessThan5")

    // 8) indexOf - индекс первого вхождения
    val indexOf3 = arr.indexOf(3)
    println("8) indexOf(3): $indexOf3")

    // 9) lastIndexOf - индекс последнего вхождения
    val lastIndexOf3 = arr.lastIndexOf(3)
    println("9) lastIndexOf(3): $lastIndexOf3")

    // 10) firstOrNull - первый элемент
    val firstOr = arr.firstOrNull()
    println("10) firstOrNull: $firstOr")

    // 11) lastOrNull - последний элемент (или null)
    val lastOr = arr.lastOrNull()
    println("11) lastOrNull: $lastOr")

    // 12) sum - сумма элементов
    val sum = arr.sum()
    println("12) sum: $sum")

    // 13) average - среднее
    val avg = arr.average()
    println("13) average: $avg")

    // 14) minOrNull - минимум
    val minVal = arr.minOrNull()
    println("14) minOrNull: $minVal")

    // 15) maxOrNull - максимум
    val maxVal = arr.maxOrNull()
    println("15) maxOrNull: $maxVal")

    // 16) sorted - сортировка
    val sortedList = arr.sorted()
    println("16) sorted (List): $sortedList")

    // 17) sortedDescending - сортировка по убыванию
    val sortedDesc = arr.sortedDescending()
    println("17) sortedDescending (List): $sortedDesc")

    // 18) distinct - удаляет дубликаты
    val distinctVals = arr.distinct()
    println("18) distinct: $distinctVals")

    // 19) groupBy - группировка по ключу
    val grouped = arr.groupBy { if (it % 2 == 0) "even" else "odd" }
    println("19) groupBy (even/odd): $grouped")

    // 20) partition - разбиение на пару списков по предикату
    val (evens, odds) = arr.partition { it % 2 == 0 }
    println("20) partition -> evens: $evens, odds: $odds")
}