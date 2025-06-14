import random

def first():
    a = int(input("Введите число: "))
    b = int(input("Введите число: "))
    c = int(input("Введите число: "))
    print("Максимальное число:", sorted([a, b, c])[-1])

def second():
    a = int(input("Введите число: "))
    print("Длинна числа:", len(str(a)))

def third():
    a = int(input("Введите число: "))
    b = int(input("Введите число: "))
 
    while a != 0 and b != 0:
        if a > b:
            a = a % b
        else:
            b = b % a
    gcd = a + b
    print("НОД:", gcd)

def fourth():
    a = list(input("Введите число: "))
    print("Перевернутое число:", "".join(reversed(a)))

def fifth():
    print("Первая кость:", random.randint(1, 6))
    print("Вторая кость:", random.randint(1, 6))

def sixth():
    n = int(input("Введите число: "))

    factorial = 1
    while n > 1:
        factorial *= n
        n -= 1

    print("Факториал числа:", factorial)

def seventh():
    fib1 = 1
    fib2 = 1

    n = input("Номер элемента ряда Фибоначчи: ")
    n = int(n)

    i = 0
    while i < n - 2:
        fib_sum = fib1 + fib2
        fib1 = fib2
        fib2 = fib_sum
        i = i + 1

    print("Значение этого элемента:", fib2)

def eighth():
    max_number = 10000

    def summa(n):
        сумма = 0
        for k in range(1, n//2+1):
            if n%k == 0:
                сумма += k
        return сумма

    lst = [0, 1]
    for m in range(2, max_number+1):
        lst.append(summa(m))
 
    for i in range(2, max_number+1):
        for j in range(i+1, max_number+1):
            if i == lst[j] and j == lst[i]:
                print("Дружественные числа:",i, j)

def ninth():
    def is_perf(n):
        s=1
        for i in range(2,n//2):
            if i*i>n : break
            if n%i==0 :
                s+=i
                s+=n//i
        return s==n
    
    a = int(input("Введите нижний порог: "))
    b = int(input("Введите верхний порог: "))
 
    for x in range(a,b+1):
        if is_perf(x) : print("Соверщенное число:", x)
