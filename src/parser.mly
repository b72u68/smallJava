%{
    open Java
%}

%token <int> NUM
%token <string> IDENT
%token TRUE FALSE
%token INT BOOL STRING
%token CLASS PUBLIC STATIC VOID MAIN EXTENDS RETURN PRINT LENGTH
%token PLUS MINUS TIMES LT AND EQUAL
%token IF ELSE WHILE NEW THIS
%token LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE
%token NOT DOT COMMA SEMI
%token EOF

%start prog
%type <Java.goal> prog

%%
prog:
    | main_class class_dec_block EOF { Goal ($1, $2) }
;

main_class:
    | CLASS IDENT LBRACE PUBLIC STATIC VOID MAIN LPAREN STRING LBRACKET RBRACKET IDENT RPAREN LBRACE stmt RBRACE RBRACE { MainClass ($2, $12, $15) }
;

class_dec:
    | CLASS IDENT EXTENDS IDENT LBRACE var_dec_block method_dec_block RBRACE { ClassDec ($2, $4, $6, $7) }
    | CLASS IDENT LBRACE var_dec_block method_dec_block RBRACE { ClassDec ($2, "", $4, $5) }
;

class_dec_block:
    | class_dec class_dec_block { $1::$2 }
    | { [] }
;

var_dec:
    | t IDENT SEMI { VarDec ($1, $2) }
;

var_dec_block:
    | var_dec var_dec_block { $1::$2 }
    | { [] }
;

method_dec:
    | PUBLIC t IDENT LPAREN args RPAREN LBRACE var_dec_block stmt_block RETURN expr SEMI RBRACE { MethodDec (($2, $3), $5, ($8, $9, $11)) }
    | PUBLIC t IDENT LPAREN RPAREN LBRACE var_dec_block stmt_block RETURN expr SEMI RBRACE { MethodDec (($2, $3), [], ($7, $8, $10)) }
;

method_dec_block:
    | method_dec method_dec_block { $1::$2 }
    | { [] }
;

arg:
    | t IDENT { ($1, $2) }
;

args:
    | arg COMMA args { $1::$3 }
    | arg { [$1] }
;

t:
    | INT LBRACKET RBRACKET { IntArr }
    | INT { Int }
    | BOOL { Boolean }
    | IDENT { Obj $1 }
;

stmt:
    | LBRACE stmt_block RBRACE { Block $2 }
    | IF LPAREN expr RPAREN stmt ELSE stmt { If ($3, $5, $7) }
    | WHILE LPAREN expr RPAREN stmt { While ($3, $5) }
    | PRINT LPAREN expr RPAREN SEMI { Print ($3) }
    | IDENT EQUAL expr SEMI { Assign ($1, $3) }
    | IDENT LBRACKET expr RBRACKET EQUAL expr SEMI { AssignArr ($1, $3, $6) }
;

stmt_block:
    | stmt stmt_block { $1::$2 }
    | { [] }
;

op:
    | AND { And }
    | LT { Lt }
    | PLUS { Plus }
    | MINUS { Minus }
    | TIMES { Times }
;

expr:
    | expr op expr { Op ($2, $1, $3) }
    | expr LBRACKET expr RBRACKET { ArrGet ($1, $3) }
    | expr DOT LENGTH { Length ($1) }
    | expr DOT IDENT LPAREN RPAREN { ObjMethod ($1, $3, []) }
    | expr DOT IDENT LPAREN expr_block RPAREN { ObjMethod ($1, $3, $5) }
    | NUM { Num $1 }
    | TRUE { True }
    | FALSE { False }
    | IDENT { Ident $1 }
    | THIS { This }
    | NEW INT LBRACKET expr RBRACKET { NewIntArr $4 }
    | NEW IDENT LPAREN RPAREN { NewObj $2 }
    | NOT expr { Not $2 }
    | LPAREN expr RPAREN { $2 }
;

expr_block:
    | expr COMMA expr_block { $1::$3 }
    | expr { [$1] }
;
