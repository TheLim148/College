// Задача 3. Поиск подмассива
// Создайте массив из 50 целых чисел.
// Напишите функцию, которая принимает этот массив и целое число k, и возвращает индекс первого вхождения подмассива, сумма элементов которого равна k.

fun findSubarrayWithSum(arr: Array<Int>, k: Int): Int {
    for (i in arr.indices) {
        var sum = 0
        for (j in i until arr.size) {
            sum += arr[j]
            if (sum == k) 
                return i
            if (sum > k)
                break
        }
    }
    return -1
}

fun main() {
    val arr = Array(50) { it + 1 }
    val k = 100
    val index = findSubarrayWithSum(arr, k)
    println("Индекс первого вхождения подмассива = $index")
}
