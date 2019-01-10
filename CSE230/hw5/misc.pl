%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helpers

%isin(X,L) is true if X appears in L
isin(X,[X|_]).
isin(X,[_|T]) :- isin(X,T).

% zip(L1,L2,L3) is true if L3 is the result of interleaving L1 and L2
% e.g. zip([1,2],[3,4],[1,3,2,4])   is true
zip([],[],[]).
zip([H1|T1],[H2|T2],[H1,H2|T]) :- zip(T1,T2,T).

% assoc(L,K,V) is true if L is a list of 2-element lists and one of them is [K,V]
% e.g. assoc([[key1,value1],['a',1],[3,4]], 3, 4) is true
assoc([[X,Y]|_],X,Y).
assoc([_|T],X,Y) :- assoc(T,X,Y).

% remove_duplicates(L1,L2) is true if L2 is the result of removing all duplicate elements from L1.
% The remaining elements should be in the original order.
% e.g. remove_duplicates([1,1,2,2,3,3,4,4],[1,2,3,4]) is true
clean([],Soln,Y) :- reverse(Y,Soln).
clean([H|T],Soln,Y) :- isin(H,Y),!,clean(T,Soln,Y).
clean([H|T],Soln,Y) :- clean(T,Soln,[H|Y]).
remove_duplicates(L1,L2) :- clean(L1,L2,[]). 

% union(L1,L2,L3) is true if L3 is the set union of L1 and L2. 
% There should be no duplicates in L3.
% e.g. union([1,2,3],[2,3,4],[1,2,3,4]) is true
union(L1,L2,L3) :- append(L1,L2,L),remove_duplicates(L,L3). 

% intersection(L1,L2,L3) is true if L3 is the set intersection of L1 and L2.
% There should be no duplicates in L3.
% e.g. intersection([1,2,3],[2,3,4],[2,3]) is true
its([],_,X,Y) :- reverse(X,Y).
its([H|T],L,X,Y) :- isin(H,L),!,its(T,L,[H|X],Y).
its([_|T],L,X,Y) :- its(T,L,X,Y).
intersection(L1,L2,L3) :- its(L1,L2,[],L3).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 1: Facts

cost(carne_asada,3).
cost(lengua,2).
cost(birria,2).
cost(carnitas,2).
cost(adobado,2).
cost(al_pastor,2).
cost(guacamole,1).
cost(rice,1).
cost(beans,1).
cost(salsa,1).
cost(cheese,1).
cost(sour_cream,1).
cost(taco,1).
cost(tortilla,1).
cost(sopa,1).


ingredients(carnitas_taco, [taco,carnitas, salsa, guacamole]).
ingredients(birria_taco, [taco,birria, salsa, guacamole]).
ingredients(al_pastor_taco, [taco,al_pastor, salsa, guacamole, cheese]).
ingredients(guacamole_taco, [taco,guacamole, salsa,sour_cream]).
ingredients(al_pastor_burrito, [tortilla,al_pastor, salsa]).
ingredients(carne_asada_burrito, [tortilla,carne_asada, guacamole, rice, beans]).
ingredients(adobado_burrito, [tortilla,adobado, guacamole, rice, beans]).
ingredients(carnitas_sopa, [sopa,carnitas, guacamole, salsa,sour_cream]).
ingredients(lengua_sopa, [sopa,lengua,beans,sour_cream]).
ingredients(combo_plate, [al_pastor, carne_asada,rice, tortilla, beans, salsa, guacamole, cheese]).
ingredients(adobado_plate, [adobado, guacamole, rice, tortilla, beans, cheese]).

taqueria(el_cuervo, [ana,juan,maria], 
        [carnitas_taco, combo_plate, al_pastor_taco, carne_asada_burrito]).

taqueria(la_posta, 
        [victor,maria,carla], [birria_taco, adobado_burrito, carnitas_sopa, combo_plate, adobado_plate]).

taqueria(robertos, [hector,carlos,miguel],
        [adobado_plate, guacamole_taco, al_pastor_burrito, carnitas_taco, carne_asada_burrito]).

taqueria(la_milpas_quatros, [jiminez, martin, antonio, miguel],  
        [lengua_sopa, adobado_plate, combo_plate]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 1: Rules

%Write a Prolog predicate available_at(X,Y) is true if the item X is available at the taqueria Y
available_at(X,Y) :- taqueria(Y, _, T), isin(X,T).

% multi_available(X) is true if the item X is available in more than one place. 

multi_available_helper(X) :- available_at(X,Y), available_at(X,Z), Y\=Z. %helper function
multi_available(X) :- bagof(Y, multi_available_helper(Y), Z), remove_duplicates(Z,R), isin(X,R).

% overworked is true the person X works at more than one taqueria
overworked_helper(X, Y) :- taqueria(Y, Z, _), isin(X, Z) .
overworked(X) :- bagof(Y, overworked_helper(X,Y), B), B = [_, _|_]. 

% Prolog predicate total_cost(X,K) that is true if the sum of the costs of the ingredients of item X is equal to K
helper_total_cost([],K) :- K is 0. % base case
% Recursive function that find the total cost recursively
helper_total_cost([H|T], K) :- cost(H,HEAD), helper_total_cost(T,TAIL), K is HEAD + TAIL.
total_cost(X,K) :- ingredients(X,Y), helper_total_cost(Y,K).

% Prolog predicate has_ingredients(X,L) that is true if the item X has all the ingredients listed in L
%helper_has_ingredients([], L). % base case 
%helper_has_ingredients([H|T], L):- isin(H,L), helper_has_ingredients(T,L).
%has_ingredients(X,L) :- ingredients(X,Y) , helper_has_ingredients(L,Y).
has_ingredients(X,L) :- ingredients(X,L1), union(L1,L,L1).

% Prolog predicate avoids_ingredients(X,L) that is true if the item X does not have any of the ingredients listed in L
%% helper_avoids_ingredients([], L). %base case
%% helper_avoids_ingredients([H|T], L) :- not(isin(H,L)), helper_avoids_ingredients(T,L).
%% avoids_ingredients(X,L) :- ingredients(X,Y), helper_avoids_ingredients(L,Y). 
avoids_ingredients(X,L) :- ingredients(X,L1), intersection(L1,L,[]). 

% Helper function p1 for find_items;
p1(L,X) :-  bagof(Y , has_ingredients(Y,X),L). 

% Helper function p2 for find_items;
p2(L,Y) :- bagof(X, avoids_ingredients(X,Y),L). 

% find_items(L,X,Y) is true if L is the list of all items that contain all the ingredients in X and do not contain any 
% of the ingredients in Y 
find_items(L,X,Y) :- p1(L1,X),p2(L2,Y),intersection(L1,L2,L).  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
