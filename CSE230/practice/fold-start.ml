(*

For this section, we will cover map and fold_left in detail. The outline:

1), a brief recap of the definition of fold_left.
2), a number of easy fold_left problems.
3), a number of harder map problems.
4), a number of harder fold_left problems.

HINT: A lot of these problems were pulled from past midterms! You'll probably
see a map and/or fold_left problem on the midterm :).


*)

(*

1): THE DEFINITION OF FOLD_LEFT

The idea behind fold_left is that some functions *need* to be recursive, but
it's easy to make errors with recursion. For general list-processing, fold_left
abstracts over the recursion

let rec recFunc xs = match xs with
  | []  -> ...base case...
  | h:t -> ...recursive case, a function of h and *the result so far*...

for example, sumInts:
let rec sumInts xs = match xs with
  | []  -> 0
  | h:t -> h + (sumInts t)

fold_left abstracts over the pattern matching and recursion and takes as input
the worker function for the recursive case, the base case, and the list to fold over:

fold_left : ('a -> 'b -> 'a) ->  'a       -> list 'b -> 'a
                  ^^             ^^             ^^
            recursive case    base case     input list

graphically, this looks like:
https://upload.wikimedia.org/wikipedia/commons/5/5a/Left-fold-transformation.png

(the "left" in fold_left refers to the fact that the list is processed in a left-associated
manner, i.e. from left-to-right. Don't think too much about it.)

  fold f base [e1;e2;e3] <=> f (f (f base e1) e2) e3)

  (f base e1) becomes the accumulator for next f. 

*)

(*
2): Some easy left-folds. These all take the form of

let func xs =
  let base = failwith "TODO" in
  let worker acc next = failwith "TODO" in
  fold worker base xs

*)

(* first, an alias *)
let map = List.map
let fold = List.fold_left

(* count: given a list, count the elements in the list
*)

let count xs =
  let base = 0 in
  let worker acc next = acc + 1 in
  fold worker base xs

(* filter: given a predicate to apply to a list, take only the elements that satisfy
  the predicate.
*)

(* let [1; 2; 3]
filter (fun x -> x < 3) test = [1;2] *)

(* algorithm:
for x in xs:
  if pred of x then add to acc otherwise acc
  *)
let filter pred xs =
  let base = [] in
  (* if pred of x then add to acc otherwise acc  *)
  let worker acc next = 
    if pred next then acc@[next] else acc
  in
  fold worker base xs

(* average: given a list of ints, average the elements of the list.
*)

let average xs =
  let base = 0 in
  let worker acc next = acc +. next in
  let ret = fold worker base xs in
  ret/(List.length xs)

(* Using Float insteaf of int *)
(* let average xs =
  let base = 0.0 in
  let worker acc next = acc +. next in
  let ret = fold worker base xs in
  ret/.(float_of_int (List.length xs));;
val average : float list -> float = <fun> *)


(* zipWithIndex: given a list of elements, add an index to each element. *)

(* [4;8;4] => [(4,0); (8,1); (4,2)] *)

(* for x in xs:
  ret.append((x,count))
  count++ *)

let zipWithIndex xs =
  let base = ([],0) in
  let worker acc x = 
    let l,i = acc in
      (l@[(x, i)], i+1)
  in
  let (ret, _) = fold worker base xs in ret

(* zip: given two lists, merge the lists into a list of pairs.
(this is also the library function List.combine and is useful for your homework.)
*)

(* let (tl, tr) = ([1;2;3] [4;5;6])

zip tl tr = [(1,4); (2,5); (3,6)]

unzip [(1,4); (2,5); (3,6)]  = ([1;2;3] [4;5;6])
*)

(* for (eleml, elemr) in l, r:
  ret <- (eleml, elemr) *)

let zip l r =
  let base = [] in
  let worker acc next = 
    let (ele,idx) = next in 
      acc@[(ele, List.nth r idx)] 
  in
  fold worker base (zipWithIndex l);;

(* unzip: given a list of pairs, return a pair of unzipped lists.
(this is also the library function List.split.)
*)

let unzip xs = 
  let base = ([], []) in 
  let worker acc next = 
    let (l1,l2) = acc in
      let (e1, e2) = next in
      (l1@[e1], l2@[e2])
  in
  fold worker base xs;;


(*

3) Harder map problems.

*)



let rec helper tup hi = 
  let (x1, x2) = tup in 
    if x2 > hi then x1
    else helper (x1@[x2], x2+1) hi;;
(* range: given a start and a finish, produce a list from start to finish. *)
let range lo hi = 
  helper ([], lo) hi;;
  

(* buildMatrix: given a list of (lo, hi) tuples for elements build a matrix where each
row is the list lo-to-hi.
*)
let buildMatrix ranges =
  let base = [] in
  let worker acc next = 
    let (lo,hi) = next in
      acc@[(range lo hi)]
  in 
  fold worker base l;;


(*

4) Harder fold problems.

*)

(* ith: given a list and an index, return the ith element of the list. *)
(* ith [1;2;3] 1 = 2 *)

(* for x in xs:
  if x.index ??? == idx then return x *)


let ith xs idx =
  let base = (0,0) in
  let worker acc next =
    let e,i = acc in 
      if i = idx then (next, i+1) 
      else (e, i+1)
  in let (res,_) = fold worker base xs in res

(* Modified version with default value *)
let ith xs idx d=
  let base = (0,0) in
  let worker acc next =
    let e,i = acc in 
      if i = idx then (next, i+1) 
      else (e, i+1)
  in let (res,_) = fold worker base xs in res

(* Modified version with default value *)
let ith_2 xs idx d=
  let base = (d,0) in
  let worker acc next =
    let e,i = acc in 
      if i = idx then (next, i+1) 
      else (e, i+1)
  in let (res,_) = fold worker base xs in res

(* redo ith function with cutomize fold function : fold_2 *)
(*
 * Rewrite the fold function 
 * fold_2 = (`a -> `b -> int -> `a) -> (`a -> `b list -> `a+)
 *)
let rec fold_2 f b l =
	match l with
  | [] -> b
  | x::xs -> fold_2 f (f b x ((List.length l) - (List.length xs) + 1)) xs;;

let ith_3 xs idx d=
  let base = d in
  let worker acc next i =
      if i = idx then next
      else acc
  in fold_2 worker base xs;;


(* update: given a list, an index, and a new element, replace the
element at position index with the new element. *)
let update xs idx newElem =
  let base = ([], 0) in
  let worker acc next =
    let (l,i) = acc in
      if i = idx then (l@[newElem], i+1)
      else (l@[next], i+1)
  in
  let (res, _ ) = fold worker base xs in res;;

(* stretch: given a list, replace each occurance of an element with a duplicate
e.g. [1; 2] => [1; 1; 2; 2]
*)
let stretch xs = 
  let head = List.hd xs in
    let base = ([], _, xs) in
    let worker acc next = 
      let (l, p, c) = acc in
        if c = 0 then (l@[next], next, 1)
        else (l@[], p, 0)
  in
  fold worker base xs;;


  let stretch xs = 
    let base = [] in
    let worker acc next = 
        acc@[next]@[next]
  in
  fold worker base xs;;

(* sum_matrix: given a matrix, sum up the values in the matrix.
*)
let sum_matrix mat 
