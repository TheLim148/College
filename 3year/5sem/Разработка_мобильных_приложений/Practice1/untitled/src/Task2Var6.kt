import kotlin.math.*

fun function2(x: Double, d: Double, c: Double): Double {
    val y = sqrt(abs((x.pow(3) + x.pow(2) + x + 1)/((x.pow(3) + x.pow(2) + x + 1).pow(2) + 1))) - 12 * ((x.pow(3) + x.pow(2) + x + 1))/(11)
    return y
}

fun main() {
    print("Enter x: "); val x = readln().toDouble()
    print("Enter d: "); val d = readln().toDouble()
    print("Enter c: "); val c = readln().toDouble()
    print(function2(x, d, c))
}