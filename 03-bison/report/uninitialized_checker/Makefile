checker:
	flex lexer.l && bison -d parser.y && gcc -o checker lex.yy.c parser.tab.c auxiliary.c -lfl

.PHONY: all clean

all: checker

clean:
	rm lex.yy.c parser.tab.* checker