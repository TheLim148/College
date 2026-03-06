// Функции

import kotlin.math.pow

fun main() {
    val a = 0.1
    val b = 1.2
    val h = 0.1

    println("")

    var x = a
    while(x <= b) {
        var y = 0.0
        for (n in 1..20) {
            y += x.pow(n - 1) / (2 * n + 1)
        }
        println("%.1f | %.6f".format(x, y))
        x += h
    }
}