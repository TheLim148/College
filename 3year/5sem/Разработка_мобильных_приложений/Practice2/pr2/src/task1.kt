import kotlin.math.pow

// Вариант 13, задания 1 и 3
// Переменные и все типы данных

fun main() {
    val byte: Byte = -128
    val byte1: Byte = 127

    val short: Short = -32_768
    val short1: Short = 32_767

    val int: Int = (-2.0).pow(31).toInt()
    val int1: Int = ((2.0).pow(31)-1).toInt()

    val long: Long = (-2.0).pow(63).toLong()
    val long1: Long = ((2.0).pow(63)-1).toLong()

    val float: Float = Float.MAX_VALUE
    val float1: Float = Float.MIN_VALUE

    val double: Double = Double.MAX_VALUE
    val double1: Double = Double.MIN_VALUE

    val bool: Boolean = true

    val char: Char = '†'

    val str: String = "†††"

    val nullableString: String? = null

    fun printHello(): Unit {
        print("Hello, World!")
    }

    val pair: Pair<String, Int> = "Key" to 1

    val triple: Triple<Int, String, Boolean> = Triple(1, "hello", true)
}