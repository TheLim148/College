// Нахождение подстроки в строке

fun main() {
    val st = "пепАбвва"
    val subst = "абв"

    if (st.lowercase().contains(subst.lowercase())) {
        println("Есть контакт!")
    } else {
        println("Мимо!")
    }
}