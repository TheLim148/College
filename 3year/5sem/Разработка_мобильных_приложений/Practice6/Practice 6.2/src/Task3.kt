// создайте MutableMap и заполните его значениями, где ключи - названия товаров, значения - их цены
// Напишите функции для
// 1. Вывода всех товаров и их цен
// 2. Добавления нового товара
// 3. Изменения информации о товаре
// 4. Расчета суммы товаров

fun main() {
    val products = mutableMapOf(
        "Apple" to 100,
        "Banana" to 70,
        "Carrot" to 50,
        "Meat" to 300
    )

    fun printProducts() {
        println("Список товаров:")
        for ((name, price) in products) {
            println("$name — $price руб.")
        }
    }

    fun addProduct(name: String, price: Int) {
        if (products.containsKey(name)) {
            println("Товар '$name' уже существует.")
        } else {
            products[name] = price
            println("Добавлен товар '$name' с ценой $price руб.")
        }
    }

    fun updateProduct(name: String, newPrice: Int) {
        if (products.containsKey(name)) {
            products[name] = newPrice
            println("Цена товара '$name' обновлена до $newPrice руб.")
        } else {
            println("Товар '$name' не найден.")
        }
    }

    fun totalPrice() {
        val sum = products.values.sum()
        println("Общая сумма всех товаров: $sum руб.")
    }

    printProducts()
    addProduct("Milk", 120)
    updateProduct("Apple", 110)
    totalPrice()
}
