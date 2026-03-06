// Индекс первого и последнего вхождения буквы

fun findIndex(letter: Char, st: String): String {
    val first = st.indexOf(letter)
    val last = st.lastIndexOf(letter)

    return "First iteration of $letter is $first. Last - $last"
}

fun main() {
    val str = "Карл у Клары украл кораллы"
    val str1 = "Карл".lowercase()
    print(findIndex('к', str))
}