(*
 * expr.ml
 * cse130
 * based on code by Chris Stone
 *)

(* Please do not modify the names or types of any of the following
 * type constructors, or predefined functions, unless EXPLICITLY
 * asked to. You will loose points if you do.
 *)


(* REMEMBER TO DOCUMENT ALL FUNCTIONS THAT YOU WRITE OR COMPLETE *)

type expr = 
    VarX
  | VarY
  | Sine     of expr
  | Cosine   of expr
  | Average  of expr * expr
  | Times    of expr * expr
  | Thresh   of expr * expr * expr * expr	
  | Half      of expr * expr
  | Quarter     of expr * expr * expr
  

let rec exprToString e =
  match e with
    | VarX            -> "x"
    | VarY            -> "y"
    | Sine e1        -> "sin(pi*" ^ exprToString(e1) ^ ")"
    | Cosine e1      -> "cos(pi*" ^ exprToString(e1) ^ ")"
    | Average(e1, e2) -> "(" ^ exprToString(e1) ^ "+" ^ exprToString(e2) ^ ")/2"
    | Times(e1, e2)   -> "(" ^ exprToString(e1) ^ ")*(" ^ exprToString(e2) ^ ")"
    | Thresh(e1, e2, e3, e4) -> "(" ^ exprToString(e1) ^ "<" ^ exprToString(e2) ^ "?" ^ exprToString(e3) ^ ":" ^ exprToString(e4) ^ ")"
    | Half(e1, e2)      -> "(" ^ exprToString(e1) ^ "-" ^ exprToString(e2) ^ ")/2"
    | Quarter(e1, e2, e3)   -> "(" ^ exprToString(e1) ^ "+" ^ exprToString(e2) ^ "+" ^ exprToString(e3) ^ ")/4"
    
(* build functions:
     Use these helper functions to generate elements of the expr
     datatype rather than using the constructors directly.  This
     provides a little more modularity in the design of your program *)

let buildX()                       = VarX
let buildY()                       = VarY
let buildSine(e)                   = Sine(e)
let buildCosine(e)                 = Cosine(e)
let buildAverage(e1,e2)            = Average(e1,e2)
let buildTimes(e1,e2)              = Times(e1,e2)
let buildThresh(a,b,a_less,b_less) = Thresh(a,b,a_less,b_less)
let buildHalf(e1,e2)               = Half(e1,e2)
let buildQuarter(e1,e2,e3)            = Quarter(e1,e2,e3)


let pi = 4.0 *. atan 1.0

let rec eval (e,x,y) = 
    match e with
    | VarX                      -> x
    | VarY                      -> y
    | Sine e1                   -> sin(pi *. eval(e1,x,y)) 
    | Cosine e1                 -> cos(pi *. eval(e1,x,y))
    | Average (e1, e2)          -> (eval(e1,x,y) +. eval(e2,x,y))/.2.0
    | Times (e1, e2)            -> eval(e1,x,y) *. eval(e2,x,y)
    | Thresh (e1, e2, e3, e4)   -> if eval(e1,x,y) < eval(e2,x,y) = true then eval(e3,x,y) else eval(e4,x,y)
    | Half (e1,e2)              -> (eval(e1,x,y) -. eval(e2,x,y))/.2.0
    | Quarter (e1,e2,e3)           -> (eval(e1,x,y) +. eval(e2,x,y) +. eval(e2,x,y))/.4.0

(* (eval_fn e (x,y)) evaluates the expression e at the point (x,y) and then
 * verifies that the result is between -1 and 1.  If it is, the result is returned.  
 * Otherwise, an exception is raised.
 *)
let eval_fn e (x,y) = 
  let rv = eval (e,x,y) in
  assert (-1.0 <= rv && rv <= 1.0);
  rv

let sampleExpr =
      buildCosine(buildSine(buildTimes(buildCosine(buildAverage(buildCosine(
      buildX()),buildTimes(buildCosine (buildCosine (buildAverage
      (buildTimes (buildY(),buildY()),buildCosine (buildX())))),
      buildCosine (buildTimes (buildSine (buildCosine
      (buildY())),buildAverage (buildSine (buildX()), buildTimes
      (buildX(),buildX()))))))),buildY())))

let sampleExpr2 =
  buildThresh(buildX(),buildY(),buildSine(buildX()),buildCosine(buildY()))


(************** Add Testing Code Here ***************)
