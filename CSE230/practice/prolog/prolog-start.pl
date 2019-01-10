% Simple Facts - geneaology
% Programming in Prolog is much different from
% programming in normal languages. Our "program" is a
% combination of base facts and rules based upon which we can infer more facts.
% The way we "run" it, is by loading it in Prolog, and asking queries to it.
% In a way its like a database. So lets begin with a simple example:

human(peter).
human(don).
human(jenifer).
human(elizabeth).


% 'human' is a basic predicate. We know its true for peter, don, jenifer and
% elizabeth, and is false for all other constants. Now lets try loading it up
% in Prolog:
% 
% 
% $ prolog misc.pl 
% misc.pl compiled 0.00 sec, 5 clauses
% Welcome to SWI-Prolog (Multi-threaded, 64 bits, Version 6.6.4)
% Copyright (c) 1990-2013 University of Amsterdam, VU Amsterdam
% SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software,
% and you are welcome to redistribute it under certain conditions.
% Please visit http://www.swi-prolog.org for details.
%
% For help, use ?- help(Topic). or ?- apropos(Word).
%
% ?- human(don).
% true.
% ?- human(dimo).
% false.
%
%
% However just asking simple questions gets boring. Lets try something else:
%
%
% ?- human(X).
% X = peter .
% 
% ?-
%
% This time instead of specifying a specific constant in our query, we left it
% as a new unbound variable X. Note that in Prolog variables always start with a
% captial letter. We left it up to Prolog to find us a satisfying value for X.
% However peter is just one example of a satisfying value for X. What if we
% wanted to see more? Note that when we type:
%
% % ?- human(X).
%
%
% And press ENTER, prolog prints out:
%
% ?- human(X).
% X = peter 
%
%
% And waits. This means that it found one solution, and gave it to us, but
% there are potentially more solutions. If we now press ENTER, we will go back
% to the prompt. If we press TAB however, we will ask prolog to keep looking for
% another solution. So now try human(X) again, but keep pressing TAB until you
% get back to the prompt. You should see the following:
%
%
% ?- human(X).
% X = peter ;
% X = don ;
% X = jennifer ;
% X = elizabeth.
%
% ?- 
%
% Next lets try to define the parent relation:

parent(don, peter).
parent(jenifer, don).
parent(elizabeth, jenifer).

% We just stated that don is peters dad, jenifer is dons mom and elizabeth is
% jenifers mom. 
% We can load it up again in Prolog and try it out.
% 
% ?- parent(don, peter).
% true.
% 
% ?- parent(elizabeth, don).
% false.
% Next lets try and define the "ancestor" relation. At this point we have
% to start thinking inductively. To define the relation "X is an ancestor of Y"
% we need a base case and an inductive case. The base case is, when X is a 
% parent of Y. The inductive case, is when there is another Z, such that X is a
% parent of Z, and Z is an ancestor of Y. And this is how we express this in
% Prolog:
ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(X,Z), parent(Z,Y).

