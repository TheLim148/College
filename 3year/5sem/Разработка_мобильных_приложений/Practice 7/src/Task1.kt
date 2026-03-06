// Сотрудник. (поля: имя, р – минимальная зарплата)
// Менеджер (поле объем продаж в тоннах) 
// Инженер (поле количество разработанных проектов – n)

open class Employee(
    private val name: String,
    private val p: Double
) {
    open fun printFields() {
        println("Сотрудник: $name, минимальная зарплата: $p")
    }
    open fun income(k: Double): Double {
        return k * p
    }
}

class Manager(
    name: String,
    p: Double,
    private val salesTons: Double,
    private val nThreshold: Double
) : Employee(name, p) {
    override fun printFields() {
        super.printFields()
        println("Должность: Менеджер, объём продаж (т): $salesTons, порог N: $nThreshold")
    }
    override fun income(k: Double): Double {
        var x = super.income(k)
        if (salesTons > nThreshold) {
            x += 0.01 * nThreshold
        }
        return x
    }
}

class Engineer(
    name: String,
    p: Double,
    private val n: Int
) : Employee(name, p) {
    override fun printFields() {
        super.printFields()
        println("Должность: Инженер, проектов: $n")
    }
    override fun income(k: Double): Double {
        val x = super.income(k)
        return x + 4.8 * n
    }
}

fun main() {
    val e = Employee("Иван", 20_000.0)
    e.printFields()
    println("Доход (k=1.5): ${"%.2f".format(e.income(1.5))}")

    val m = Manager("Анна", 22_000.0, salesTons = 120.0, nThreshold = 100.0)
    m.printFields()
    println("Доход менеджера (k=1.3): ${"%.2f".format(m.income(1.3))}")

    val eng = Engineer("Пётр", 25_000.0, n = 7)
    eng.printFields()
    println("Доход инженера (k=1.2): ${"%.2f".format(eng.income(1.2))}")
}