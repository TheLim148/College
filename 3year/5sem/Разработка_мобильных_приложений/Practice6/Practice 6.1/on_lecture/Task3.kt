fun main() {
    val uniqueArray: Array<Int> = arrayOf(10, 4, 7, 1, 13, 2)
    
    val secondLargest = uniqueArray.sortedArrayDescending()[1]
    println("Уникальный массив: ${uniqueArray.contentToString()}")
    println("Второе по величине число: $secondLargest")
}