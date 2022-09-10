%{
    #include "parser.tab.h"
%}

%option yylineno

colon       [:]
comma       [,]
token       [^,:# \n]+

%%

#.*\n           {}
{colon}         {return COLON;}
{comma}         {return COMMA;}
{token}         {
                    yylval.str = strdup(yytext);
                    return TOKEN;
                }

\n              {return NEWLINE;}
.               {}

%%

int yyerror(const char *format) {
    printf("error (line %d):\n"
           "%s\n", yylineno, format);
}