type op =
    | And
    | Lt
    | Plus
    | Minus
    | Times

type ident = string

type typ =
    | IntArr
    | Int
    | Boolean
    | Obj of ident

type exp =
    | Op of op * exp * exp
    | ArrGet of exp * exp
    | Length of exp
    | ObjMethod of exp * ident * exp list
    | Num of int
    | True
    | False
    | Ident of ident
    | This
    | NewIntArr of exp
    | NewObj of ident
    | Not of exp

type stmt =
    | If of exp * stmt * stmt
    | While of exp * stmt
    | Print of exp
    | Assign of ident * exp
    | AssignArr of ident * exp * exp
    | Block of stmt list

type mainClass = MainClass of ident * ident * stmt

type varDec = VarDec of typ * ident

type methodDec =
    MethodDec of (typ * ident) * (typ * ident) list * (varDec list * stmt list * exp)

type classDec = ClassDec of ident * ident * varDec list * methodDec list

type goal = Goal of mainClass * classDec list
