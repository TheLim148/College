// Проверка на палиндром через срезы

fun main() {
    print("Enter word: ")
    val word = readln()
    val reversed = word.slice(word.indices.reversed())
    if (word == reversed) {
        println("Да, $word это палиндром")
    } else {
        println("Нет, $word это не палиндром")
    }
}