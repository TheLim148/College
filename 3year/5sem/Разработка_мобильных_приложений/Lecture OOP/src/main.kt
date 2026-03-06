class MathUtils {
    companion object {
        fun cube(x: Int) = x * x * x
    }
}

fun main() {
    // Что такое класс?
    // Класс — это пользовательский тип, описывающий состояние (свойства) и поведение (методы) объектов
    class Point(var x: Int, var y: Int) {
        fun move(dx: Int, dy: Int) {
            x += dx
            y += dy
        }
    }

    println("1")
    val p = Point(1, 2)
    p.move(3, -1)
    println("${p.x},${p.y}")
    println()


    // Что такое объект класса?
    // Объект — это созданный из класса конкретный экземпляр с собственными данными
    class User(val name: String)
    
    println("2")
    val u1 = User("Alice")
    val u2 = User("Bob")
    println(u1.name != u2.name)
    println()


    // Что такое поля?
    // Свойство = val/var геттером/сеттером и возможным backing field'ом (field в аксессорах)
    class BankAccount(balance0: Int) {
        var balance: Int = balance0
        set(value) {
            require(value >= 0)
            field = value
        }
    }

    println("3")
    val a = BankAccount(100)
    a.balance = 150
    println(a.balance)
    println()


    // Что такое конструктор и сколько их можно создать?
    // Есть один первичный конструктор и любое число вторичных (constructor). Можно без вторичных
    class Person(val name: String, val age: Int) {   // первичный
        init { require(age >= 0) }                   // инициализационный блок
        constructor(name: String) : this(name, 0)    // вторичный
    }

    println("4")
    println(Person("Eve").age)
    println(Person("Ada", 25).name)
    println()


    // Методы класса
    // Методы — функции-члены
    class Counter {
        private var n = 0
        fun inc() { n++ }
        fun value(): Int = n
    }

    println("5")
    val c = Counter()
    c.inc()
    println(c.value())
    println()


    // Полиморфизм
    // Метод одного класса используется другим классом
    open class Animal {
        open fun sound() = "..."
    }

    class Cat : Animal() {
        override fun sound() = "Meow"
    }

    fun speak(a: Animal) = println(a.sound())

    println("6")
    speak(Animal())
    speak(Cat()) 
    println()


    // Наследование
    // Дочерний класс наследует поля и методы родительского класса
    open class Employee(val name: String) {
        open fun role() = "employee"
    }

    class Manager(name: String) : Employee(name) {
        override fun role() = "manager"
    }

    println("7")
    println(Manager("Ann").role())
    println()


    // Инкапсуляция
    // Сокрытие реализации через модификаторы: private, protected, internal, public
    class SafeBox(private var code: String) {
        fun changeCode(old: String, new: String): Boolean {
            if (old == code) {
                code = new
                return true
            } else {
                return false
            }
        } 
    }

    println("8")
    val box = SafeBox("1234")
    println(box.changeCode("1234","9999"))
    println()


    // Статические поля
    // Поля, которые можно вызывать без создания экземпляра класса
    println("9")
    println(MathUtils.cube(3))
    println()


    println("10")
    open class Employee1(val id: Int, val fullName: String) {
        open fun info() = "[$id] $fullName — сотрудник"
    }
    class Teacher(id: Int, fullName: String, val subject: String) : Employee1(id, fullName) {
        override fun info() = "[$id] $fullName — преподаватель $subject"
    }

    val e: Employee1 = Employee1(1, "Иван Петров")
    val t: Employee1 = Teacher(2, "Мария Иванова", "Литература")
    println(e.info())
    println(t.info())
}