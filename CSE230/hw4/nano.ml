(* Zhouhang Shao A99086018 Nov 9th 2018 *)
exception MLFailure of string

type binop = 
  Plus 
| Minus 
| Mul 
| Div 
| Eq 
| Ne 
| Lt 
| Le 
| And 
| Or          
| Cons

type expr =   
  Const of int 
| True   
| False      
| NilExpr
| Var of string    
| Bin of expr * binop * expr 
| If  of expr * expr * expr
| Let of string * expr * expr 
| App of expr * expr 
| Fun of string * expr    
| Letrec of string * expr * expr
  
type value =  
  Int of int    
| Bool of bool          
| Closure of env * string option * string * expr 
| Nil                    
| Pair of value * value     
| NativeFunc of string

and env = (string * value) list

let binopToString op = 
  match op with
      Plus -> "+" 
    | Minus -> "-" 
    | Mul -> "*" 
    | Div -> "/"
    | Eq -> "="
    | Ne -> "!="
    | Lt -> "<"
    | Le -> "<="
    | And -> "&&"
    | Or -> "||"
    | Cons -> "::"

let rec valueToString v = 
  match v with 
    Int i -> 
      Printf.sprintf "%d" i
  | Bool b -> 
      Printf.sprintf "%b" b
  | Closure (evn,fo,x,e) -> 
      let fs = match fo with None -> "Anon" | Some fs -> fs in
      Printf.sprintf "{%s,%s,%s,%s}" (envToString evn) fs x (exprToString e)
  | Pair (v1,v2) -> 
      Printf.sprintf "(%s::%s)" (valueToString v1) (valueToString v2) 
  | Nil -> 
      "[]"
  | NativeFunc s ->
      Printf.sprintf "Native %s" s

and envToString evn =
  let xs = List.map (fun (x,v) -> Printf.sprintf "%s:%s" x (valueToString v)) evn in
  "["^(String.concat ";" xs)^"]"

and exprToString e =
  match e with
      Const i ->
        Printf.sprintf "%d" i
    | True -> 
        "true" 
    | False -> 
        "false"
    | NilExpr -> 
        "[]"
    | Var x -> 
        x
    | Bin (e1,op,e2) -> 
        Printf.sprintf "%s %s %s" 
        (exprToString e1) (binopToString op) (exprToString e2)
    | If (e1,e2,e3) -> 
        Printf.sprintf "if %s then %s else %s" 
        (exprToString e1) (exprToString e2) (exprToString e3)
    | Let (x,e1,e2) -> 
        Printf.sprintf "let %s = %s in \n %s" 
        x (exprToString e1) (exprToString e2) 
    | App (e1,e2) -> 
        Printf.sprintf "(%s %s)" (exprToString e1) (exprToString e2)
    | Fun (x,e) -> 
        Printf.sprintf "fun %s -> %s" x (exprToString e) 
    | Letrec (x,e1,e2) -> 
        Printf.sprintf "let rec %s = %s in \n %s" 
        x (exprToString e1) (exprToString e2) 

(*********************** Some helpers you might need ***********************)

let rec fold f base args = 
  match args with [] -> base
    | h::t -> fold f (f(base,h)) t

let listAssoc (k,l) = 
  fold (fun (r,(t,v)) -> if r = None && k=t then Some v else r) None l

(*********************** Your code starts here ****************************)


(* Lookup : string * env -> value 
 * Finds the most recent binding for a variable (i.e. the first from the left) in 
 * the list representing the environment. 
 *)
let lookup (x,evn) = 
  let tmp = listAssoc(x,evn) in
    match tmp with
      | Some y -> y
      | None -> match x with
        | "hd" -> NativeFunc "hd"
        | "ld" -> NativeFunc "ld"
        | "null" -> NativeFunc "null"
        | "map" -> NativeFunc "map"
        | "fold" -> NativeFunc "fold"
        | _ -> raise (MLFailure("Variable not bound : " ^ x))

(* 
 * env * expr -> value that when called with the pair (evn,e) evaluates an NanoML 
 * expression e of the above type, in the environment evn , and raises an exception MLFailure 
 * ("variable not bound: x") if the expression contains an unbound variable.
 *)
let rec eval (evn,e) = 
  match e with
    | Const i -> Int i
    | True -> Bool true
    | False -> Bool false
    | NilExpr -> Nil
    | Var x -> lookup(x, evn)
    | Bin (e1, oper, e2) -> (
        let x = eval(evn, e1) in
        let y = eval(evn, e2) in
        match(x, oper, y) with
        | Int x, Plus, Int y -> Int (x + y)  
        | Int x, Minus, Int y -> Int (x - y)  
        | Int x, Mul, Int y -> Int (x * y)  
        | Int x, Div, Int y -> Int (x / y)  
        | Int x, Eq, Int y -> Bool (x = y)  
        | Bool x, Eq, Bool y -> Bool (x = y)  
        | Int x, Ne, Int y -> Bool (x != y)  
        | Bool x, Ne, Bool y -> Bool (x != y)  
        | Int x, Lt, Int y -> Bool (x < y)  
        | Int x, Le, Int y -> Bool (x <= y)  
        | Bool x, And, Bool y -> Bool (x && y)  
        | Bool x, Or, Bool y -> Bool (x || y)  
        | Int x, Cons, Nil -> Pair(Int x, Nil)
        | Int x, Cons, Pair(a,b) -> Pair(Int x, y)
        | _ -> raise(MLFailure("Unsupported Operation")))
    | If (e1,e2,e3) -> (match eval(evn, e1) with
        | Bool b -> if b then eval(evn, e2) else eval(evn, e3)
        | _ -> raise (MLFailure("Invalid input for If statement")))
    | Let (x, e1, e2) -> (eval((x, eval(evn,e1))::evn, e2))
    | App (oper, e1) -> begin match oper with
          | Var "hd" -> (
            match eval(evn, e1) with 
              Pair(e1, e2) -> e1)
          | Var "tl" -> (
            match eval(evn, e1) with 
              Pair(e1, e2) -> e2)
          | Var "null" -> if eval(evn, e1) = Nil then Bool true else Bool false
          | _ -> let Closure (evn2, f, x, e2) = eval(evn, oper) in
                 let en2 = match f with
                      | Some func -> (func, Closure (evn2, f, x, e2))::(x, eval(evn, e1))::evn2
                      | None -> (x, eval(evn, e1))::evn2 
                 in eval(en2, e2)
          end 
    | Fun(x,e) -> Closure(evn, None, x, e)
    | Letrec (x, e1, e2) -> (
        let v = eval(evn, e1) in
          let evn1 =  
            match v with 
            | Closure(evn3, None, y, e) -> Closure(evn3, Some x, y, e)
            | _ -> v
          in
          let evn2 = (x,evn1)::evn in eval(evn2, e2))
    | _ -> raise (MLFailure("Invalid Expr"))
(**********************     Testing Code  ******************************)
