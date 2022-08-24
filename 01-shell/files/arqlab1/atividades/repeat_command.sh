#! /bin/bash

for ARG in $@
do
    case $ARG in
        --repeticoes=*)
            RUNS=$(echo $ARG | cut -f 2 -d '=')
            # bail out if not a decimal, positive number
            case $RUNS in
                ''|*[!0-9]*)
                    echo "invalid argument: $ARG" 1>&2
                    exit 1
                ;;
            esac
            shift
            ;;
        --atraso=*)
            DELAY=$(echo $ARG | cut -f 2 -d '=')
            case $DELAY in
                ''|*[!0-9]*)
                    echo "invalid argument: $ARG" 1>&2
                    exit 1
                ;;
            esac
            shift
            ;;
        *)
            break
            ;;
    esac
done

COMMAND="$*"

while [[ ${RUNS:=1} -gt 0 ]]
do
    eval "$COMMAND" || exit 1
    RUNS=$((RUNS-1))
    test -n "$DELAY" && sleep "$DELAY"
done
