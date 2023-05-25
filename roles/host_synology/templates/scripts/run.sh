#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/lib.sh

SCOPE="$1"
RES=0

run() {
    FN=$( basename "$F" )
    if "$F" | while read -r LINE; do
        printf "[$FN] %s\n" "$LINE"
    done ; then
        echo "Success"
        return 0
    else
        echo "!!!! Failure"
        return 1
    fi 
}

for F in "$SCRIPTS_FOLDER/${SCOPE}.d"/*; do
    echo "*****************************************************************************"
    echo "****************************** Running $F ..."
    echo "*****************************************************************************"
    if ! run "$F" ; then
        RES="1"
    fi
done

if [ "$RES" = "1" ]; then
    echo "Some errors during the run"
    exit 1
fi
echo "All done with success"