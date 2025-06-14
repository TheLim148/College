def first():
    print('x y z w')
    for x in 0, 1:
        for y in 0, 1:
            for z in 0, 1:
                for w in 0, 1:
                    if ((not(x) and not(y)) or (y == z) or not(w)) == 0:
                        print(x, y, z, w)

def second():
    n = 0
    s = 250
    while s - n > 0:
        s = s - 5
        n = n + 25
    print(n) 
 

def third():
    for m in range(0, 255):
        if 80 == 84 & m:
            print(bin(m), m)

def fourth():
    def f(x, y):
        if x > y or x == 15 or y == 15:
            return 0
        elif x == y:
            return 1
        else:
            return f(x + 1, y) + f(x * 2, y)
    print(f(1, 10) * f(10, 21))

def fifth():
    N = int(input())
    R = 0
    while N > 0:
        d = N % 10
        if d == 4:
            R = R + 1
        N = N//10
    print(R)
    
#first()
#second()
#third()
#fourth()
fifth()
