// data class Student(name, age, grades);
// StudentGroup с полями: список студентов (MutableList), название группы, ФИО куратора.
// Методы: calculateAverageGrade(Student),
// printStudentInfo(Student), printGroupInfo() — вывод всей группы,
// Ранжирование по среднему баллу по убыванию.

data class Student(
    val name: String,
    val age: Int,
    val grades: List<Int>
)

class StudentGroup(
    val groupName: String,
    val curatorFio: String,
    val students: MutableList<Student>
) {
    fun calculateAverageGrade(s: Student): Double {
        if (s.grades.isEmpty()) return 0.0
        var sum = 0
        var i = 0
        while (i < s.grades.size) {
            sum += s.grades[i]
            i++
        }
        return sum.toDouble() / s.grades.size.toDouble()
    }

    fun printStudentInfo(s: Student) {
        val avg = calculateAverageGrade(s)
        println("Студент: ${s.name}, возраст: ${s.age}, оценки: ${s.grades}, средний: ${"%.2f".format(avg)}")
    }

    fun printGroupInfo() {
        println("Группа: $groupName")
        println("Куратор: $curatorFio")
        val arr = students.sortedByDescending { calculateAverageGrade(it) }
        for (s in arr) {
            printStudentInfo(s)
        }
    }

}

fun main() {
    val st1 = Student("Анна", 19, listOf(5, 4, 5, 5))
    val st2 = Student("Борис", 20, listOf(3, 4, 4))
    val st3 = Student("Вика", 18, listOf(5, 5, 5, 5, 4))
    val group = StudentGroup("3992", "Иванов И.И.", mutableListOf(st1, st2, st3))
    group.printGroupInfo()
}
