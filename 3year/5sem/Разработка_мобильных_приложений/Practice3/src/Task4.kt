// Самые популярные символы

fun main() {
    val text = "Карл у Клары украл кораллы"
    val symbols = listOf('к', 'а', 'р', 'л', 'у', 'ы', 'о')
    for (s in symbols) {
        val count = text.lowercase().count { it == s }
        println("$s – $count")
    }
}