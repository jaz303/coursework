def f(n):
    return 4 * (n - 1) / 5.0
    
def f6(n):
    for i in range(0, 6):
        n = f(n)
    return n
    
def is_int(n):
    return abs(n - int(n)) < 0.0010001

for i in range(0, 100000):
    if is_int(f6(i)):
        print i
        break
