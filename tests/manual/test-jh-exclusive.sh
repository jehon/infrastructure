#!/usr/bin/env bash

prjRoot="$(dirname "$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")")"

# shellcheck source=SCRIPTDIR/../../packages/jehon/usr/bin/jh-lib
. "$prjRoot"/packages/jehon/usr/bin/jh-lib

lockFile="${prjRoot}/tmp/$(basename "$0").lock"

jh_value "lock file" "${lockFile}"
jh_exclusive "${lockFile}"

echo "ok, lock acquired (I am $$)"
read -r
