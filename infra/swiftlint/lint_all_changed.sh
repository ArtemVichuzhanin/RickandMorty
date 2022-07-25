#!/bin/bash

#Changed swift files comparing to master branch with relative path
CHANGED_SWIFT_FILES_TO_MASTER=../../$(git diff $(git merge-base --fork-point main) --diff-filter=d --name-only | grep ".swift$")

if [ -z "$CHANGED_SWIFT_FILES_TO_MASTER" ]; then
    # Nothing to lint..
    exit 0
fi

# Prepare lintable files list

# make for .. in work with the shitty spaces in our filenames
OIFS="$IFS"
IFS=$'\n'

FILE_NUMBER=0

for FILE_PATH in $CHANGED_SWIFT_FILES_TO_MASTER
do
    export SCRIPT_INPUT_FILE_$FILE_NUMBER=$FILE_PATH
    FILE_NUMBER=$((FILE_NUMBER + 1))
done

export SCRIPT_INPUT_FILE_COUNT=$FILE_NUMBER

# Run linting

CURRENT_DIR=$(dirname $0)
SWIFT_LINT=$CURRENT_DIR/bin/swiftlint

$SWIFT_LINT lint --use-script-input-files --config .swiftlint.yml
