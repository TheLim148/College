// Получить все четырехзначные счастливые номера.
// Счастливым называется номер, у которого сумма первых двух цифр номера равна сумме последних двух цифр.
// Использовать функцию для расчета суммы цифр двухзначного числа.

fun sumTwoDigits(n: Int): Int {
    require(n in 0..99) { "Аргумент должен быть в диапазоне 0..99" }
    return n / 10 + n % 10
}

fun isLuckyNumber(n: Int): Boolean {
    require(n in 1000..9999) { "Ожидалось четырехзначное число" }
    val left = n / 100
    val right = n % 100
    return sumTwoDigits(left) == sumTwoDigits(right)
}

fun generateLuckyFourDigitNumbers(): List<Int> =
    (1000..9999).asSequence().filter(::isLuckyNumber).toList()

fun chunkedPrint(nums: List<Int>, perLine: Int = 10) {
    nums.chunked(perLine).forEach { println(it.joinToString(" ")) }
}

fun main() {
    val lucky = generateLuckyFourDigitNumbers()
    println("Четырехзначные счастливые номера (всего: ${lucky.size}):")
    chunkedPrint(lucky, perLine = 15)
}