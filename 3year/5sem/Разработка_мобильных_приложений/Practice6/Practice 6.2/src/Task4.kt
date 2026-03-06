// Создайте класс Sale, который будет представлять продажу
// На вход подаётся список продаж, необходимо определить общую стоимость проданных товаров в каждой категории

data class Sale(
    val productName: String,
    val category: String,
    val quantity: Int
)

fun main() {
    val sales = listOf(
        Sale("Apple", "Fruits", 10),
        Sale("Banana", "Fruits", 5),
        Sale("Carrot", "Vegetables", 8),
        Sale("Broccoli", "Vegetables", 12),
        Sale("Chicken", "Meat", 15),
        Sale("Beef", "Meat", 20),
        Sale("Orange", "Fruits", 7)
    )

    val grouped = sales.groupBy { it.category }

    val totalByCategory = grouped.mapValues { (_, list) ->
        list.sumOf { it.quantity }
    }

    println("Общая сумма проданных товаров по категориям:")
    for ((category, total) in totalByCategory) {
        println("$category — $total штук")
    }
}
