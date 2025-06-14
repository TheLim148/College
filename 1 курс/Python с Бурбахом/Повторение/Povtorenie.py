import random
import string

def first():
    def summch(a):
        answ = 0
        for char in str(a):
            answ += int(char)
        return answ
 
    a = int(input("Поиск чисел от 10 до "))
    for i in range(10, a, 1):
        if summch(i) + summch(i) ** 2 == i:
            print(i)

def second():
    d = 1
    for i in range(100, 999):
        if i%7 == 0 and sum(map(int, list(str(i)))) == 7:
            print(i)

def third():
    a = int(input("Введите число: "))
    print(max(map(int, list(str(a)))))

def fourth():
    b = []
    a = int(input("Введите число: "))
    for i in range(1, a):
        if a%i == 0:
            if i%2 == 0:
                b.append(i)
    print("Четные делители:", b)
    print("Сумма четных делителей:", sum(map(int, b)))

def fifth():
    a = []
    for i in range(0, 10):
        a.append(random.randint(-100, 999))
    print("Список чисел:", a)
    print("Максимальный элемент:", max(map(int, a)))
    for i in range(0, len(a)):
        if a[i]<0:
            print("Номер отрицательного элемента:", i)
            break

def sixth():
    a = []
    for i in range(0, 10):
        a.append(random.randint(1, 100))
    print("Список чисел:", a)
    middle = sum(map(int, a))/len(a)
    print("Среднее арифметическое:", middle)
    for i in range(0, len(a)):
        if a[i]>middle:
            print("Число большее среднего арифметического:", a[i])
        
def seventh():
    s = str(input("Введите строку: "))
    s = s.split()
    print("Строка:", s)

    for i in range(0, len(s)):
        if len(s[0]) == len(s[i]):
            print("Слово, равное по длине первому:", s[i])


def eighth():
    numbers = ''
    nexting = True
    
    s = input("Введите строку: ")
    for i in range(len(s)):
        try:
            num = int(s[i])
            if not nexting:
                numbers += ' '
            
            numbers += str(num)
            nexting = True
        except:
            nexting = False
    print(numbers)
    list_str = numbers.split(' ')
    list_num = []
    for i in range(len(list_str)):
        list_num.append(len(list_str[i]))
    
    for i in range(len(list_str)):
        if len(list_str[i]) == max(list_num):
            print("Число:", list_str[i])
    print("Количество цифр:", max(list_num))

def ninth():
    s = input("Введите строку: ")
    print("Исходная строка:", s)
    s = list(s)
    print("Лист:", s)
    s1 = ''.join(sorted(c for c in s if c in string.ascii_letters))
    print("Отсортированная строка:", s1)
        

def tenth():
    s = input("Введите строку: ")
    print("Исходная строка: ", s)
    s = set(s.split())
    print("Множество", s)
