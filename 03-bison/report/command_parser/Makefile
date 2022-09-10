checker:
	flex lexer.l && bison -d parser.y && gcc -o command_parser lex.yy.c parser.tab.c command_list.c -lfl

.PHONY: all clean

all: command_parser

clean:
	rm lex.yy.c parser.tab.* command_parser
