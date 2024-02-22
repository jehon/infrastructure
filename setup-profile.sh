#!/usr/bin/bash

# We only export bin folder
SWF="${BASH_SOURCE[0]}"
if [[ "$SWF" == "" ]]; then
    # shellcheck disable=SC2296
    SWF="${(%):-%N}"
fi

SWD="$(dirname "${SWF}")"

if [ -n "$SWD" ]; then
    LOCAL_BIN="${SWD}/packages/jehon/usr/bin"
    echo "Path: Adding '$LOCAL_BIN'"
    export PATH="$LOCAL_BIN:$PATH"
fi

# if [ -d ~/restricted ]; then
#     LOCAL_BIN=~/restricted
#     echo "Path: Adding '$LOCAL_BIN'"
#     export PATH="$LOCAL_BIN:$PATH"
# fi
