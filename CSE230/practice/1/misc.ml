(* CSE 130: Programming Assignment 1
 * misc.ml
 *)

(* sumList : int list -> int 
   ***** PUT DOCUMENTATION COMMENTS HERE *****
*) 

let rec sumList l = 
    match l with 
    | [] -> 0
    | h :: t -> h + sumList(l)

(* digitsOfInt : int -> int list 
   ***** PUT DOCUMENTATION COMMENTS HERE *****
   (see the digits function below for an example of what is expected)
 *)

let rec digitsOfInt n = failwith "to be written"


(* digits : int -> int list
 * (digits n) is the list of digits of n in the order in which they appear
 * in n
 * e.g. (digits 31243) is [3,1,2,4,3]
 *      (digits (-23422) is [2,3,4,2,2]
 *)
 
let digits n = digitsOfInt (abs n)


(* From http://mathworld.wolfram.com/AdditivePersistence.html
 * Consider the process of taking a number, adding its digits, 
 * then adding the digits of the number derived from it, etc., 
 * until the remaining number has only one digit. 
 * The number of additions required to obtain a single digit from a number n 
 * is called the additive persistence of n, and the digit obtained is called 
 * the digital root of n.
 * For example, the sequence obtained from the starting number 9876 is (9876, 30, 3), so 
 * 9876 has an additive persistence of 2 and a digital root of 3.
 *)


(* ***** PROVIDE COMMENT BLOCKS FOR THE FOLLOWING FUNCTIONS ***** *)

let rec additivePersistence n = failwith "to be written"

let rec digitalRoot n = failwith "to be written"

let rec listReverse l = failwith "to be written"

(* explode : string -> char list 
 * (explode s) is the list of characters in the string s in the order in 
 *   which they appear
 * e.g.  (explode "Hello") is ['H';'e';'l';'l';'o']
 *)
let explode s = 
  let rec _exp i = 
    if i >= String.length s then [] else (s.[i])::(_exp (i+1)) in
  _exp 0


let palindrome w = failwith "to be written"

(************** Add Testing Code Here ***************)
