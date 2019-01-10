def argmap(l):
  def real_decorator(f):
    def wrapper(*args):
      m = min(len(l),len(args))
      new_t = []
      for i in range (0, m):
        new_t.append(l[i](args[i]))
      t = tuple(new_t)
      return f(*t)
    return wrapper
  return real_decorator

def double(x):
    return x * 2

def incr(x):
    return x + 1

@argmap([double, incr])
def f(a,b):
    return a + b;
    

@argmap([double, incr])
def g(a):
    return a + 1;
print (f(6,10))
print (g(5))


def compose(deco1, deco2):
    def real_decorator(f):
        wrapper(*args):
        return deco1(deco2(f))
    return real_decorator
