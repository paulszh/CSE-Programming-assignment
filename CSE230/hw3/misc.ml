(* CSE 130: Programming Assignment 3
 * misc.ml
 *)

(* For this assignment, you may use the following library functions:

   List.map
   List.fold_left
   List.fold_right
   List.split
   List.combine
   List.length
   List.append
   List.rev

   See http://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html for
   documentation.
*)



(* Do not change the skeleton code! The point of this assignment is to figure
 * out how the functions can be written this way (using fold). You may only
 * replace the   failwith "to be implemented"   part. *)



(*****************************************************************)
(******************* 1. Warm Up   ********************************)
(*****************************************************************)

(*  sqsum : int list -> int
 *  The function takes in a list of integers and returns the sum of the square of each element
 *)
let sqsum xs = 
  let f a x = a + (x * x) in
  let base = 0 in
    List.fold_left f base xs

(* pipe : ('a -> 'a) list -> ('a -> 'a)
 * uses List.fold_left to get an OCaml function pipe : ('a -> 'a) list -> ('a -> 'a) . The function 
 * pipe takes a list of functions [f1;...;fn]) and returns a function f such that for any x, the 
 * application f x returns the result fn(...(f2(f1 x))). 
 *)
let pipe fs = 
  let f a x = fun y -> x(a y) in
  let base = fun y -> y in
    List.fold_left f base fs
    
(* sepConcat : string -> string list -> -> string
 * The function sepConcat is a curried function which takes as input a string sep to be used as a 
 * separator, and a list of strings [s1;...;sn]. If there are 0 strings in the list, then sepConcat 
 * should return "". If there is 1 string in the list, then sepConcat should return s1. Otherwise, 
 * sepConcat should return the concatination s1 sep s2 sep s3 ... sep sn
 *)
let sepConcat sep sl = match sl with 
  | [] -> ""
  | h :: t -> 
      let f a x = a ^ sep ^ x in
      let base = h in
      let l = t in
        List.fold_left f base l

(* stringOfList : ('a -> string) -> 'a list -> string
 * The first input is a function f: 'a -> string which will be called by stringOfList to convert each 
 * element of the list to a string. The second input is a list l: 'a list, which we will think of as 
 * having the elemtns l1, l2, ..., ln. Your stringOfList function should return a string representation 
 * of the list l as a concatenation of the following: "[" (f l1) "; " (f l2) "; " (f l3) "; " ... "; " 
 * (f ln) "]"
 *)
let stringOfList f l = "[" ^ (sepConcat) "; " (List.map f l) ^ "]"

(*****************************************************************)
(******************* 2. Big Numbers ******************************)
(*****************************************************************)

(* 
 * clone : 'a -> int -> 'a list
 * The function first takes as input x and then takes as input an integer n. 
 * The result is a list of length n, where each element is x. If n is 0 or negative, clone should return 
 * the empty list.
 *)
let rec clone x n = 
  if n <= 0 then []
  else x :: clone x (n-1)
;;

(* padZero : int list -> int list -> int list * int list 
 * The function takes two input lists, it adds zeros in front to make the lists equal
 *)
let rec padZero l1 l2 = 
  let diff = List.length(l1) - List.length(l2) in
    let base = clone 0 (abs(diff)) in
      if diff <= 0 then (base @ l1, l2)
      else (l1, base @ l2)
;;

(* removeZero : int list -> int list 
 * The function takes a list and removes a prefix of trailing zeros.  
 *)
let rec removeZero l = 
  match l with
  | [] -> l
  | h :: t -> 
    if h = 0 then removeZero t 
    else l


(*
 * bigAdd : int list -> int list -> int list
 * It takes two integer lists, where each integer is in the range [0..9] and returns the list 
 * corresponding to the addition of the two big integers 
 *)

let bigAdd l1 l2 = 
  let add (l1, l2) = 
    let f a x = 
      let (carry, sum) = a in
      let (x1, x2) = x in
      let s = x1 + x2 + carry in (s/10, (s mod 10) :: sum) in
    let base = (0, []) in
    let args = List.combine (List.rev(0::l1)) (List.rev(0::l2)) in
    let (_, res) = List.fold_left f base args in
      res
  in 
    removeZero (add (padZero l1 l2))
;;


(*
 * mulByDigit : int -> int list -> int list
 * It takes an integer digit and a big integer, and returns the big integer list which is the 
 * result of multiplying the big integer with the digit
 *)
let rec mulByDigit i l = 
    if i <= 0 || i > 9 then [] 
    else if i = 1 then l
    else bigAdd (mulByDigit (i-2) l) (bigAdd l l )
;;

(*
 * bigMul : int list -> int list -> int list
 * This function multiplies two numbers and return a list of digits
 *)
let bigMul l1 l2 = 
  let f a x =   
    let (shift, sum) = a in
    let (temp, digit) = x in
    let product = mulByDigit digit (temp @ (clone 0 shift)) in
    (shift + 1, bigAdd sum product) in
  let base = (0, [])  in
  let args = List.combine (clone l1 (List.length(l2))) (List.rev(l2)) in
  let (_, res) = List.fold_left f base args in
    res
;; 
