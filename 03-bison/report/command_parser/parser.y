%token COLON
%token COMMA
%token NEWLINE

%union {
    char *str;
}

%{
    #include "command_list.h"
    #include <stdint.h>
    #include <stdio.h>
    struct command_list *cmdlist = NULL;    
    struct command_list *current_cmd = NULL;
    uint8_t empty_command = 0;
%}

%token <str> TOKEN

%%

file                :   command_def NEWLINE file
                    |   command_def NEWLINE
                    |   command_def;

command_def         :   command_decl arglist 
command_decl        :   TOKEN COLON {
                            empty_command = 0;
                            // printf("command: %s\n", $1);
                            if (!cmdlist) {
                                cmdlist = command_list_new($1);
                                current_cmd = cmdlist;
                            } else {
                                current_cmd = command_list_new($1);
                                command_list_append(cmdlist, current_cmd);
                            }
                        }
                    |   COLON {
                            yyerror("empty command, ignoring...");
                            empty_command = 1;
                        }

arglist             :   arglist COMMA TOKEN {
                            // printf("arg: %s\n", $3);
                            if (!empty_command) {
                                command_add_arg(current_cmd, $3);
                            }
                        }
                    |   TOKEN {
                            // printf("arg: %s\n", $1);
                            if (!empty_command) {
                                command_add_arg(current_cmd, $1);
                            }
                        }
                    |   %empty {/* printf("command \"%s\" has empty arglist\n", current_cmd->name); */}

%%

int main(int argc, char **argv)
{
    /* yydebug = 1; */
    yyparse();
    command_list_print(cmdlist);
    command_list_free(cmdlist);
}