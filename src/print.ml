open Java

exception TypeError of string

let rec print g =
    let Goal (m, cl) = g in
    let ml_str = print_main_class m in
    let cl_str = print_class_list cl in
    if String.length cl_str == 0 then ml_str
    else Printf.sprintf "%s\n%s" ml_str cl_str

and print_main_class mc =
    let  MainClass (_, _, s) = mc in
    Printf.sprintf "def main():\n%s" (print_stmt s)

and print_var var =
    let VarDec (_, i) = var in
    Printf.sprintf "%s = None" (print_ident i)

and print_var_list vl =
    match vl with
    | [] -> ""
    | [var] -> print_var var
    | var::t -> (print_var var) ^ "\n" ^ (print_var_list t)

and print_class c =
    let ClassDec (i1, i2, vl, ml) = c in
    let extend_str =
        if String.length i2 == 0 then ""
        else Printf.sprintf "(%s)" (print_ident i2)
    in
    Printf.sprintf "class %s%s:\n%s\n%s" (print_ident i1) (extend_str) (print_var_list vl) (print_method_list ml)

and print_class_list cl =
    match cl with
    | [] -> ""
    | [c] -> print_class c
    | c::t -> (print_class c) ^ "\n" ^ (print_class_list t)

and print_method m =
    let MethodDec ((tp, i), args, (vl, sl, e)) = m in
    let i_str = print_ident i in
    let t_str = print_type tp in
    let rec print_args args =
        match args with
        | [] -> ""
        | [(tp, i)] -> Printf.sprintf "%s: %s" (print_ident i) (print_type tp)
        | (tp, i)::t -> (Printf.sprintf "%s: %s, " (print_ident i) (print_type tp)) ^ (print_args t)
    in
    let args_str = print_args args in
    let vl_str = print_var_list vl in
    let sl_str = print_stmt_block sl in
    let e_str = print_expr e in
    Printf.sprintf "def %s(%s) -> %s:\n%s\n%s\nreturn %s" i_str args_str t_str vl_str sl_str e_str

and print_method_list ml =
    match ml with
    | [] -> ""
    | [m] -> print_method m
    | m::t -> (print_method m) ^ "\n" ^ (print_method_list t)

and print_stmt s =
    match s with
    | If (e, s1, s2) -> Printf.sprintf "if %s:\n%s\nelse:\n%s" (print_expr e) (print_stmt s1) (print_stmt s2)
    | While (e, s') -> Printf.sprintf "while %s:\n%s" (print_expr e) (print_stmt s')
    | Print e -> Printf.sprintf "print(%s)" (print_expr e)
    | Assign (i, e) -> Printf.sprintf "%s = %s" (print_ident i) (print_expr e)
    | AssignArr (i, e1, e2) -> Printf.sprintf "%s[%s] = %s" (print_ident i) (print_expr e1) (print_expr e2)
    | Block sb -> print_stmt_block sb

and print_stmt_block sb =
    match sb with
    | [] -> ""
    | [h] -> print_stmt h
    | h::t -> (print_stmt h) ^ "\n" ^ (print_stmt_block t)

and print_expr e =
    match e with
    | Op (o, e1, e2) -> Printf.sprintf "(%s %s %s)" (print_expr e1) (print_op o) (print_expr e2)
    | ArrGet (e1, e2) -> Printf.sprintf "%s[%s]" (print_expr e1) (print_expr e2)
    | Length e' -> Printf.sprintf "len(%s)" (print_expr e')
    | Num n -> Printf.sprintf "%d" n
    | True -> "True"
    | False -> "False"
    | Ident i -> print_ident i
    | This -> "self"
    | NewIntArr e' -> Printf.sprintf "[0] * %s" (print_expr e')
    | NewObj i -> Printf.sprintf "%s()" (print_ident i)
    | Not e' -> Printf.sprintf "(not %s)" (print_expr e')
    | ObjMethod (e', i, el) ->
            let rec print_args el =
                match el with
                | [] -> ""
                | [e] -> print_expr e
                | e::t -> (print_expr e) ^ ", " ^ (print_args t)
            in
            Printf.sprintf "%s.%s(%s)" (print_expr e') (print_ident i) (print_args el)

and print_ident (i: ident) = i

and print_op o =
    match o with
    | And -> "and"
    | Lt -> "<"
    | Plus -> "+"
    | Minus -> "-"
    | Times -> "*"

and print_type tp =
    match tp with
    | IntArr -> "List[int]"
    | Int -> "int"
    | Boolean -> "bool"
    | Obj i -> i
