#!/usr/bin/env bash

JH_ROOT="$(dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")"

# shellcheck source=SCRIPTDIR/../../packages/jehon/usr/bin/jh-lib
. "$JH_ROOT"/packages/jehon/usr/bin/jh-lib

ee1() {
    echo "cool, on exit 1"
}
jh_on_exit ee1

ee2() {
    echo "cool, on exit 2"
}
jh_on_exit ee2

echo "Current trap: "
trap -p EXIT

echo "at the end"
