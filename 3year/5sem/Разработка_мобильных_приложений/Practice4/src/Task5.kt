// Генерация пар

fun generateCombinations(elements: List<String>, combinationLength: Int): List<List<String>> {
    val result = mutableListOf<List<String>>()

    fun backtrack(start: Int, current: MutableList<String>) {
        if (current.size == combinationLength) {
            result.add(current.toList())
            return
        }
        for (i in start until elements.size) {
            current.add(elements[i])
            backtrack(i + 1, current)
            current.removeAt(current.size - 1)
        }
    }

    backtrack(0, mutableListOf())
    return result
}

fun main() {
    val elements = listOf("A", "B", "C", "D")
    val combinationLength = 2

    val combinations = generateCombinations(elements, combinationLength)

    println(combinations)
}
