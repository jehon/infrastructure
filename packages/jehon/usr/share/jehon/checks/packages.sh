#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/../../../../../jehon/usr/bin/jh-lib
. jh-lib

# shellcheck source=SCRIPTDIR/../../../bin/jh-checks-lib
. "$JH_SWD/../../../bin/jh-checks-lib"

test_test() {
    dpkg -s jehon &>/dev/null
}

test_summary() {
    dpkg -l "jehon-*" | grep "ii" | awk '{ print $2 }' | tr '\n' ' '
}

test_detailled() {
    dpkg -s jehon
}

test_infos() {
    dpkg -l "jehon-*" | grep "ii" | awk '{ print $2 " (" $3 ")"; }'
}

main
