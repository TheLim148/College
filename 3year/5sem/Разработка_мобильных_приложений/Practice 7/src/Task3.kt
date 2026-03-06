//Cоздайте класс Authorisation
//Поля (все приватные) Логин Пароль
//Методы
//Проверка логина на валидность (с использованием регулярного выражения)
//Проверка пароля на наличие спецсимволов, на соответствие длине
//Проверка каждого поля на пустоту
//Метод клик (условное нажатие на кнопку),
//который делает вышеуказанные проверки и выводит по одному предупреждению на каждое поле

class Authorisation(private var login: String, private var pass: String) {

    private fun empty(s: String): Boolean {
        return s.isEmpty()
    }

    private fun checkLogin(s: String): Boolean {
        val reg = Regex("^[A-Za-z][A-Za-z0-9_]{2,15}$")
        return reg.matches(s)
    }

    private fun hasSpec(s: String): Boolean {
        val spec = "!@#\$%^&*()-_=+[]{};:,.?/"
        var i = 0
        while (i < s.length) {
            if (spec.indexOf(s[i]) >= 0) {
                return true
            }
            i++
        }
        return false
    }

    private fun checkPass(s: String): Boolean {
        if (s.length < 6) {
            return false
        }
        if (!hasSpec(s)) {
            return false
        }
        return true
    }

    fun click() {
        if (empty(login)) {
            println("Логин пустой")
        } else if (!checkLogin(login)) {
            println("Логин некорректен")
        } else {
            println("Логин корректен")
        }

        if (empty(pass)) {
            println("Пароль пустой")
        } else if (!checkPass(pass)) {
            println("Пароль некорректен")
        } else {
            println("Пароль корректен")
        }
    }

    fun setData(newLogin: String, newPass: String) {
        login = newLogin
        pass = newPass
    }
}

fun main() {
    val a = Authorisation("user_1", "qwerty")
    a.click()
    a.setData("Alex_2025", "Qwe!23")
    a.click()
}
