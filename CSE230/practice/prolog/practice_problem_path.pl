% We are going to encode a graph over cities in Prolog. In particular, link(a,b) represents the fact that there is a path from city a city b.

link(san_diego, seattle).
link(seattle, dallas).
link(dallas, new_york).
link(new_york, chicago).
link(new_york, seattle).
link(chicago, boston).
link(boston, san_diego).

% Write a predicate path_2(A,B) which holds if there is path of length two from A to B. The path is allowed to have duplicates cities
path_2(H,V) :- link(H,T), link(T,V).

% Path_3 holds if there is a path of length three from A to B. The path is allowed to have duplicate cities.
path_3(H,V) :- link(H,T), link(T,E), link(E,V).

% Path _N(A,B,N) holds if there is a path of length N between A and B. The path is allowed to have duplicate cities, and you can assume that N is
% greater or equal to 1. 
path_n(A, B, N) :- N=1, link(A,B).
path_n(A, B, N) :- N>1, link(A,C), M is N-1, path_n(C,B,M).


% Path(A,B) is true if there is a path from A to B without cycles. You can use the build_in predicate member(X,L), which is true if X is an
% element of the list L

path(A,B) :- path_helper(A,B,[A]).

path_helper(A,B,Seen) :- link(A,B), not(member(B,Seen)).
path_helper(A,B,Seen) :- link(A,C), not(member(C,Seen)), path_helper(C,B,[C|Seen]).


sorted([]).
sorted([_]).
sorted([A,B|T]) :- A=<B, sorted([B|T]).

sort1(L1, L2) :- L2 = E, permutation(L1,E), sorted(E), !.

split([], [], []).
split([X], [X], []).
split([X|T], [X|L2], L1) :- split(T, L1, L2).

sat1(var(X)) :- X = 1. 
sat1(not(var(X))) :- X = 0.
sat1(and([])).
%% Fill in the other case(s) for ‘‘and’’ here:
sat1(and([X|Tail])) :- sat1(X), sat1(and(Tail)).
sat1(or([])) :- fail.
%% Fill in the other case(s) for ‘‘or’’ here:
sat1(or([X|Tail])) :- sat1(X). 
sat1(or([_|Tail])) :- sat1(or(Tail)).

bool(X) :- X = 0.
bool(X) :- X = 1.
bools([]).
bools([X|Tail]) :- bool(X), bools(Tail).

allsat(V,E) :- bools(V), sat1(E).


compress([],[]).
compress([X],[X]).
compress([H1,H2|T],R) :- (H1=H2), compress([H2|T],RR), R = RR.
compress([H1,H2|T],R) :- not(H1=H2), compress([H2|T],RR), R = [H1|RR].


sum([X],X).
sum([H|T],S) :- sum(T, RR), S is RR + H.


max(X,Y,X) :- X >= Y.
max(X,Y,Y) :- X < Y.

list_max([X],X).
list_max([A,B|T],R) :- max(A,B,S), list_max([S|T],RR), R = RR.
