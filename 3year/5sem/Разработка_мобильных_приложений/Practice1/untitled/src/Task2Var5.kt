import kotlin.math.*

fun function1(x: Double, d: Double, c: Double): Double {
    val y = sin(x.pow(5) + 5 * x.pow(4) - 1) + abs((x.pow(5) + 5 * x.pow(4) - 1)/(4 * sqrt(x.pow(5) + 5 * x.pow(4) - 1) + 1))
    return y
}

fun main() {
    print("Enter x: "); val x = readln().toDouble()
    print("Enter d: "); val d = readln().toDouble()
    print("Enter c: "); val c = readln().toDouble()
    print(function1(x, d, c))
}