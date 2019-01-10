(* CATEGORY 1 complicated data structure question *)
(* Fall 13, expressions *)
type expr =
  | Var of string
  | Const of int
  | Plus of expr * expr

(* Write a function simpl: expr -> expr which simplifies additions of constants.*)
(* let rec simpl = failwith "TODO" *)


(*Winter 12, dictionaries*)

(* In this question you are going to implement a dictionary which maps maps strings to integers,
and is represented as an OCaml list of pairs *)

(* The first element of each pair is the
key
and the second element is the
value
.  There is at most one entry in the
dictionary for a given key.  Also, the list which represents the dictionary is
sorted
in increasing order of keys.
You can use =, <, <=, >, >=
for string comparison. *)

(* Fill  in  the  implementation  of
find: (string*int) list -> string -> int
.   Given  a
dictionary
d
and a key
k
,
find d k
returns the value for the give key, or raises
Not_found
if the key is
not found (by using the command
raise Not_found
).  Ideally, we would use a binary search, but since
we’re using a linked list (which does not support efficient direct access), you should instead do a linear
search.  However, for full credit, use the sortedness property to stop the search as early as possible. *)

(* let rec find d k =
  match d with
    | [] -> failwith "Not_found" (* raise Not_found *)
    | (k’,v’) :: t -> failwith "TODO" *)

(* Fill in the implementation of add: (string*int) list -> string -> int -> (string*int) list.
Given a dictionary d, key k and value v, add d k v
returns a new dictionary where the key k is bound to v.  If the key already exists, the value for that key is updated. *)

(* let rec add d k v =
  match d with
    | [] ->  failwith "TODO"
    | (k’,v’) :: t -> failwith "TODO" *)

    (* Use map to   write   a   function keys:(string*int) list -> string list. Given a dictionary d, keys d should return a list of the keys. *)
(* let keys = failwith "TODO" *)

(*
Fill  in  the  implementation  of key_of_max_val:(string*int)list -> string by  using fold_left. 
Given  a  dictionary d,
key_of_max_val d returns  the  key  of  the  maximum  value  in  the dictionary  (or  raises Not_found
if  there  are  no  entries  in  the  dictionary). *)

(* let key_of_max_val = failwith "TODO" *)

(* Winter 11, more dictionaries *)
type 'a dict = Empty | Node of string * 'a * 'a dict * 'a dict

(* Notice that the tree is
Binary-Search-Ordered
meaning that for each node with a key k, the keys in the
left subtree are (in alphabetical order) less than k,
and the keys in the right subtree are (in alphabetical order)
greater than
k *)

