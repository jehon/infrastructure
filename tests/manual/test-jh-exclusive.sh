#!/usr/bin/env bash

JH_ROOT="$(dirname "$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")")"

# shellcheck source=SCRIPTDIR/../../packages/jehon/usr/bin/jh-lib
. "$JH_ROOT"/packages/jehon/usr/bin/jh-lib

lockFile="${JH_ROOT}/tmp/$(basename "$0").lock"

jh_value "lock file" "${lockFile}"
jh_exclusive "${lockFile}"

echo "ok, lock acquired (I am $$)"
read -r
