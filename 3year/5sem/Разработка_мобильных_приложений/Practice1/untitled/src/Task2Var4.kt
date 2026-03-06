import kotlin.math.*

fun function(x: Double, d: Double, c: Double): Double {
    val y = (cos(abs(x + d*x.pow(2) - c*x)).pow(3))/(x.pow(7)+x) + atan(c*x.pow(3) + d*x.pow(2) - x)
    return y
}

fun main() {
    print("Enter x: "); val x = readln().toDouble()
    print("Enter d: "); val d = readln().toDouble()
    print("Enter c: "); val c = readln().toDouble()
    print(function(x, d, c))
}