// Вариант 13, задания 1 и 3
// Ввести число, проверить чётное ли оно и оканчивается цифрой 7

fun main() {
    val a: Int = readln().toInt()

    if(a <= 0) {
        print("$a are not natural")
    } else {
        if(a % 2 == 0) {
            print("$a is even")
        }
        if(a % 10 == 7) {
            print("$a is seven(7)")
        } else {
            print("\n$a is natural")
        }
    }
}