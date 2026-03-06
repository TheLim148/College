

fun main() {
    val list: List<Int> = listOf(1, 2, 3, 4, 5, 6, 7, 8)
    val mList: MutableList<Int> = mutableListOf(1, 2, 3, 4, 5, 6, 7, 8)

    val set: Set<String> = setOf("apple", "banana", "apricot", "blueberry", "cherry", "avocado")
    val mSet: MutableSet<String> = mutableSetOf("apple", "banana", "apricot", "blueberry", "cherry", "avocado")

    val map: Map<String, Int> = mapOf(
        "alice" to 21,
        "bob" to 17,
        "carol" to 30,
        "dave" to 17
    )    
    val mMap: MutableMap<String, Int> = mutableMapOf(
        "alice" to 21,
        "bob" to 17,
        "carol" to 30,
        "dave" to 17
    )

    // list functions
    val hasGreater5 = list.any { it > 5}
    println("$hasGreater5")

    val allPositive = list.all { it > 0 }
    println("$allPositive")

    val squared = list.map { it * it }
    println("$squared")

    val evens = list.filter { it % 2 == 0 }
    println("$evens")

    val windows = list.windowed(size = 3, step = 2, partialWindows = false)
    println("$windows\n")

    // set functions
    val grouped = set.groupBy { it.first() }
    println("$grouped")

    val startsWithA = set.filter { it.startsWith('a') }
    println("$startsWithA")

    val length = set.map { it.length }
    println("$length")

    val anyLong = set.any { it.length > 6 }
    println("$anyLong")

    val joined = set.joinToString(", ")
    println("$joined\n")

    // map functions
    map.forEach { (k, v) -> print("[$k : $v]") }
    println()

    val plusOne = map.mapValues { it.value + 1 }
    println("$plusOne")

    val keysGreater4 = map.filterKeys { it.length >= 4 }
    println("$keysGreater4")

    val adults = map.filterValues { it >= 18 }
    println("$adults")

    val sortedByAge = map.entries.sortedBy { it.value }.map { it.key to it.value }
    println("$sortedByAge")
}