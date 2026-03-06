// Вариант 13, задания 1 и 3
// Ввести три переменные и вывести наибольшую из них

fun main() {
    val a = readln().toInt()
    val b = readln().toInt()
    val c = readln().toInt()

    if (a > b){
        if(a > c){
            print("$a")
        }
    }
    if (b > a){
        if(b > c){
            print("$b")
        }
    }
    if (c > a){
        if(c > b){
            print("$c")
        }
    }
}