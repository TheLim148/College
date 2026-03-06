fun pie(numberOfPies: Int): Double {
    var rubles = 1
    var kopecks = 0.2

    val sum = rubles + kopecks

    return numberOfPies * sum
}

fun main() {
    print("How many pies you want to buy?: ")
    val amount = readln().toInt()
    print(pie(amount))
}