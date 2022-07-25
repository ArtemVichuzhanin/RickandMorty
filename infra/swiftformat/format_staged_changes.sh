#!/bin/bash

STAGED_SWIFT_FILES=$(git diff --diff-filter=d --name-only --staged | grep ".swift")
if [ -z "$STAGED_SWIFT_FILES" ]; then
    # Nothing to format..
    exit 0
fi

CURRENT_DIR=$(dirname $0)
SWIFT_FORMAT=$CURRENT_DIR/bin/swiftformat

$CURRENT_DIR/git-format-staged --formatter "${SWIFT_FORMAT} --quiet stdin --stdinpath '{}'" "*.swift"

if [ $? -ne 0 ]
then
    echo "Format failed. Commit aborted."
    exit 1
fi

ANY_STAGED_FILES=$(git diff --name-only --staged)
if [ -z "$ANY_STAGED_FILES" ]
then
    echo "Commit aborted. Nothing to commit after formatting."
    exit 1
fi
