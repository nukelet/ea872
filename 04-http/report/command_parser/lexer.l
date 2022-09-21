%{
    #include "parser.tab.h"
    uint8_t first_line = 1;
%}

%option yylineno

colon       [:]
comma       [,]
token       [^,:#\n]+

%%

#.*\n           {}
{colon}         {return COLON;}
{comma}         {return COMMA;}
{token}         {
                    yylval.str = strdup(yytext);
                    // printf("token: %s\n", yytext);
                    return TOKEN;
                }

\n              {
                    if (first_line) {
                        first_line = 0;
                        return REQUEST_DESC_END;
                    } else {
                        return NEWLINE;
                    }
                }

.               {}

%%

int yyerror(const char *format) {
    printf("error (line %d):\n"
           "%s\n", yylineno, format);
}