#! /bin/bash

SCRIPT_PATH=$(realpath "$0")
# echo $SCRIPT_PATH

# lg(13!) = 32.53... -> 12 is the largest factorial to fit into 32 bits
# lg(21!) = 65.46... -> 20 is the largest factorial to fit into 64 bits

# checks max int size supported by the shell
if [[ $((0xFFFFFFFF+1)) -ne 0 ]]
then    # shell supports 64-bit integers
    MAX_FACTORIAL=20
else    # shell supports 32-bit integers (presumably...)
    MAX_FACTORIAL=12
fi

# handle wrong number of args
if [[ $# -ne 1 ]]
then
    echo "Usage: factorial.sh <number>" 1>&2
    exit 1
fi

case $1 in
    # if the argument is invalid...
    ''|*[!0-9]*)
        echo "Invalid input: $1 (must be a non-negative integer)" 1>&2
        exit 1
        ;;
esac

# handle overly large factorial that would overflow
if [[ $1 -gt $MAX_FACTORIAL ]]
then
    echo "Max supported factorial is 20! Aborting..." 1>&2
    exit 1
fi

if [[ $1 -eq 0 ]]
then
    # base case for the recursion
    printf "1"
else
    # factorial($1) = $1 * factorial($1 - 1)
    x=$($SCRIPT_PATH $(($1 - 1)))
    RESULT=$(($1 * x))
    # printing as uint (`echo` would print anything larger
    # than 0xFFFFFFFF as negative, assuming 64-bits)
    printf "%u\\n" $RESULT
fi

