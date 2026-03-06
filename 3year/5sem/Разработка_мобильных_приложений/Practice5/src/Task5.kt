// Поиск всех анаграмм

fun findAnagrams(word: String, candidates: List<String>): List<String> {
    val base = word.lowercase()
    val baseKey = base.toCharArray().sorted()

    return candidates.filter { cand ->
        val c = cand.lowercase()
        c != base && c.length == base.length && c.toCharArray().sorted() == baseKey
    }
}

fun main() {
    val word = "listen"
    val candidates = listOf("enlist", "google", "inlets", "banana")
    val result = findAnagrams(word, candidates)
    println(result)
}