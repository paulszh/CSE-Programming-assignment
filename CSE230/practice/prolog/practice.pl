%%%%%%%%%%%%%%%%%%%
% Facts
%%%%%%%%%%%%%%%%%%%
% List of parent relationship
% Predicator symbol
parent(kim,holly). % Kim is a parent of holly
parent(pat,kim). % Pat is a parent of kim
parent(herbert,pat).
parent(alex,kim).
parent(felix,alex).
parent(albert,felix).
parent(albert,dana).
parent(felix,maya).

has_family(X) :- parent(X,_).
has_family(X) :- parent(_,X).

% The below two expressions are the same
% append(X,Y,R) :- X=[], R=Y.
% append(X,Y,R) :- [H|T] = X, TY = append(T, Y, TY), R = [H|TY]

append([],Y,Y). %if X is a emtpy list, return Y
append([H|T],Y,[H|TY]) :- append(T, Y, TY).

has2More([_,_|_]).

isin(_,[]) :- false.
isin(X,[X|_]).
isin(X,[H|T]) :- not(X=H), isin(X,T).

len(L,R).

% An example usage:
% parent(X,kim). solve for all variables that is the parent of kim
% parent(X,Y) find all parent child relationship

% t1 = t2.
% foo(bar) = foo(bar).
% foo(X) = foo(bar).
% foo(X,dog) = f(cat, Y).

% ?-  f(cat, Y) = f(X, dog).
% Y = dog,
% X = cat.


% Pattern match is bidrectional
% ?- a(W, foo(W,Y),Y) = a(2, foo(X,3), Z).
% W = X, X = 2,
% Y = Z, Z = 3.


% Conjunction : Mutliple things need to satisfy
%parent(pat, X), parent(X, holly).
%parent(X,Y) , parent(X,), parent()



typeof(_,const(_),X) :- X = int.
typeof(_,boolean(_),X) :- X = bool.
typeof(_,nil,X) :- X = list(_).
typeof(Env,var(X),T) :- envtype(Env, X, T).

typeof(Env,bin(E1,Bop,E2),int) :- int_op(Bop), typeof(Env, E1, int), typeof(Env, E2, int).
typeof(Env,bin(E1,Bop,E2),bool) :- comp_op(Bop), typeof(Env, E1, int), typeof(Env, E2, int).
typeof(Env,bin(E1,Bop,E2),bool) :- bool_op(Bop), typeof(Env, E1, bool), typeof(Env, E2, bool).
typeof(Env,bin(E1,cons,E2),list(T)) :- typeof(Env, E1, T).

typeof(Env,ite(E1,E2,E3),T) :- typeof(Env, E1, bool), typeof(Env, E2, T), typeof(Env, E3, T).
typeof(Env,let(X,E1,E2),T) :- typeof(Env, E1, T1), typeof([[X, T1] | Env], E2, T).
typeof(Env,letrec(X,E1,E2),T) :- typeof(Env, E1, T1), typeof([[X, T1] | Env], E2, T).
typeof(Env,letrec(X,E1,E2),T) :- typeof([ [X, T1] | Env], E1, T1), typeof([[X, T1] | Env], E2, T).

typeof(Env,fun(X,E),arrow(T1,T2)) :- typeof([[X, T1] | Env], E, T2).


typeof(Env,app(E1,E2),T) :- typeof(Env, E2, T2) , typeof(Env, E1, arrow(T2, T)).