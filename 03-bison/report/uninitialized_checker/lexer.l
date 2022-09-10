%{
    #include "parser.tab.h"
    #include <string.h>
%}

%option yylineno

left_par    [(]
right_par   [)]
equals      [=]
semicolon   [;]
comma       [,]

main_start  "main\(\) \{"
main_end    [\}]

varname     [A-Za-z_][A-Za-z0-9_]*
value       [0-9]*([0-9]\.?|\.[0-9])[0-9]*

type        (int|float)

operator    [+-/\*]

%%

{left_par}      {return LEFT_PAR;}
{right_par}     {return RIGHT_PAR;}
{equals}        {return EQUALS;}
{semicolon}     {return SEMICOLON;}
{comma}         {return COMMA;}

{main_start}    {return MAIN_START;}
{main_end}      {return MAIN_END;}

{type}          {return TYPE;}
{varname}       {   
                    // admittedly not the most elegant solution
                    yylval.varname = strdup(yytext);
                    return VARNAME;
                }

{value}         {return VALUE;}

{operator}      {return OPERATOR;}

\n              {/* this empty rule is required to increment yylineno, 
                    otherwise it will be stuck at 1 forever... go figure */}

.               {}

%%

int yyerror(const char *format) {
    printf("error (line %d):\n"
           "%s\n", yylineno, format);
}