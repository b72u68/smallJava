exception ValueError of string

let rec repeat_string s t =
    if t >= 0 then
        if t == 0 then ""
        else s ^ repeat_string s (t-1)
    else raise (ValueError "Expected integer number larger or equal to 0")
;;
