// Создайте массив из 30 строк. Перемешайте элементы массива
// случайным образом и выведите результат.

fun main() {
    val list = ArrayList<String>(30)
    for (i in 1..30) list.add("i_$i")
    list.shuffle()
    println("Массив: ${list.joinToString()}")
}