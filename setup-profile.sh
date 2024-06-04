#!/usr/bin/bash

#
# This script is sourced by the shell
#   it must thus work with bash and zsh
#
# It can not "set -o errexit" otherwise the terminal quit abrubtely on erro
#

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
