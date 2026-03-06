//Задача 6: Определение уникальных и пересекающихся элементов. Решить только с использованием встроенных функций
//Предположим, у вас есть два списка целых чисел, представляющих наборы оценок двух различных групп студентов.
// Ваша задача — написать функцию, которая выполняет следующие действия:
//Находит уникальные оценки из обоих списков (т.е. оценки, которые присутствуют только в одном из списков).
//Находит пересечение оценок (т.е. оценки, которые присутствуют в обоих списках).
//Возвращает результаты в виде пары: первое значение — это множество уникальных оценок, а второе — множество пересечений.

fun uniqueIntersection(firstArray: Array<Int>, secondArray: Array<Int>) {
    val uniqueFirst = ArrayList<Int>()
    for (num in firstArray) {
        if (!uniqueFirst.contains(num)) uniqueFirst.add(num)
    }

    val uniqueSecond = ArrayList<Int>()
    for (num in secondArray) {
        if (!uniqueSecond.contains(num)) uniqueSecond.add(num)
    }

    val commonElements = ArrayList<Int>()
    for (num in uniqueFirst) {
        if (uniqueSecond.contains(num) && !commonElements.contains(num)) {
            commonElements.add(num)
        }
    }

    val onlyInOne = ArrayList<Int>()
    for (num in uniqueFirst) {
        if (!uniqueSecond.contains(num) && !onlyInOne.contains(num)) {
            onlyInOne.add(num)
        }
    }
    for (num in uniqueSecond) {
        if (!uniqueFirst.contains(num) && !onlyInOne.contains(num)) {
            onlyInOne.add(num)
        }
    }

    println("Уникальные значения: ${onlyInOne.joinToString()}")
    println("Пересекающиеся значения: ${commonElements.joinToString()}")
}

fun main() {
    val firstArray = arrayOf(85, 90, 78, 92, 85)
    val secondArray = arrayOf(88, 90, 95, 78, 85)

    println("Первый массив: ${firstArray.joinToString()}")
    println("Второй массив: ${secondArray.joinToString()}")
    uniqueIntersection(firstArray, secondArray)
}
