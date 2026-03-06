import kotlin.math.pow

fun numberOfDigits(number: Int): Int {
    var sum = 0
    var n = number
    while (n != 0) {
        n /= 10
        sum++
    }
    return sum
}

fun foo(number: Int, k: Int): Int {
    if (numberOfDigits(number) < k) {
        print("$number must contain more digits than $k")
        return -1
    }
    else {
        var divider = 10.0.pow(k).toInt()
        return number / divider

    }

}

fun main() {
    print("Enter number: ")
    val number = readln().toInt()
    print("Enter k: ")
    val k = readln().toInt()
    print(foo(number, k))
}