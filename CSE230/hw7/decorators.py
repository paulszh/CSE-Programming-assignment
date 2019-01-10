#!/usr/bin/env python3
from misc import Failure

class profiled(object):
    def __init__(self,f):
        self.__count=0
        self.__f=f
        self.__name__=f.__name__
    def __call__(self,*args,**dargs):
        self.__count+=1
        return self.__f(*args,**dargs)
    def count(self):
        return self.__count
    def reset(self):
        self.__count=0

'''
Traced Decorator
When the decorated function is called, the decorator should print out an ASCII art tree of the recursive calls and 
their return values.The return value of the function should be return to the caller after all printing is complete. 
If an exception occurs in the funciton, the nesting level must be adjusted to the appropriate level where the 
exception is caught.
'''
class traced(object):
    def __init__(self,f):
        # replace this and fill in the rest of the class
        self.__name__= f.__name__
        self.f = f
        self.level = 0

    def __call__(self, *args, **kwargs):
        try:
            currline = ""
            nextline = ""
            if self.level > 0:
                for i in range(0,self.level):
                    currline += ("| ")
            currline += ",- " + self.__name__ + "("
        
            if args:
                for arg in args:
                    currline += str(arg) + ", "
                    
            if kwargs:
                for arg in kwargs:
                    currline += arg + "=" + str(kwargs[arg]) + ", "
        
            currline = currline[:-2]
            print (currline + ")")
            
            if self.level > 0:
                for i in range(0,self.level):
                    nextline += ("| ")
            nextline += "`- "
            
            self.level += 1
            result = self.f(*args, **kwargs)
            nextline += str(result)
            print (nextline)
            #backtracking
            self.level -= 1
            # if (self.level == 0):
            #     print(result)
            return result
            
        except Exception as e:
            # Handle the exception
            self.level -= 1
            raise e
        
        
        
'''
Memoized decorator
When the decorated function is called, the decorator should check to see if the function has already been called with 
the given arguments. If so, the decorator should return the value the the function returned when it was last called 
with the given arguments. If the function last threw an exception when called with the given arguments, the same 
exception should be thrown again. If the function has not been called with the given arguments, then call it and 
record the return value or exception. Then return the return value or raise the thrown exception.
'''
class memoized(object):
    def __init__(self,f):
        # replace this and fill in the rest of the class
        self.__name__= f.__name__
        self.f = f
        self.cache = {}
        
    def  __call__(self,*args, **kwargs):
        key = str(args) + str(kwargs)
        if key not in self.cache:
            try:
                self.cache[key] = self.f(*args, **kwargs)
            except Exception as e:
                self.cache[key] = e
        
        if isinstance(self.cache[key], Exception):
            raise self.cache[key]
        return self.cache[key]
        

# run some examples.  The output from this is in decorators.out
def run_examples():
    for f,a in [(fib_t,(7,)),
                (fib_mt,(7,)),
                (fib_tm,(7,)),
                (fib_mp,(7,)),
                (fib_mp.count,()),
                (fib_mp,(7,)),
                (fib_mp.count,()),
                (fib_mp.reset,()),
                (fib_mp,(7,)),
                (fib_mp.count,()),
                (even_t,(6,)),
                (quicksort_t,([5,8,100,45,3,89,22,78,121,2,78],)),
                (quicksort_mt,([5,8,100,45,3,89,22,78,121,2,78],)),
                (quicksort_mt,([5,8,100,45,3,89,22,78,121,2,78],)),
                (change_t,([9,7,5],44)),
                (change_mt,([9,7,5],44)),
                (change_mt,([9,7,5],44)),
                ]:
        print("RUNNING %s(%s):" % (f.__name__,", ".join([repr(x) for x in a])))
        rv=f(*a)
        print("RETURNED %s" % repr(rv))

@traced
def fib_t(x):
    if x<=1:
        return 1
    else:
        return fib_t(x-1)+fib_t(x-2)

@traced
@memoized
def fib_mt(x):
    if x<=1:
        return 1
    else:
        return fib_mt(x-1)+fib_mt(x-2)

@memoized
@traced
def fib_tm(x):
    if x<=1:
        return 1
    else:
        return fib_tm(x-1)+fib_tm(x-2)

@profiled
@memoized
def fib_mp(x):
    if x<=1:
        return 1
    else:
        return fib_mp(x-1)+fib_mp(x-2)

@traced
def even_t(x):
    if x==0:
        return True
    else:
        return odd_t(x-1)

@traced
def odd_t(x):
    if x==0:
        return False
    else:
        return even_t(x-1)

@traced
def quicksort_t(l):
    if len(l)<=1:
        return l
    pivot=l[0]
    left=quicksort_t([x for x in l[1:] if x<pivot])
    right=quicksort_t([x for x in l[1:] if x>=pivot])
    return left+l[0:1]+right

@traced
@memoized
def quicksort_mt(l):
    if len(l)<=1:
        return l
    pivot=l[0]
    left=quicksort_mt([x for x in l[1:] if x<pivot])
    right=quicksort_mt([x for x in l[1:] if x>=pivot])
    return left+l[0:1]+right

class ChangeException(Exception):
    pass

@traced
def change_t(l,a):
    if a==0:
        return []
    elif len(l)==0:
        raise ChangeException()
    elif l[0]>a:
        return change_t(l[1:],a)
    else:
        try:
            return [l[0]]+change_t(l,a-l[0])
        except ChangeException:
            return change_t(l[1:],a)

@traced
@memoized
def change_mt(l,a):
    if a==0:
        return []
    elif len(l)==0:
        raise ChangeException()
    elif l[0]>a:
        return change_mt(l[1:],a)
    else:
        try:
            return [l[0]]+change_mt(l,a-l[0])
        except ChangeException:
            return change_mt(l[1:],a)


