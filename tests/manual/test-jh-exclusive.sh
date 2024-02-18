#!/usr/bin/env bash

JH_ROOT="$(dirname "$(dirname "$(dirname "$( realpath "${BASH_SOURCE[0]}")")")")"

# shellcheck source=SCRIPTDIR/../../packages/jehon/usr/bin/jh-lib
. "$JH_ROOT"/packages/jehon/usr/bin/jh-lib

jh_exclusive "$1"

echo "ok, lock acquired (I am $$)"
read -r
