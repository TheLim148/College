// Разделение строки на левую и правую части 

fun main() {
    print("Enter string: ")
    val text = readln()
    val n = text.length
    if (n % 2 == 0) {
        val left = text.slice(0 until n / 2)
        val right = text.slice(n / 2 until n)
        println(right + left)
    } else {
        val left = text.slice(0 until n / 2)
        val middle = text[n / 2]
        val right = text.slice(n / 2 + 1 until n)
        println(right + middle + left)
    }
}