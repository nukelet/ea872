#include "command_list.h"

#include <string.h>
#include <stdio.h>

struct arg_list* arg_list_alloc(char *arg)
{
    struct arg_list *p = malloc(sizeof(*p));
    size_t arglen = strlen(arg);
    p->name = malloc(arglen+1);
    strncpy(p->name, arg, arglen);
    p->next = NULL; 
    return p;
}

void arg_list_free(struct arg_list* p)
{
    if (!p)
        return;
    while (p != NULL) {
        struct arg_list *next = p->next;
        free(p->name);
        free(p);
        p = next;
    }
}

void arg_list_append(struct arg_list* p, struct arg_list *next)
{
    if (!p)
        return;
    while (p->next) { p = p->next; }
    p->next = next;
} 

struct command_list* command_list_new(char *name)
{
    struct command_list *p = malloc(sizeof(*p));
    size_t name_len = strlen(name);
    p->name = malloc(name_len + 1);
    strncpy(p->name, name, name_len);
    p->args = NULL;
    p->next = NULL;
}

void command_list_free(struct command_list *p)
{
    if (!p)
        return;
    while (p != NULL) {
        struct command_list *next = p->next;
        arg_list_free(p->args);
        free(p->name);
        free(p);
        p = next;
    }
}

void command_list_append(struct command_list *p,
                         struct command_list *next)
{
    if (!p)
        return;
    while (p->next) { p = p->next; }
    p->next = next;
}

void command_add_arg(struct command_list *p, char *arg)
{
    if (!p)
        return;
    struct arg_list *new = arg_list_alloc(arg);
    if (!p->args) {
        p->args = new;
    } else {
        arg_list_append(p->args, new);
    }
}

void command_list_print(struct command_list *p)
{
    if (!p)
        return;
    while (p) {
        printf("command: \"%s\", args: ", p->name);
        struct arg_list *arg = p->args;
        if (!arg) {
            printf("(none)\n");
        } else {
            while (arg) {
                printf("\"%s\"", arg->name);            
                if (arg = arg->next) {
                    printf(", ");
                }
            }
            printf("\n");
        }

        p = p->next;
    }
}

// int main(int argc, char **argv)
// {
//     struct command_list *p = command_list_new("main");
//     command_add_arg(p, "--help");
//     command_add_arg(p, "--verbose");
//     command_list_print(p);
//     command_list_free(p);
// }