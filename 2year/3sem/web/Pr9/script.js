ц// // // // // // // 1

const students = [
    {name:"Иван",age:18,grade:85},
    {name:"Мария",age:19,grade:92},
    {name:"Петр",age:17,grade:74},
    {name:"Екатерина",age:20,grade:88},
    {name:"Алексей",age:18,grade:79},
];

// filter создаёт новый массив, по данным, что возвращаются внутри вызова дополнительной функцией. Происходит проверка каждого элемента (его свойства age), если оно больше 18 то возвращается весь ЭЛЕМЕНТ
const age18 = students.filter(function(item) {
    return item.age >= 18;
});
console.log(age18);

// sort работает немного отлично от остальных, для него 0 значит оба числа равны, а если больше 0 - первое значение больше второго, если меньше - первое значение меньше второго. И при этом, несмотря на то, что мы возвращаем в return эту разность левого и правого числа (a и b), sort внутри себя сам сортирует массив так, чтобы что-то было слева, а что-то было справа. Скорее всего для каждого элемента до [students.length - 2] присваивается (a) и сравнивается с следующим (b)
students.sort(function(a,b){
    return a.grade - b.grade
});
console.log(students);

// map тоже создаёт новый массив, по данным, что возвращаются внутри вызова дополнительной функцией. То есть массив перебирается и возвращается только СВОЙСТВО name для каждого из элементов
const names = students.map(function(item) {
    return item.name;
});
console.log(names);

// // // // // // // 2


function formatDates(input) {
    let dates = input.split(","); // разделяю строку по "," и получаю массив всех дат

    // перебираю массив всех дат, и для каждой даты меняю местами год и день и меняю знак разделения
    dates.forEach(function(item, i, arr) {
        let items = item.split("-"); // разделяю строку по "-" и получаю массив с год, месяц, день

        // меняю местами год и день
        const temp = items[0];
        items[0] = items[2];
        items[2] = temp;

        arr[i] = items.join("."); // создаю строки из массива с день, месяц, год, разделённые "."
    });
    return dates;
}

console.log(formatDates("2024-11-20,2024-12-25,2025-01-01")) // вызов


function formatNumbers(input) {
    // перебираю массив всех чисел, и для каждой даты меняю местами год и день и меняю знак разделения
    input.forEach(function(item, i, arr) {
        arr[i] = item.toFixed(2); // округляет число до 2 знаков
    });

    let result = input.join("; ") // превращает массив округлённых чисел в строку, разделённую "; "
    return result;
}

console.log(formatNumbers([1.2345, 6.789, 3.4567]))

const numbers = ['0','1','2','3','4','5','6','7','8','9']

function sumNumberFromString(input){
    let chars = input.split("");
    let array = [];

    let chislo = ""
    chars.forEach(function(item, i, arr) {
        if (item in numbers){
            chislo += item;
        }
        else {
            if (chislo != ""){
                array.push(chislo);
                chislo = ""
            }
        }
    });
    console.log(array);
}

sumNumberFromString("g gg 4 gg 12 gg 34gfg 56.")