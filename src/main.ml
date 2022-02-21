if Array.length Sys.argv < 2 then
    (Printf.printf "Usage ./main [filename]\n";
    exit 1)
;;

let fname = Array.get Sys.argv 1;;

let chan = open_in fname;;
let lexbuf = Lexing.from_channel chan;;
let parse = Parser.prog Lexer.token lexbuf;;

let () = print_endline (Print.print parse);;
