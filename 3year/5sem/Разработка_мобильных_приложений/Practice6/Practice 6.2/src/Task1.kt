// Дан список товаров, группированный по категориям, необходимо реализовать 4 функции
// 1. Возможность добавления товара в определённую категорию
// 2. Возможность добавления категории
// 3. Вывод всех товаров из определенной категории
// 4. Поиск товаров по названию (например, при вводе - “мо”, должны быть выведены все товары, содержащие “мо”, из всех категорий)

fun main() {
    val result = mutableListOf(
        Pair("Meat", arrayOf("Beef", "Chicken")),
        Pair("Fruits", arrayOf("Apple", "Banana", "Orange")),
        Pair("Vegetables", arrayOf("Carrot", "Broccoli"))
    )

    fun addProduct(category: String, product: String) {
        for (i in result.indices) {
            if (result[i].first == category) {
                val updated = result[i].second + product
                result[i] = Pair(category, updated)
                println("Товар '$product' добавлен в категорию '$category'")
                return
            }
        }
        println("Категория '$category' не найдена")
    }

    fun addCategory(category: String) {
        if (result.any { it.first == category }) {
            println("Категория '$category' уже существует")
        } else {
            result.add(Pair(category, arrayOf()))
            println("Категория '$category' добавлена")
        }
    }

    fun printCategory(category: String) {
        val found = result.find { it.first == category }
        if (found != null) {
            println("Товары категории '$category': ${found.second.joinToString()}")
        } else {
            println("Категория '$category' не найдена")
        }
    }

    fun searchProducts(sub: String) {
        print("Результаты поиска по '$sub': ")
        for ((cat, items) in result) {
            val filtered = items.filter { it.contains(sub, ignoreCase = true) }
            if (filtered.isNotEmpty()) {
                println("$cat: ${filtered.joinToString()}")
            }
        }
    }

    addProduct("Fruits", "Mango")
    addCategory("Dairy")
    printCategory("Fruits")
    searchProducts("an")
}
