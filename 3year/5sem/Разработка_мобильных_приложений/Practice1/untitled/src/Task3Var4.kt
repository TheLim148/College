import kotlin.math.floor

fun convert(n: Int): String {
    if (n < 0) {
        return "$n must be non negative"
    } else {
        //1 verst is 1066 meters and 80 cm
        var centimeters = 80.0; centimeters *= n
        var meters = 1066.0; meters *= n
        var kilometers = 0.0

        if (centimeters >= 100) {
            meters += floor(centimeters / 100).toInt()
            centimeters %= 100
        }
        if (meters >= 1000) {
            kilometers += floor(meters / 1000).toInt()
            meters %= 1000
        }

        return "$n versts are $kilometers km, $meters m, $centimeters cm"
    }
}

fun main() {
    print("Enter number of versts: "); var n = readln().toInt()
    print(convert(n))
}