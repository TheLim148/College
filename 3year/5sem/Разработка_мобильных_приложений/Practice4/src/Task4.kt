// Осадки

fun main() {
    val thisYear = intArrayOf(
        2, 0, 1, 3, 0, 5, 0, 4, 2, 1,
        0, 0, 3, 2, 1, 0, 0, 6, 0, 1,
        2, 3, 0, 0, 1, 2, 4, 0
    )

    val lastYear = intArrayOf(
        0, 1, 0, 2, 0, 1, 3, 0, 0, 2,
        1, 0, 0, 1, 4, 0, 2, 0, 0, 1,
        0, 3, 1, 0, 0, 1, 0, 2
    )

    var sumThis = 0
    var sumLast = 0

    for (i in thisYear.indices) {
        sumThis += thisYear[i]
        sumLast += lastYear[i]
    }

    println("Осадки в этом году: $sumThis мм")
    println("Осадки в прошлом году: $sumLast мм")

    if (sumThis > sumLast) {
        println("Верно: в этом году выпало больше осадков.")
    } else {
        println("Неверно: в этом году не больше, чем в прошлом.")
    }
}