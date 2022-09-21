%token COLON
%token COMMA
%token NEWLINE
%token REQUEST_DESC_END

%union {
    char *str;
}

%{
    #include "command_list.h"
    #include <stdint.h>
    #include <stdio.h>
    #include <string.h>
    struct command_list *cmdlist = NULL;    
    struct command_list *current_cmd = NULL;
    uint8_t empty_command = 0;
    char command_buf[256];
%}

%token <str> TOKEN

%%

request             :   request_descriptor commands;

commands            :   command_def NEWLINE commands
                    |   command_def NEWLINE
                    |   command_def;

request_descriptor  :   TOKEN REQUEST_DESC_END {
                            cmdlist = command_list_new($1);
                            current_cmd = cmdlist;
                            // command_add_arg(current_cmd, $2);
                            // command_add_arg(current_cmd, $3);
                        };

command_def         :   command_decl arglist
command_decl        :   TOKEN COLON {
                            empty_command = 0;
                            // printf("command: %s\n", $1);
                            current_cmd = command_list_new($1);
                            command_list_append(cmdlist, current_cmd);
                        }
                    |   COLON {
                            yyerror("empty command, ignoring...");
                            empty_command = 1;
                        }

arglist             :   arglist COMMA arg
                    |   arg
                    |   %empty {/* printf("command \"%s\" has empty arglist\n", current_cmd->name); */}

arg                 :   TOKEN COLON TOKEN {
                            snprintf(command_buf, 256, "%s:%s", $1, $3);
                            // printf("parsing command with comma:", command_buf);
                            if (!empty_command) {
                                command_add_arg(current_cmd, command_buf);
                            }
                        }

                    |   TOKEN {
                            // printf("arg: %s\n", $1);
                            if (!empty_command) {
                                command_add_arg(current_cmd, $1);
                            }
                        }

%%

int main(int argc, char **argv)
{
    /* yydebug = 1; */
    yyparse();
    command_list_print(cmdlist);
    command_list_free(cmdlist);
}