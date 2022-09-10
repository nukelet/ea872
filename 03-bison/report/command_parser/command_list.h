#ifndef COMMAND_LIST_H
#define COMMAND_LIST_H

#include <stddef.h>
#include <stdlib.h>

/**
 * @brief  A non-empty linked list that stores all arguments passed
 *         passed to a command
 */
struct arg_list
{
    char *name;
    struct arg_list *next;
};

/**
 * @brief  A linked list of commands, where each node
 *         stores another linked list with the command args
 */
struct command_list
{
    char *name;
    struct arg_list *args;
    struct command_list *next;
};

/**
 * @brief  Allocates and initializes a new command list
 * @param  name: Command name
 * @retval Pointer to the new command_list
 */
struct command_list* command_list_new(char *name);

/**
 * @brief  Deallocate a command_list
 */
void command_list_free(struct command_list *p);


/**
 * @brief  Append an element to a command_list
 */
void command_list_append(struct command_list *p,
                         struct command_list *next);

/**
 * @brief  Append an argument to a command_list node
 */
void command_add_arg(struct command_list *p, char *arg);

/**
 * @brief  Pretty-print a command_list
 */
void command_list_print(struct command_list *p);

#endif