% Note that these statements look different. For starters, they have the ":-"
% symbol. These are rules. The primitive statements we had before are "facts".
% While facts just state some basic knowledge (e.g. peter and don are humans.
% Don
% is peters father), rules allow us to derive more facts from the base facts.
% Note that we have two rules for ancestor. You can think of those as if they
% are
% OR-ed. That is, X is an ancestor of Y, if it matches either the first or
% second
% rule. The second rule, has two parts on the right hand side, separated by a
% comma. You can think of the comma as an AND. That is, the second rule states
% that X is an ancestor of Y, if X is a parent of some Z AND Z is an ancestor of
% Y.
%
% Lets try our new rule out in Prolog (after of course loading the file again):
%
% ?- ancestor(don, peter).
% true .
% 
% ?- ancestor(elizabeth, peter).
% true .
% 
% ?- ancestor(peter, don).
% false.
% 
% ?- 
% 
% To solidify our understanding of how Prolog works, lets see what it does %
% step by step, when we ask it if its true that ancestor(elizabeth, peter) holds.
% To do so we will turn on tracing using the trace command (more details
% http://www.cse.unsw.edu.au/~billw/dictionaries/prolog/tracing.html):
%
% ?- trace
% |    .
% true.
% 
% [trace]  ?- ancestor(elizabeth, peter).
%1     Call: (6) ancestor(elizabeth, peter) ? creep
%2     Call: (7) parent(elizabeth, peter) ? creep
%3     Fail: (7) parent(elizabeth, peter) ? creep
%4     Redo: (6) ancestor(elizabeth, peter) ? creep
%5     Call: (7) parent(elizabeth, _G3002) ? creep
%6     Exit: (7) parent(elizabeth, jenifer) ? creep
%7     Call: (7) ancestor(jenifer, peter) ? creep
%8     Call: (8) parent(jenifer, peter) ? creep
%9     Fail: (8) parent(jenifer, peter) ? creep
%10    Redo: (7) ancestor(jenifer, peter) ? creep
%11    Call: (8) parent(jenifer, _G3002) ? creep
%12    Exit: (8) parent(jenifer, don) ? creep
%13    Call: (8) ancestor(don, peter) ? creep
%14    Call: (9) parent(don, peter) ? creep
%15    Exit: (9) parent(don, peter) ? creep
%16    Exit: (8) ancestor(don, peter) ? creep
%17    Exit: (7) ancestor(jenifer, peter) ? creep
% 18   Exit: (6) ancestor(elizabeth, peter) ? creep
% true .
%
% Ive added line numbers for convenience. Lets call the first rule for
% ancestors above R1 and the second R2.  At line (1) we start by tring the first
% rule for ancestor. R1 holds if they are parents, so we check if
% parent(elizabeth, peter) holds (2). That fails (3) and on line (4) we re-try to
% prove that ancestor(elizabeth, peter) holds using R2. R2 first calls "parent(X,
% Z)" with X=elizabeth trying to find elizabeth's child.  This returns (7) with
% Z=jenifer, and as the second part of R2 (after the comma), we inductively apply
% the rule ancestor this time with Z and Y (jenifer and don). We continue
% inductively first trying R1 and then R2, until all the way at line 13 we try to
% see if ancestor(don,peter) is true by R1, which succeeds on line 16.
% The important takeaway here is, that prolog merely tries to apply the rules
% weve provided it exhaustively, trying to match any variables we left
% unspecified.

