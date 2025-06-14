import random
from math import log, ceil

def first():
    print(sum(int(i) % 2 == 0 for i in input("Введите число: ")))

def second():
    print(sum(int(i) for i in input("Введите число: ")))

def third():
    arr = []
    p = 1
    x = int( input("Введите число: ") )
    while x != 0:
        arr.append( x ) 
        x = int( input("Введите число: ") )
    print( "Числа:", arr)
    print( "Сумма:", sum( arr ) )
    for a in arr: p *= a
    print("Произведение:", p)

def fourth():
    arr = []
    p = 1
    x = int( input("Введите число: ") )
    while x != 0:
        arr.append( x ) 
        x = int( input("Введите число: ") )
    print( "Числа:", arr)
    print("Минимальный элемент:", min(arr))
    print("Максимальный элемент:", max(arr))

def fifth():
    p = 1
    n = int(input("Введите число: "))
    for i in range(1, n + 1):
        p *= i
    print("Факториал числа", n, "равен", p)

def sixth():
    a = int(input("Введите число: "))
    n = int(input("Введите степень: "))
 
    while n != 1:
        n -= 1
        a *= a
    print(a)

def seventh():
    count = int(input("Введите число: "))
    prev=1
    current = 1
    result = []
    for i in range(count):
        result.append(prev)
        prev, current = current, current+prev
 
    print(result)

def eighth():
    a = 1
    b = 1
    c = int(input("Введите число: "))
    while c != a:
        a, b = b, a+b
        if c == a:
            print("True")
            break
        elif a > c:
            print("False")
            break

def ninth():
    a = 10
    s = 200
    p = int(input("Введите число от 1 до 50: "))
    if 1<=p<=50:
        print(ceil(log(s/a * p/100 + 1) / log(1 + p/100)))
    else:
        print("Слишком большое число")

def tenth():
    n = int(input("Первое число: "))
    m = int(input("Второе число: ")) % 10
    print(str(n).count(str(m)))
  
def eleventh():
    a = list(input("Введите число: "))
    a.reverse()
    a1 = "".join(a)
    print("Обратное число:", a1)
