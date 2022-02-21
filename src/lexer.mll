{
    open Parser
}

let digit = ['0'-'9']
let identchar = ['a'-'z' 'A'-'Z' '_' '0'-'9']
let ident = ['a'-'z' 'A'-'Z'] identchar*
let ws = [' ' '\t' '\n' '\r']

rule token = parse
    | ws { token lexbuf}

    | digit+ as n { NUM (int_of_string n) }
    | "true" { TRUE }
    | "false" { FALSE }

    | "System.out.println" { PRINT }
    | "length" { LENGTH }

    | "public" { PUBLIC }
    | "static" { STATIC }
    | "class" { CLASS }
    | "void" { VOID }
    | "main" { MAIN }
    | "String" { STRING }
    | "extends" { EXTENDS }
    | "return" { RETURN }

    | "int" { INT }
    | "boolean" { BOOL }

    | "+" { PLUS }
    | "-" { MINUS }
    | "*" { TIMES }
    | "<" { LT }
    | "&&" { AND }
    | "=" { EQUAL }

    | "if" { IF }
    | "else" { ELSE }
    | "while" { WHILE }
    | "new" { NEW }
    | "this" { THIS }

    | "(" { LPAREN }
    | ")" { RPAREN }

    | "[" { LBRACKET }
    | "]" { RBRACKET }

    | "{" { LBRACE }
    | "}" { RBRACE }

    | "!" { NOT }
    | "." { DOT }
    | "," { COMMA }
    | ";" { SEMI }

    | ident as x { IDENT x }
    | eof { EOF }
