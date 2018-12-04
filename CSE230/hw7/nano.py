#!/usr/bin/env python3

from misc import Failure

# prologable interface
class Prologable():
    def toProlog(self) -> str:
        raise Failure("SHOULD NOT GET HERE -- subclasses should override")

    def __eq__(self, other):
        if isinstance(other, Prologable):
            return self.toProlog() == other.toProlog()
        else:
            return False
    def __str__(self):
        return self.toProlog()


# expression interface
class Expression(Prologable):
    pass

# binop interface
class Bop(Prologable):
    pass
    
class Plus(Bop):
    def toProlog(self) -> str:
        return 'plus'
        
class Minus(Bop):
    def toProlog(self) -> str:
        return 'minus'
        
class Mul(Bop):
    def toProlog(self) -> str:
        return 'mul'
        
class Div(Bop):
    def toProlog(self) -> str:
        return 'div'
        
class Eq(Bop):
    def toProlog(self) -> str:
        return 'eq'
        
class Neq(Bop):
    def toProlog(self) -> str:
        return 'neq'
        
class Lt(Bop):
    def toProlog(self) -> str:
        return 'lt'
        
class Leq(Bop):
    def toProlog(self) -> str:
        return 'leq'
        
class And(Bop):
    def toProlog(self) -> str:
        return 'and'
        
class Or(Bop):
    def toProlog(self) -> str:
        return 'or'
        
class Cons(Bop):
    def toProlog(self) -> str:
        return 'cons'

# Expressions
class Const(Expression):
    def __init__(self, i: int):
        self.v = i
    def toProlog(self) -> str:
        return 'const(' + str(self.v) + ')'
        
class Bool(Expression):
    def __init__(self, b: bool):
        self.v = b
    def toProlog(self) -> str:
        return 'boolean(' + str(self.v).lower() + ')'
        
class NilExpr(Expression):
    def __init__(self):
        return
    def toProlog(self) -> str:
        return 'nil'
        
class Var(Expression):
    def __init__(self, v: str):
        self.v = v
    def toProlog(self) -> str:
        return self.v
    
class Bin(Expression):
    def __init__(self, l: Expression, o: Bop, r:Expression):
        self.l = l
        self.r = r
        self.o = o
    def toProlog(self) -> str:
        return 'bin(' + str(self.l.toProlog()) + ", " + self.o.toProlog() + ", " + str(self.r.toProlog()) + ')' 
    
class If(Expression):
    def __init__(self, c: Expression, t: Expression, f: Expression):
        self.c = c
        self.t = t
        self.f = f
    def toProlog(self) -> str:
        return 'ite(' + self.c.toProlog() + ", " + self.t.toProlog() + ", " + self.f.toProlog() + ')' 

class Let(Expression):
    def __init__(self, v: str, e: Expression, body: Expression):
        self.v = v
        self.e = e
        self.body = body
    def toProlog(self) -> str:
        return 'let(' + self.v + ", " + self.e.toProlog() + ", " + self.body.toProlog() + ')' 

class Letrec(Expression):
    def __init__(self, v: str, e: Expression, body: Expression):
        self.v = v
        self.e = e
        self.body = body
    def toProlog(self) -> str:
        return 'letrec(' + self.v + ", " + self.e.toProlog() + ", " + self.body.toProlog() + ')' 

class App(Expression):
    def __init__(self, f: Expression, arg: Expression):
        self.f = f
        self.arg = arg
    def toProlog(self) -> str:
        return 'app(' + self.f.toProlog() + ", " + self.arg.toProlog() + ')' 

class Fun(Expression):
    def __init__(self, v: str, body: Expression):
        self.v = v
        self.body = body
    def toProlog(self) -> str:
        return 'fun(' + self.v + ", " + self.body.toProlog() + ')' 


# Types

class Type(Prologable):
    pass

class IntTy(Type):
    def __init__(self):
        return
    def toProlog(self) -> str:
        return 'int'

class BoolTy(Type):
    def __init__(self):
        return
    def toProlog(self) -> str:
        return 'bool'

class ArrowTy(Type):
    def __init__(self, l: Type, r: Type):
        self.l = l
        self.r = r
    def toProlog(self) -> str:
        return 'arrow(' + self.l.toProlog() + ',' + self.r.toProlog() +  ')'

class ListTy(Type):
    def __init__(self, inner: Type):
        self.inner = inner
    def toProlog(self) -> str:
        return 'list(' + self.inner.toProlog() + ')'

class VarTy(Type):
    def __init__(self, name: str):
        self.name = name
    def toProlog(self) -> str:
        return self.name

