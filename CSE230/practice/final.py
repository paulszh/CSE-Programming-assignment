#!/usr/bin/env python3

# CATEGORY 1: list comprehensions and functional python

# Spring 13, 5) reverse
# Winter 13, 3) matrices

# FA 13, 3) dictionaries

# CATEGORY 2: decorators

# FA 13, 4) in-range
# Spring 13, 6) print-some
# Winter 13, 5) lift to array
# Winter 12, 3) derivative

# class based

# @derivative(delta)
 # def double(x): return 2 * x
def derivative(delta):
  class derivative_inner(object):
    def __init__(self,f):
      self.__f = f
      self.__delta = delta
    def __call__(self, *args, **kargs):
      numer = self.__f(
          *[a + self.__delta for a in args],
          **{k:(v+self.__delta) for k,v in kargs.items()})
      numer = numer - self.__f(*args,**kargs)
      
      return round(numer / self.__delta,2)
  return derivative_inner

@derivative(0.0001)
def double_class(x): return 2 * x

# functional
def derivative_func(delta):
  def derivative_inner(f):
    def deriv_most_inner(*args, **kargs):
      numer = f(
          *[a + delta for a in args],
          **{k:(v+delta) for k,v in kargs.items()})
      numer = numer - f(*args,**kargs)
        
      return round(numer / delta,2)
    return deriv_most_inner
  return derivative_inner

@derivative_func(0.0001)
def double_func(x): return 2 * x

# Winter 11, 3) print_args

# CATEGORY 3: complicated datastructure

# Spring 13, 7) prolog unification
# Winter 13, 4) Game of Life
# Winter 12, 2) images
# Winter 11, 4) oimages

  
def print_k_arguments(k):
       def real_decorator(function):
         def wrapper(*args, **kwargs):
           for i in range(0,len(args)):
               if i < k:
                 print("Arg " + str(i) + ": " + str(args[i]))
           result = function(*args, **kwargs)
           print(result)
           return result
         return wrapper
       return real_decorator
       
@print_k_arguments(2)
def sum(a,b): return a + b


# Class Based approach
def print_some(l):
  class deco:
      def __init__ (self,f):
        self.f = f
      def __call__(self, *args):
        f(args)
        for i in l:
          if i >= 0 and i < len(args):
            print("Args: " + str(i) + ": " + str(args[i])
        rv = self.f(*args)
        if -1 in l:
            print("Return: " + str(rv)) 
        return rv
        
    
def argmap(l):
  def real_decorator(f):
    def wrapper(*args):
      m = min(len(l),len(args))
      new_t = []
      for i in range (0, m):
        new_t = l[i](args[i])
      return f(*tuple(new_t))
    return wrapper
  return real_decorator
  