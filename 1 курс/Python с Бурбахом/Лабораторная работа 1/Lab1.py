import math
import random

def first():
    a = int(input("Введите первое число: "))
    b = int(input("Введите второе число: "))
    c = int(input("Введите третье число: "))
    print("Сумма чисел: " + str(a+b+c))
    print("Произведение чисел: " + str(a*b*c))
    print("Среднее арифметическое чисел: " + str((a+b+c)/3))

def second():
    r = float(input("Введите радиус окружности: "))
    square = math.pi*r*r
    lenght = 2*math.pi*r
    print("Площадь круга: " + str(square))
    print("Длина окружности: " + str(lenght))

def third():
    a = input("Введите число: ")
    print(" ".join(a))

def fourth():
    a = (int(input("первая координата точки a ")),int(input("вторая координата точки a "))) 
    b = (int(input("первая координата точки b ")),int(input("вторая координата точки b "))) 
    catet1 = abs(a[0] - b[0]) 
    catet2 = abs(a[1] - b[1]) 
    result = (catet1 ** 2 + catet2 ** 2) ** .5 
    print(float("{:.3f}".format(result)))

def fifth():
    a = int(input("Введите координату точки a: "))
    b = int(input("Введите координату точки b: "))

    if a<b:
        for i in range(0,5):
            number = random.randint(a, b)
            print(number)
    else:
        print("Число a больше b!!!")

def sixth():
    print(random.randint(2, 12))

def seventh():
    n = int(input("Введите количество учеников: "))
    print(random.randint(1, n))
    print(random.randint(1, n))

def eighth():
    n = int(input("Количество школьников: "))
    k = int(input("Количество яблок: "))

    if n%k == 0:
        print("Количество яблок у каждого школьника: " + str(n//k))
        print("Сколько яблок в корзине: " + str(n%k))
    else:
        print("Сколько яблок в корзине: " + str(n%k))
    
def ninth():
    a = int(input("Введите цену ракетки: "))
    b = int(input("Введите цену шарика: "))
    c = int(input("Введите количтсво денег: "))

    if c>a:
        print("Количество шариков: " + str((c-2*a)/b))
    else:
        print("c меньше a")
    
def tenth():
    num = int(input("Введите число: "))
    if num > 10:
        print(num % 100 // 10)
    else:
        print(0)
