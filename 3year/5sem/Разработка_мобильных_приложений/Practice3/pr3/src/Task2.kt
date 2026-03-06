fun foo(str: String): String {
    var upper = true
    val charArray = str.toCharArray()


    for (i in charArray.indices) {
        if (charArray[i].isLetter()) {
            charArray[i] = if (upper) charArray[i].uppercaseChar() else charArray[i].lowercaseChar()
            upper = !upper
        }
    }
    val modString = String(charArray)
    return modString
}

fun main() {
    val str = readln()
    println(foo(str))
}