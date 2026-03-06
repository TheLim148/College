fun main() {
    print("Enter a: "); var a = readln()
    print("Enter b: "); var b = readln()
    print("Enter c: "); var c = readln()

    a = b.also { b = a }
    b = c.also { c = b }

    print("$a $b $c")
}