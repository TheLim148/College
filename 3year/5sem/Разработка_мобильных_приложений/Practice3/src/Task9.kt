// Удаление знака собаки и символа за ней

fun main() {
    val text = "гр@оо@лк@оц@ва"
    var result = ""

    for (c in text) {
        if (c == '@') {
            if (result.isNotEmpty()) {
                result = result.dropLast(1)
            }
        } else {
            result += c
        }
    }
    println(result)
}