% Comparisons
% Prolog features the normal comparison operators, although their syntax is a
% bit weird. You can check that two things are the same using ==, and different
% using \==, less than @< and greater than - @. etc. (full detail here:
% http://www.swi-prolog.org/pldoc/man?section=compare). Lets try them out in Prolog. Try the following:
% 
% ?- 1 == 1.
% true.
% 
% ?- 1 == 2.
% false.
% 
% ?- 1 \== 2
% |    .
% true.
% 
% ?- 1 @< 2.
% true.
% 
% ?- 1 @> 2.
% false.
% 
% So far no surprise. Now what happens if we compare a number with a human?
%
% 
% ?- don @> 1.
% true.
% 
% ?- don @< 1.
% false.
% 
% What??? Why did that work? It turns out that Prolog defines a global ordering
% on ALL values. So you can compare ANY two values in Prolog. Even lists and
% numbers!
%
% ?- 1 @< [1,2,3]
% |    .
% true.
% 
% ?- 1 @< [0].
% true.
% 

% Arithmetic
% Next lets do some arithmetic. Prolog provides some basic arithmetic capabilities using the "is" keyword. For example:
% 
% ?- 2 is 2 .
% true.
% 
% ?- 2 is 1+1
% |    .
% true.
% 
% ?- 10 is 2*5.
% true.
% 
% ?- 3 is 1 + 1.
% false.
% 
% ?- X is  1 + 1.
% X = 2.
% 
% Note that the arithmetic expression can only appear on the RIGHT hand side of the is. Things on the left hand side are not considered to be expressions, so you may see confusing things like:
% 
% ?- (1+1) is 2.
% false.
% 

% Lists
% hd, tl, length.
%
% Prolog also provides us with lists. Lists are again enclosed with square
% brackets, but unlike OCaml their items are comma separated. So we can do things
% such as:
% 
% ?- [1,3] @> [1,2].
% true.
% 
% ?- [1,4] @< [1,2,3].
% false.
% 
% ?- [1,2,3] == [1,2,3].
% true.
% 
% We can also match the head and tail of a list in rules like so [HD|TL]. Note
% again that since HD and TL are variables, they need to start with a capital
% letter. So lets define a simple head and tail predicates:

hd([H|T], TODO).
tl([H|T], TODO).

%
% Note that while these look like basic facts they actually behave kind of like
% rules. That is, just by template matching on the arguments, we can generate
% many basic facts. Lets try them out:
%
% 
% ?- hd([1,2,3],1).
% true.
% 
% ?- tl([1,2,3], [2,3]).
% true.
% 
% ?- hd([1,2,3], 2).
% false.
% 
% Next lets combine our knowledge of arithmetic and lists and write a length
% function. Similarly to OCaml this is inductively defined. The base case is the
% empty list:

mylength([], TODO).

% And for the inductive case we have:

mylength([H|T], TODO).

% TODO: Show the problem with 
% 
% mylength([H|T], V) :- V is VT-1, mylength(T, VT).

% So lets try it out:
% ?- mylength([1,2,3], X).
% X = 3.
% 
% ?- mylength([], X).
% X = 0.
% 

%
% Factorial
%
% Next we will define factorial in 2 ways - with and without lists. First lets
% defined it without lists. As usual we follow our usual inductive definition.
% Base case:

factorial(0,TODO).

% And inductive case:
factorial(N,TODO).

% Note that we first begin by constructing N-1. As mentioned earlier, our
% choice of which variable to introspect/destruct first, implicitly determines
% which variable we expect to be given. If we tried to use factorial() in the
% reverse way, it would fail:

% 
% ?- factorial(X, 120).
% ERROR: factorial/2: Arguments are not sufficiently instantiated
%

%
% Next lets write factorial by building a list with all the number in the range
% 1 to N, and then multiplying them. To do so we first define a helper predicate
% that computes the product of the numbers of a list.
%

product([], TODO).
product([H|T], TODO).

% Again lets take it out for a spin:
%
% ?- product([],X).
% X = 1.
% 
% ?- product([1,2,3],X).
% X = 6.
% 
% ?- product([1,2,3,4],X).
% X = 24.
% 
% ?- product([1,2,3,4,0],X).
% X = 0.
% 

% Now we need another predicate, that for a given N computes a list of the
% numbers [1..N]

range(0, []).
range(N, [N|T]) :- N1 is N-1, range(N1, T).

factorial2(N,TODO).

%
% bagof - subset
% Finally, to give an example of bagof, lets implement the set set_difference
% operation. set_diff(L1, L2, L3) should hold if L3=L1 - L2. That is L3 contains
% all the elements of L1 that are not also in L2. We can define this with the
% help of the isin predicate, and the bagof keyword. Lets first define isin:
%

%
% isin(E,L) holds if E exists in L
%

isin(H, [H|T]).
isin(H, [H1|T]) :- isin(H,T).


%
% Next how do we use the bagof function? bagof allows us to accumulate all the
% values that match a given predicate. (In a way its similar to filter). Lets
% look at a brief example. Lets mark the first 8 primes:
%

myprime(1).
myprime(2).
myprime(3).
myprime(5).
myprime(7).
myprime(11).
myprime(13).
myprime(17).

mylt(X,TODO).
myeven(TODO).

%
% We also defined versions of even and less than are restricted only to the %
% first 8 primes. Now, using bagof and these functions, we can select subsets of
% the first 8 primes. For example
%

% 
% ?- bagof(Z, mylt(Z, 10), B).
% B = [1, 2, 3, 5, 7].
%  

% Gives us all of the Z's that satisfy mylt(Z, 10) as a list in B. That is all
% of the first 8 primes that are less than 10.
%

%
% ?- bagof(Z, mylt(Z, 5), B).
% B = [1, 2, 3].
%

% The above gives us all of the ones less than 5, and:

% 
% ?- bagof(Z, myeven(Z), B).
% B = [2].
% 

% Gives us all of the even primes amongst the first 8.
% Q: How do you write a bagof() expression that gives us all of the primes for
% which myprime is true?


%
% Finally how do we use bagof to solve our problem? Where L1-L2 is all of the
% elements in L1, that are not in L2. That is all of the elements for which
% isin(_, L1) holds and isin(_, l2) doesn't. So lets define a helper predicate
% for that:
%

in_set_diff(X, L1, L2):- isin(X,L1), not(isin(X, L2)).

% Finally computing the set_difference is simple using bagof:

set_diff(TODO, TODO, TODO).

% And now we can take it out for a spin:
% 
% ?- set_diff([1,2,3,4], [2,3,5], X).
% X = [1, 4].
% 
% 

%
% Takeaway - simulating functions using predicates!!!
%
% Perhaps the most important takeaway of these examples, is the following. Take
% set_diff for example. In other languages, its a function that takes two
% arguments, and returns a third. However in Prolog we don't have function in the
% classical sense. We can only defined predicats (which are like function from
% something to {True, False}). So we defined set_diff instead as a predicate of 
% 3 lists, that is true only of the 3rd argument of the predicate is the
% difference of the first two. In this way we are using predicates to implement
% functions! Thus we can state the following simple principle: 
%
%
% For any computable function F: (A1,A2,...AN) -> R there exists a
% predicate P: (A1, A2,... AN, R) -> Boolean that is defined as P(a1,a2,...an,r)
% if and only if F(a1,a2,...,an) = r
%
% This is an important principle for thinking in a Prolog way :)



