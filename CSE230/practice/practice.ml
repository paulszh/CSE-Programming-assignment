let rec update_1 l i n =
    match l with
    | [] -> []
    | h::t -> if i = 0 then (n::t) else h::(update_1 t (i-1) n);;

let rec update_2 l i n d = 
    match l with
    | [] -> update_2 [d] i n d;
    | h::t -> if i = 0 then (n::t) else h::(update_2 t (i-1) n d);;

let categorize f l = 
    let base = [] in
    let fold_fn acc elmt = update_2 acc (f elmt) ((ith acc (f elmt) []) @ [elmt]) [] in
    in List.fold_left ford_fn base;;
    
let result_1 = update_1 [1;2;3], 1, 0;;


(* let rec print_list_int myList = match myList with
| [] -> print_endline "This is the end of the int list!"
| head::body -> 
begin
print_int head; 
print_endline "";
print_list_int body
end
;;

print_list_int result_1;; *)


let count l x =
    let base = (0,x) in
    let worker acc next = 
        let (x1, x2) = acc in
        if x2 = next then (x1 + 1,x2) else (x1, x2)
    in
    let (result, _) = List.fold_left worker base l in result;;


let count l x =
let base = (0,x) in
let worker acc next =
    let (x1, x2) = acc in
        match next with
        | [] -> x1
        | h::t -> if h = x2 then x1+1 else x1
in
List.fold_left worker base l;;




let rec convertToList t =
        match t with
        |  Leaf l -> [l]
        |  Node(l1,  l2)-> (convertToList l1) @ (convertToList l2)        


let f1 x = x + 1;;

let f2 x = x * 2;;

let f3 x = x + 3;;

let t = Node(Leaf f1, Node(Leaf f2, Leaf f3));;

type 'a fun_tree =                                            │
│       | Leaf of ('a -> 'a)                                                   │
│       | Node of ('a fun_tree) * ('a fun_tree);;

let f acc elmt = (elmt acc) in let base = 0 in
List.fold_left f base (convertToList t);;

(* Next is a function, the converToList t function convert the tree of function to list of function*)
let applyToAll t v = 
    let rec convertToList t =
        match t with
        |  Leaf l -> [l]
        |  Node(l1,  l2)-> (convertToList l1) @ (convertToList l2)
    in
    let base = 0 in
    let worker acc next = acc next in
    List.fold_left worker base (convertToList t)
        
(* Ocaml Question Winter 2012 practice final *)
(* let prices = [ ("Baseball Bat", 20); ("Soccer Ball", 10); ("Tennis Racket", 40) ] *)
let rec find d k = 
        match d with
        | [] -> raise Not_found
        | (k',v') :: t ->
                if (k = k') then v'
                else find t k;;

        
let rec find d k = 
        match d with
        | [] -> raise Not_found
        | (k',v') :: t ->
                let tmp = k' in 
                        match tmp with
                        | k -> v'
                        | _ -> find t k;;
                
                
(* Ocaml Question Winter 2012 practice final *)
(* add prices "Figure Skates" 100;; *)
(* - : (string * int) list = *)
(* [("Baseball Bat", 20); ("Figure Skates", 100); ("Soccer Ball", 10); ("Tennis Racket", 40)] *)
(* add prices "Aikido Suit" 20;; - : (string * int) list = [("Aikido Suit", 20); ("Baseball Bat", 20); ("Soccer Ball", 10); ("Tennis Racket", 40)] *)
(* add prices "Soccer Ball" 30;; - : (string * int) list = [("Baseball Bat", 20); ("Soccer Ball", 30); ("Tennis Racket", 40)] *)

let rec add d k v =
        match d with
        | [] -> (k,v)::[]
        | (k',v')::t ->
                if k = k' then (k,v)::t
                else if k < k' then (k,v)::((k',v')::t)
                else (k',v')::add t k v;;
                

(* Ocaml Question Winter 2012 practice final *)
(* Use map to write a function values:(string*int) list -> int list. Given a dictionary d, 
values d should return the list of values. For example, values prices should return [20,10,40]. *)
let values d =
        let worker x =
                let k, v = x in 
                v in
                List.map worker d;;
         
                 


(* Ocaml Question Winter 2012 practice final *)
(* Fill in the implementation of key_of_max_val:(string*int)list -> string by using *)
(* fold_left. Given a dictionary d, key_of_max_val d returns the key of the maximum value in the *)
(* dictionary (or raises Not_found if there are no entries in the dictionary). If multiple keys have the *)
(* maximum value, then you may return either one. For example key_of_max_val prices would return *)
(* "Tennis Racket". Recall that the type of fold_left is (’a -> ’b -> ’a) -> ’a -> ’b list -> ’a. *)
let key_of_max_val d =
        let worker (max_k, max_v) (k,v) =
                if (max_k < k) then (k,v)
                else (max_k, max_v)
        in
        match d with
        | [] -> raise Not_found
        | base::t -> let (maxkey, _) = List.fold_left worker base t in maxkey;;
        


let rec add d k v = 
        match d with
        | Empty -> Node(k, v, Empty, Empty)
        | Node (k', v', l, r) -> 
                if (k = k') then Node(k,v,l,r) else
                if (k < k') then Node (k,v,add l k v, r) else Node (k, v, l, add r k v);; 
                

let method_f self i = (to_int (lookup, self, "a"))
let OBJ3 = Info([("a", Int(10)); ("f", Method(method_f))], EmptyNameSpace)
let invoke_method self name i = (to_method (lookup self name)) self i
