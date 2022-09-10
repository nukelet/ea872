%token LEFT_PAR
%token RIGHT_PAR
%token EQUALS
%token SEMICOLON
%token COMMA
%token MAIN_START
%token MAIN_END
%token VALUE
%token TYPE
%token OPERATOR

%union {
    char *varname;
}

%token <varname> VARNAME

%%
program_source          :   MAIN_START program_content MAIN_END;

program_content         :   declaration exp

declaration             :   line_declaration declaration
                        |   line_declaration;

line_declaration        :   TYPE varlist SEMICOLON;

varlist                 :   identifier COMMA varlist
                        |   identifier;

identifier              :   VARNAME EQUALS VALUE { 
                                // symbol has been initialized
                                table_insert($1);
                            }
                        |   VARNAME

exp                     :   exp_line exp
                        |   exp_line;

exp_line                :   VARNAME EQUALS operations SEMICOLON {
                                // symbol has been initialized
                                table_insert($1);
                            }

operations              :   operations OPERATOR operations
                        |   LEFT_PAR operations RIGHT_PAR
                        |   VARNAME {
                                      char *varname = yylval.varname;
                                      if (table_lookup(varname) == 0) {
                                        char errbuf[64];
                                        snprintf(errbuf, 64,
                                            "Uninitialized variable: %s\n", varname);
                                        yyerror(errbuf);
                                      } 
                                    }
                        |   VALUE;
%%

int main(int argc, char **argv)
{
    /* yydebug = 1; */
    yyparse();
}