def first():
	print((" " + input("Введите строку: ").lower()).count(" е"))

def second():
        s = input("Введите строку с двоеточиями: ")
        s = s.replace(":", "%")
        print(s.count("%"))

def third():
        s = input("Введите строку с точками: ")
        s1 = s.replace(".", "")
        print(len(s) - len(s1))

def fourth():
        s = input("Введите строку в верхнем регистре: ")
        s = s.lower()
        print(s)

def fifth():
        s = input("Введите строку заканчивающуюся точкой: ")
        s = s.split(".")
        print(s)

def sixth():
        s = input("Введите строку-предложение на английском языке: ")
        s1 = " ".join([s[0].upper() + s[1:] for s in a.lower().split()])
        print(s1)

def seventh():
        count = 1
        result = 0
        maxx = 0
        s = input("Введите строку: ")
        for i in range(1, len(s)):
                if s[i] == s[i-1] == 'н':
                        count = count + 1
                if count > maxx:
                        maxx = count
                else:
                        count = 1
        print("Самая длинная последовательность: " + str(maxx))
        s = s.replace("!", ".")
        print("Строка с замененными символами: " + s)

def eighth():
        print(*[s for s in input("Введите строку где последняя буква будет я:").split() if s[-1] == 'я'])

def ninth():
        s = input("Введите строку со скобками: ")
        f = s[s.find("(")+ 1:s.find(")")-1]
        print(f)
        
def tenth():
        s = input("Введите 3 числа через пробел: ")
        s = s.split()
        int_list = [int(x) for x in s]
        res = int_list[0] + int_list[1] + int_list[2]
        print(res)

def eleventh():
        st = input("Введите первую строку: ")
        st1 = input("Введите вторую строку: ")

        if st.find(st1):
                print("Есть контакт!")
        else:
                print("Мимо!")

def twelfth():
        s = input("Введите строку в несколько слов: ")
        s = s.split()
        print(s[0])

def thirteenth():
        s = input("Введите выражение из 3-х цифр и 2-х знаков: ")
        print(eval(s))
