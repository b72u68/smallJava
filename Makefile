all: src/java.ml src/parser.mly src/lexer.mll src/main.ml
	dune build src/main.exe
	ln -s _build/default/src/main.exe smolc

clean: _build smolc
	rm smolc
	rm -rf _build
