fun multiplyDigitsInNumber(number: Int): Int {
    if(number !in 100..999) {
        print("Number must contain 3 digits")
        return -1
    }
    else {
        var n = number
        var multiply = 1

        while(n != 0) {
            val digit = n % 10
            multiply *= digit
            n /= 10
        }
        return multiply
    }
}

fun main() {
    print("Enter 3 digit number: ")
    var result = readln().toInt()
    print(multiplyDigitsInNumber(result))
}