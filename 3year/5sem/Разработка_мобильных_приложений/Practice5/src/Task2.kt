import kotlin.math.pow

fun main() {
    val a = 0.1
    val b = 1.2
    val h = 0.1

    println("x\ty")

    var x = a
    while (x <= b + 1e-9) {
        val y = Sum(20, x)
        println("%.1f\t%.6f".format(x, y))
        x += h
    }
}

fun Sum(n: Int, x: Double): Double {
    return if (n == 1) {
        x.pow(0) / (2 * 1 + 1)
    } else {
        x.pow(n - 1) / (2 * n + 1) + Sum(n - 1, x)
    }
}