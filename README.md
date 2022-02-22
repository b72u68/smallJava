# smolJava

MiniJava programming language compiler.

## Overview

This grammar is based on the MiniJava language created from Cambridge University
(the link to the grammar of the programming language is
[here](https://www.cambridge.org/resources/052182060X/MCIIJ2e/grammar.html#prod4)).

![image](https://user-images.githubusercontent.com/64541805/155037561-ffe6fa0f-06ae-4de7-bab7-b2decc756d42.png)

## Installation and Running

This project requires Ocaml package manager `opam` and module `dune`.

```
# install dependencies
$ opam install dune menhir

# build compiler
$ make

# remove/clean build
$ make clean
```

Running `make` will create an executable `smolc` in the project directory.
This tool helps converting the MiniJava code in the input file to Python.
For example, the MiniJava code for declaring multiple classes (included in
`/test/declare_class.java`):

```java
class Test {
    public static void main(String[] arg) {
        System.out.println(!true);
    }
}

class Test2 {
    int x;
    int y;

    public int sum(int x, int y) {
        return x + y;
    }
}

class Test3 extends Test2 {
    public int sum(int x, int y) {
        return y + x;
    }
}
```

becomes

```python
import sys
from typing import List

def main():
        arg = sys.argv[1:]
        print((not True))

class Test2:
        x = None
        y = None
        def sum(x: int, y: int) -> int:
                return (x + y)

class Test3(Test2):
        def sum(x: int, y: int) -> int:
                return (y + x)

if __name__ == "__main__":
        main()
```

after running `smolc`.
