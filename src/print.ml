open Java
open Utils

exception TypeError of string

let tab = "    ";;

let tabs = repeat_string tab;;

let rec print g =
    let Goal (m, cl) = g in
    let ml_str = print_main_class m in
    let cl_str = print_class_list cl in
    let libs = "import sys\nfrom typing import List" in
    let run_main = "\nif __name__ == \"__main__\":\n\tmain()" in
    if String.length cl_str == 0 then ml_str
    else Printf.sprintf "%s\n%s\n%s\n%s" libs ml_str cl_str run_main

and print_main_class mc =
    let MainClass (_, i, s) = mc in
    Printf.sprintf "\ndef main():\n%s%s = sys.argv[1:]%s" tab (print_ident i) (print_stmt s 1)

and print_var var t =
    let VarDec (_, i) = var in
    let tabs_str = tabs t in
    Printf.sprintf "\n%s%s = None" tabs_str (print_ident i)

and print_var_list vl t =
    match vl with
    | [] -> ""
    | [var] -> print_var var t
    | var::vlt -> (print_var var t) ^ (print_var_list vlt t)

and print_class c =
    let ClassDec (i1, i2, vl, ml) = c in
    let extend_str =
        if String.length i2 == 0 then ""
        else Printf.sprintf "(%s)" (print_ident i2)
    in
    Printf.sprintf "\nclass %s%s:%s%s" (print_ident i1) (extend_str) (print_var_list vl 1) (print_method_list ml 1)

and print_class_list cl =
    match cl with
    | [] -> ""
    | [c] -> print_class c
    | c::t -> (print_class c) ^ "\n" ^ (print_class_list t)

and print_method m t =
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
    let vl_str =
        let temp = print_var_list vl 0 in
        if String.length temp == 0 then ""
        else "\n" ^ temp
    in
    let sl_str =
        let temp = print_stmt_block sl (t+1) in
        if String.length temp == 0 then ""
        else temp
    in
    let e_str = print_expr e in
    Printf.sprintf "\n%sdef %s(%s) -> %s:%s%s\n%sreturn %s" (tabs t) i_str args_str t_str vl_str sl_str (tabs (t+1)) e_str

and print_method_list ml t =
    match ml with
    | [] -> ""
    | [m] -> print_method m t
    | m::mlt -> (print_method m t) ^ "\n" ^ (print_method_list mlt t)

and print_stmt s t =
    let tabs_str = tabs t in
    match s with
    | If (e, s1, s2) ->
            Printf.sprintf "\n%sif %s:%s\n%selse:%s" tabs_str (print_expr e) (print_stmt s1 (t+1)) tabs_str (print_stmt s2 (t+1))
    | While (e, s') ->
            Printf.sprintf "\n%swhile %s:%s" tabs_str (print_expr e) (print_stmt s' (t+1))
    | Print e ->
            Printf.sprintf "\n%sprint(%s)" tabs_str (print_expr e)
    | Assign (i, e) ->
            Printf.sprintf "\n%s%s = %s" tabs_str (print_ident i) (print_expr e)
    | AssignArr (i, e1, e2) ->
            Printf.sprintf "\n%s%s[%s] = %s" tabs_str (print_ident i) (print_expr e1) (print_expr e2)
    | Block sb -> "\n" ^ print_stmt_block sb t

and print_stmt_block sb t =
    match sb with
    | [] -> ""
    | [h] -> print_stmt h t
    | h::sbt -> (print_stmt h t) ^ "\n" ^ (print_stmt_block sbt t)

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
;;
