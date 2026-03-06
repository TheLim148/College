import kotlin.math.floor

fun convert1(n: Int): String {
    if (n < 0) {
        return "$n must be non negative"
    } else {
        var seconds = n.toDouble()
        var minutes = 0.0
        var hours = 0.0
        var days = 0.0

        if (seconds >= 60) {
            minutes += floor(seconds / 60).toInt()
            seconds %= 60
        }

        if (minutes >= 60) {
            hours += floor(minutes / 60).toInt()
            minutes %= 60
        }

        if (hours >= 24) {
            days += floor(hours / 24).toInt()
            hours %= 24
        }

        return "$n seconds are $days days, $hours hours, $minutes minutes, $seconds seconds"
    }
}

fun main() {
    print("Enter number of seconds: "); var n = readln().toInt()
    print(convert1(n))
}