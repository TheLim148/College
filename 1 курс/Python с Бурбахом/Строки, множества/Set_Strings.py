import random
import re

def first():
    a = [random.randint(0, 9) for x in range(0, 9)]
    print("Исходный список: " + str(a))
    print("Кол-во уникальных значений: " + str(len(set(a))))

def second():
    a = [random.randint(0, 9) for x in range(0, 9)]
    b = [random.randint(0, 9) for x in range(0, 9)]

    print("Исходный список a: " + str(a))
    print("Исходный список b: " + str(b))
    print("Пересечение множеств: " + str(len(set(map(int, a)) & set(map(int, b)))))

def third():
    a = [random.randint(0, 9) for x in range(0, 9)]
    b = [random.randint(0, 9) for x in range(0, 9)]

    print("Исходный список a: " + str(a))
    print("Исходный список b: " + str(b))
    
    print("Пересечение множеств: " + str(len(set(map(int, a)) & set(map(int, b)))))
    print("Отсортированное множество: " + str(sorted(set(map(int, a)) & set(map(int, b)))))

def fourth():
    def task(arr):
        n=len(arr)
        for i in range(n):
            if arr[i] in arr[0:i]:
                print("YES")
            else:
                print("NO")
            
    s=input("Введите числа через пробел: ")
    task(list(map(int,s.split(" "))))

def fifth():
    n = int(input("ВВедите число строк: "))
    a = set()
    for i in range(n):
        a |= set(input("Введите текст: ").split())
    print(len(a))

def sixth():
    s = {"a", "b", "c"}
    s.remove("c")
    s.add("d")
    print(s)

def seventh():
    s_1 = {"a", "b"}
    s_2 = {"b", "c"}

    print("Объединение:", s_1 | s_2)		
    print("Пересечение:", s_1 & s_2)		
    print("Разность:", s_1 - s_2)		
    print("Симметричная разность:", s_1 ^ s_2)

def eighth():
    a = 'аквариум' 
    b = 'мармелад' 
    c = 'рама' 

    s1 = set(a) 
    s2 = set(b) 
    s3 = set(c) 

    common_letters = s1 & s2 & s3 
    print("Общие буквы:", common_letters) 
    all_letters = s1 | s2 | s3 
    print("Все буквы:", all_letters)

def ninth():
    a = ['ivan2022', 'sveta', 'ivan', 'kot23', 'sveta', 'ivan']
    b = ['koly', 'enot37', 'luzer', 'kot23', 'sveta']

    s1 = set(a)
    s2 = set(b)
    print("Уникальное множество a:", s1)
    print("Уникальное множество b:", s2)
    
    v1 = s1 & s2
    print("Уникальные ники в обоих множествах:", v1)
    print("Кол-во уникальних ников в множестве a:", len(s1))
    print("Кол-во уникальних ников в множестве b:", len(s2))
    
