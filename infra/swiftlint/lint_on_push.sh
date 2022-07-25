#!/bin/bash

CURRENT_DIR=$(dirname $0)
LINT_CHANGED=$CURRENT_DIR/lint_all_changed.sh

RESULT=$($LINT_CHANGED  --strict)

if [[ ! -z "$RESULT" ]]
then
    while read -r line
    do 
        FILENAME=$(echo $line | cut -d':' -f 1 | rev | cut -d'/' -f 1 | rev)       
        L=$(echo $line | cut -d':' -f 2)
        C=$(echo $line | cut -d':' -f 3)
        TYPE=$(echo $line | cut -d':' -f 4 | cut -c 2-)
        RULE_DESCRIPTION=$(echo $line | cut -d':' -f 5 | cut -c 2-)
        RULE_NAME=$(echo $line | cut -d':' -f 6 | cut -d'(' -f 2 | rev | cut -c 2- | rev)
        
        if [ "$TYPE" = "error" ]
        then
            ICON=❌ #error
        else
            ICON=⚠️ #warning
        fi
        
        printf "$ICON $TYPE: $FILENAME:$L:$C - $RULE_DESCRIPTION ($RULE_NAME)\n" >&2

    done <<< "$RESULT"

    exit 1
fi
