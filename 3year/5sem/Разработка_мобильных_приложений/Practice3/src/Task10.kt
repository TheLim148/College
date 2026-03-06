// Проверка валидности электронной почты

fun main() {
    val email = "name@gmail.com"
    val regex = Regex("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,3}$")
    
    if (regex.matches(email)) {
        println("Да, \"$email\" валидный")
    } else {
        println("Нет, \"$email\" не валидный")
    }
}