(* starter code: *)
(* let rec find d k = 
  match d with
  | Empty -> failwith "Not_found" (* raise Not_found *)
  | Node (k', v', l, r) ->
    if k = k' then failwith "TODO" else 
    if k < k' then failwith "TODO" else 
    (* k > k' *)   failwith "TODO" *)

let rec find d k = 
  match d with
  | Empty -> failwith "Not_found" (* raise Not_found *)
  | Node (k', v', l, r) ->
    if k = k' then v' else 
    if k < k' then find l k else 
    (* k > k' *)   find r k

  (* starter code *)
(* let rec add d k v = 
  match d with
  | Empty -> failwith "TODO"
  | Node (k', v', l, r) ->
    if k = k' then failwith "TODO" else 
    if k < k' then failwith "TODO" else 
    (* k > k' *)   failwith "TODO" *)

let rec add d k v = 
  match d with
  | Empty -> Node (k, v, Empty, Empty)
  | Node (k', v', l, r) ->
    if k = k' then Node (k, v, l, r) else 
    if k < k' then Node (k', v', add l k v, r) else 
    (* k > k' *)  Node (k', v', l, add r k v)

(* starter code *)

(* let rec fold f b d = 
  match d with
  | Empty -> 
    failwith "TODO"
  | Node (k, v, l, r) ->
    failwith "TODO" *)
let rec fold f b d = 
  match d with
  | Empty -> 
    b
  | Node (k, v, l, r) ->
    let lv = fold f b l in
    let me = f k v lv in 
    fold f me r

let fruitd =
  Node ("grape", 2.65,
    Node ("banana", 1.50,
      Node ("apple",  2.25, Empty, Empty),
      Node ("cherry", 2.75, Empty, Empty)),
    Node ("orange", 0.75,
      Node ("kiwi",   3.99, Empty, Empty),
      Node ("peach",  1.99, Empty, Empty)))

(* find fruitd "cherry" *)

let d0 = fruitd;
let d1 = add d0 "banana" 5.0;;
let d2 = add d1 "mango" 10.25;;

(* (find d2 "banana", find d2 "mango", find d2 "cherry");; *)

(* fold (fun k v b -> b^","^k) "" fruitd;; *)
(* fold (fun k v b -> b +. v) 0.0 fruitd;; *)
let rec fold f b d =
  match d with
    | Empty -> b
    | Node(k, v, l, r) -> let b1 = fold f b l in
                            let b2 = f k v b1 in
                              let b3 = fold f b2 r in b3;;


(* Winter 11, python namespaces *)


(* Spring 13, trees *)

 (* A tree is either the empty tree, or a
node containing a data value and a list of children. *)
type 'a tree =
  | Empty
  | Node of 'a * 'a tree list;;

(* You will write a function
tree_zip : ’a tree -> ’b tree -> (’a * ’b) tree
, which takes two trees having
the same structure and combines them into one tree.  Each element of the returned tree is a pair containing
the corresponding elements of the two input trees. *)

(* If the two input trees do not have a similar structure (in that one tree has an element for which there is no
corresponding element in the other tree), then
tree_zip
should raise the exception
Mismatch
.
To implement
tree_zip
, your must make use of the following two functions:
•
tree_zip
needs to use
map : (’a -> ’b) -> ’a list -> ’b list
•
tree_zip
needs to use the following
zip
function on lists: *)
(* let rec zip l1 l2 =
  match (l1,l2) with
    | ([],[]) -> []
    | (h1::t1, h2::t2) -> (h1,h2)::(zip t1 t2)
    | _ -> raise Mismatch;; *)


(* let rec tree_zip t1 t2 =
  match (t1,t2) with 
    | _ -> failwith "TODO" *)


(* CATEGORY 2 map/fold_left *)

(* Spring 13, count *)
(* Use
fold_left
to implement
count : (’a -> bool) -> ’a list -> int
, which takes a
boolean tester
f
and a list and returns the number of elements in the list for which
f
returns true. *)
(* let count f l = failwith "TODO" *)

(* Spring 13, stretch. *)
(* Use
fold_left
to  implement
stretch : ’a list -> ’a list
,  which  takes  a  list  and
duplicates each element in the list.  The elements in the returned list should be in the same order as in
the original list.  Do not use
List.rev
. *)

(* let stretch l = failwith "TODO" *)

(* Winter 13, sum_matrix*)
(* You will use
fold
to write a function
sum_matrix:int list list -> int
which takes a matrix and sums up
all the integers in the matrix.  For example: *)
(* let sum_matrix m = failwith "TODO" *)

(* CATEGORY 3 recursion *)
(* Fall 13, insertion sort with duplicates *)
(* First, you will implement insertion into a sorted list.  Given a sorted list l and an integer i, (insert l i) returns a sorted list which contains all the elements of l, and in addition also contains the integer i (note that duplicates are allowed). 
*)

(* let rec insert = failwith "TODO" *)

(* Now you will implement insertion sort using
fold_left
.  Recall that the type of
fold_left
is given below:
fold_left: (’a -> ’b -> ’a) -> ’a -> ’b list -> ’a
Fill in the implementation below using
fold_left: 
*)

(* let insertion_sort = failwith "TODO" *)