#include "auxiliary.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>

#define SYMBOL_TABLE_SIZE 64
#define SYMBOL_MAX_SIZE 32

static char* table[SYMBOL_TABLE_SIZE];
static size_t table_size = 0;

void table_insert(const char* symbol)
{
    // printf("inserting symbol: %s\n", symbol);
    char *str = malloc(sizeof(char) * SYMBOL_MAX_SIZE);    
    strncpy(str, symbol, SYMBOL_MAX_SIZE);
    table[table_size++] = str;
    if (table_size >= SYMBOL_TABLE_SIZE) {
        fprintf(stderr,
            "Symbol table overflow (max. 64 variable references), aborting...\n");
        exit(-ENOMEM);
    }
}

/**
 * @brief Looks for a symbol in the table 
 * @param  symbol
 * @retval 1 if symbol is present, 0 otherwise
 */
int table_lookup(const char* symbol)
{
    // printf("looking up \"%s\": ", symbol);
    for (size_t i = 0; i < table_size; i++) {
        if (strncmp(symbol, table[i], SYMBOL_MAX_SIZE) == 0) {
            // printf("found\n");
            return 1;
        }
    }

    // printf("not found\n");
    return 0;
}