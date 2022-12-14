%{
#include "ex3.tab.h"
int yylex(void);        // protótipo de definição de funções exigido atualmente
int yyerror(char* s);   // protótipo de definição de funções exigido atualmente

%}
digito    [0-9]+
frac      [0-9]*\.[0-9]*
operador  [-+=]
nl        \n
%%
{digito}	{
		  sscanf(yytext, "%d", &yylval.valor_inteiro);
		  return INTEIRO;
		}
{frac}          {
		  sscanf(yytext, "%f", &yylval.valor_real);
		  return REAL;
		}
{operador}	return yytext[0];
{nl}		return ('\n');
