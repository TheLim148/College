fun sevenSigns(str: String): String {
    if(str.length < 7) {
        return "bruh"
    } else {
        return str.slice(str.length - 7 until str.length)
    }
}

fun main(){
    val str = "Карл у Клары украл кораллы, Клара у Карла украла кларнет"
    println(sevenSigns(str))
}