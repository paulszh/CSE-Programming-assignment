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
        
