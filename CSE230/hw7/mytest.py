from decorators import *

@traced
def foo(a,b):
    if a==0: return b
    return foo(b=a-1,a=b-1)
 

@traced
def fib_t(x):
    if x<=1:
        return 1
    else:
        return fib_t(x-1)+fib_t(x-2)

foo(4,5)