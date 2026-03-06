fun main() {
    val list = arrayListOf(1, 2, 2, 3, 1, 4, 3, 5, 5)
    println("До удаления дубликатов: $list")

    val uniqueList = ArrayList(list.distinct())
    println("Список без дублей: $uniqueList")
}