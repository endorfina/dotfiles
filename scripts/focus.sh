#!/bin/bash

say_and_do()
{
    printf >&2 '  \\ %s\n' "$*"
    if "$@"
    then
        echo '  \\ success'
    else
        echo '  \\ failure'
    fi
}

printf 'Focused on [%s] (q to quit)\n> ' "$*"

while read -r REPLY
do
    if [[ -n $REPLY ]]
    then
        [[ $REPLY == q* ]] && break

        if [[ $REPLY == *%* ]]
        then
            say_and_do bash -c "${REPLY/\%/"$*"}"
        else
            say_and_do bash -c "$REPLY $*"
        fi
    fi
    printf '\n> '
done
