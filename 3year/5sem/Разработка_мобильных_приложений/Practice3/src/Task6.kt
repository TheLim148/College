// Удаление содержимого скобок

fun main() {
    val text = "Hi, (how are) you?"
    var result = ""
    var inside = false

    for (c in text) {
        if (c == '(') {
            inside = true
        } else if (c == ')') {
            inside = false
        } else if (!inside) {
            result += c
        }
    }
    println(result)
}