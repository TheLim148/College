const students = [
    {name: "Ivan", age: 18, grade: 65},
    {name: "Maria", age: 19, grade: 92},
    {name: "Peter", age: 17, grade: 74},
    {name: "Kate", age: 20, grade: 88},
    {name: "Alex", age: 18, grade: 79}
    ]
//Task 1
//a
const SortStudents = students.filter(function(students) {
    return students.age >= 18
}) //Переменной присваивается значение метода filter, который в свою очередь выводит только тех студентов которые удовлетворяют условию, в данном случае старше 18 лет
console.log(SortStudents)

//b
const SortGrades = students.sort(function(a, b) {
    return b.grade-a.grade
}) //Переменной присваивается значение метода sort, который по условию сортирует оценки в порядке убывания
console.log(SortGrades)

//c
const ArrayWithNames = students.map(function(students) {
    return students.name
}) //Переменной присваивается значение метода map, который записывает все имена студентов в новый массив
console.log(ArrayWithNames)


//Task 3
//a
const user = {name:"Alex", age: 25, city:"Moscow", isOnline: true} //Объявление объекта
const copy_user = user //Присваивание значений новому объекту
copy_user.city = "Saint-Petersburg" // Изменение параметра
console.log(copy_user) //Вывод в консоль

//b
copy_user.hobbies = ["guitar", "music", "books", "sport"] //Добавление нового параметра "Хобби", содержащий массив строк

//c
for (const key in copy_user) {
    console.log(key + ':', copy_user[key]);
} //С помощью цикла перебираю ключи в объекте, и вывожу их вместе со значенями

