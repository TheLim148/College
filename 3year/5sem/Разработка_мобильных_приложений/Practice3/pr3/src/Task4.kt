fun findMostFrequentChars(text: String): Map<Char, Int> {
    val charCount = text.groupingBy { it }.eachCount()
    val maxCount = charCount.maxByOrNull { it.value }?.value ?: 0
    if (maxCount == 0) {
        return emptyMap()
    }

    return charCount.filter { it.value == maxCount }
}

fun main() {
    val str = "Карл у Клары украл кораллы"
    println(findMostFrequentChars((str)))
}