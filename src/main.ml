if Array.length Sys.argv < 2 then
    (Printf.printf "Usage ./main [filename]\n";
    exit 1)
;;

let fname = Array.get Sys.argv 1;;
let basename =
    try Filename.chop_extension fname
    with Invalid_argument _ -> fname
;;

let chan = open_in fname;;
let lexbuf = Lexing.from_channel chan;;
let parse = Parser.prog Lexer.token lexbuf;;

let python = Print.print parse;;
let outchan = open_out (basename ^ ".py");;
let _ = Printf.fprintf outchan "%s\n" python;;
let _ = close_out outchan;;
