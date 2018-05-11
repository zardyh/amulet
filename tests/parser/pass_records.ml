let a = { x = 1, y = 2, z = 3 }

let b = { a with y = 3 }

let c = match b with
        | { x = 1, y = y } -> y

let d : {  x: int, y : int, z : int } = a

let e : { 'a | x: int, y : int } = a
