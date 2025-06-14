import math

def first():
    k = int(input("Введите значение k: "))
    n = int(input("Введите значение n: "))

    if k == n:
        k = 0
        n = 0
        print("Значение k:", k, "Значение n:", n)
    elif k>n:
        n = k
        print("Значение k:", k, "Значение n:", n)
    elif k<n:
        k = n
        print("Значение k:", k, "Значение n:", n)

def second():
    month = int(input("Введите номер месяца: "))
    if month == 1:
        print("Этот месяц - январь, время года - зима")
    elif month == 2:
        print("Этот месяц - февраль, время года - зима")
    elif month == 3:
        print("Этот месяц - март, время года - весна")
    elif month == 4:
        print("Этот месяц - апрель, время года - весна")
    elif month == 5:
        print("Этот месяц - май, время года - весна")
    elif month == 6:
        print("Этот месяц - июнь, время года - лето")
    elif month == 7:
        print("Этот месяц - июль, время года - лето")
    elif month == 8:
        print("Этот месяц - август, время года - лето")
    elif month == 9:
        print("Этот месяц - сентябрь, время года - осень")
    elif month == 10:
        print("Этот месяц - октябрь, время года - осень")
    elif month == 11:
        print("Этот месяц - ноябрь, время года - осень")
    elif month == 12:
        print("Этот месяц - декабрь, время года - зима")
    else:
        print("Ошибка!")

def third():
    n = input("Введите 4-х значное число: ")
    if 1000<=int(n)<=9999:
        if n == n[::-1]:
            print("Палидром")
        elif len(set(n)) == len(n):
            print("Не палидром")
    else:
        print("Число не 4-х значное")
        
def fourth():
    a = input("Введите 4-х значное число: ")
    if int(a)<=9999:
        for i in range(0, 10):
            n = a.count(str(i))
            if n == 3:
                print("Есть")
    else:
        print("Число не входит в диапазон")
    
def fifth():
    pass

def sixth():
    a = float (input ("Длина первой стороны: "))
    b = float (input ("Длина второй стороны: "))
    c = float (input ("Длина третьей стороны: "))
 
    if (
         a + b > c
         and
         b + c > a
         and
         a + c > b
       ) :
        print ("Такой треугольник существует")
    else :
        print ("Нет треугольника с такими сторонами")

def seventh():
    a = float (input ("Длина первой стороны: "))
    b = float (input ("Длина второй стороны: "))
    c = float (input ("Длина третьей стороны: "))
 
    if (
         a + b > c
         and
         b + c > a
         and
         a + c > b
       ) :
        print ("Такой треугольник существует")
 
        A = [a, b, c]
        A.sort ()
 
        a = A [0]
        b = A [1]
        c = A [2]
 
        if a * a + b * b < c * c :
            print ("Это треугольник остроугольный")
            print ("Его площадь равна", "%.2f" % (a * b / 2.0))
  
    else :
        print ("Нет треугольника с такими сторонами")

def eighth():
    a = int(input ("Длина боковой стороны: "))
    c = int(input ("Длина основания: "))
    b = a
        
    if (
         a + b > c
         and
         b + c > a
         and
         a + c > b
       ) :
        print ("Такой треугольник существует")
        p = int((a+b+c)/2)
        s = (p(p-a)(p-b)(p-c))**0.5
        print("Площадь равна:", s)
        if s%2 == 0:
            s/2
        else:
            print("Площадь не кратна двум")
    else:
        print ("Нет треугольника с такими сторонами")

def ninth():
    a = int(input("Первая сторона кирпича: "))
    b = int(input("Вторая сторона кирпича: "))
    c = int(input("Третья сторона кирпича: "))
    x = int(input("Первая сторона проема: "))
    y = int(input("Вторая сторона проема: "))
    if ((a <= x) and (b <= y)) or ((b <= x) and (a <= y)):
        print("Да")
    else:
        if ((a <= x) and (c <= y)) or ((c <= x) and (a <= y)):
            print("Да")
        else:
            if ((c <= x) and (b <= y)) or ((b <= x) and (c <= y)):
                print("Да")
            else:
                print("Нет")

def tenth():
    mm = {
        "1" : 'Января',
        "2" : 'Февраля',
        "3" : 'Марта',
        "4" : 'Апреля',
        "5" : 'Мая',
        "6" : 'Июня' ,
        "7" : 'Июля' ,
        "8" : 'Августа' ,
        "9" : 'Сентября' ,
        "10" : 'Октября' ,
        "11" : 'Ноября' ,
        "12" : 'Декабря'
    }
 
    enter = input().split()
    print ('{} {}'.format((int(enter[0])+1), mm[enter[1]]))
