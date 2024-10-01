#!/usr/bin/env bash

prjRoot="$(dirname "$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")")"

# shellcheck source=SCRIPTDIR/../../packages/jehon/usr/bin/jh-lib
. "$prjRoot"/packages/jehon/usr/bin/jh-lib

if [ "$1" == "-f" ]; then
    jh_exclusive_kill
fi
jh_exclusive

echo "ok, lock acquired (I am $$)"
read -r
