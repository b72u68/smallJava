# smolJava

MiniJava programming language compiler.

## Overview

This grammar is based on the MiniJava language created from Cambridge University
(the link to the grammar of the programming language is
[here](https://www.cambridge.org/resources/052182060X/MCIIJ2e/grammar.html#prod4)).

## Installation and Running

This project requires Ocaml package manager `opam` and module `dune`.

```
# install dependencies
$ opam install dune utop menhir

# build compiler
$ make

# run the compiler
$ ./smolc [filename]

# remove/clean build
$ make clean
```
