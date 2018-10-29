(* CSE 130: Programming Assignment 2
 * misc.ml
 *)

(* ***** DOCUMENT ALL FUNCTIONS YOU WRITE OR COMPLETE ***** *)

(* 'a * 'b * ('b * 'a) list -> 'a
 * At each iteration, the function will first compare the key of 
 * first element inside the list l, if matches, return value
 * else return default value -1;
 *)
let rec assoc (d,k,l) = 
  match (d, k, l) with 
    | (d, k, []) -> d
    | (d, k, (k', v)::l1) -> if k = k' then v else assoc(d, k, l1)
(* fill in the code wherever it says : failwith "to be written" *)

(*
 * int list -> int list
 * h::t check if element h is in the list seen, if it already exists continue with seen
 * otherwise add h to seen
 * the rest part with be t
 *)
let removeDuplicates l = 
  let rec helper (seen,rest) = 
      match rest with 
      | [] -> seen
      | h::t -> 
        let seen' = 
          if List.mem h seen then seen else h::seen in
        let rest' = t in 
	  helper (seen',rest') 
  in
      List.rev (helper ([],l))


(* wwhile : (int -> int * bool) * int -> int (or more generally, ('a -> 'a * bool) * 'a -> 'a ) *)
let rec wwhile (f,b) = 
  match f b with
   (b', false) -> b'
  |(b', true) -> wwhile(f, b')

(* 
 * (int -> int) * int -> int (or more generally, ('a -> 'a) * 'a -> 'a) which repeatedly updates 
 * b with f(b) until b=f(b) and then returns b. 
 *)
let fixpoint (f,b) = wwhile ((fun b' -> (f(b'), f(b') != b')),b)


(* ffor: int * int * (int -> unit) -> unit
   Applies the function f to all the integers between low and high
   inclusive; the results get thrown away.
 *)

let rec ffor (low,high,f) = 
  if low>high 
  then () 
  else let _ = f low in ffor (low+1,high,f)
      
(************** Add Testing Code Here ***************)
