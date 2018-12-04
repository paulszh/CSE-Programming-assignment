envtype([], Var, Ty).
envtype([[V,H]|_],Var,Ty) :- (H=Ty),(V=Var).
envtype(Bindings,Var,Ty) :- Bindings = [[V,H]|T], not(V=Var), envtype(T,Var,Ty). 

int_op(plus).
int_op(minus).
int_op(mul).
int_op(div).

comp_op(eq).
comp_op(neq).
comp_op(lt).
comp_op(leq).

bool_op(and).
bool_op(or).

typeof(_,const(_),X) :- integer(X).
typeof(_,boolean(_),X) :- boolean(X).
typeof(_,nil,X) :- fail.
typeof(Env,var(X),T) :- envtype(Env,X,T).

typeof(Env,bin(E1,Bop,E2),int) :- int_op(Bop), envtype(Env,E1,int), envtype(Env,E2,int).
typeof(Env,bin(E1,Bop,E2),bool) :- comp_op(Bop), envtype(Env,E1,int), envtype(Env,E2,int)
typeof(Env,bin(E1,Bop,E2),bool) :- bool_op(Bop), envtype(Env,E1,bool), envtype(Env,E2,bool).
typeof(Env,bin(E1,cons,E2),list(T)) :- fail.

% arrow(bool, arrow(int, int))
typeof(Env,ite(E1,E2,E3),T) :- fail.

% int 
typeof(Env,let(X,E1,E2),T) :- integer(E1), typeof(Env,var(X)).
typeof(Env,letrec(X,E1,E2),T) :- fail.
typeof(Env,fun(X,E),arrow(T1,T2)) :- fail.
typeof(Env,app(E1,E2),T) :- fail.