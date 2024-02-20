#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../../../../../jehon/usr/bin/
. jh-lib

# shellcheck source-path=SCRIPTDIR/../../../../../jehon/usr/bin/
. jh-checks-lib

test_test() {
    if jh-fs not-empty "/var/cache/jehon/pictures" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

test_summary() {
    find "/var/cache/jehon/pictures" -type f 2> /dev/null | wc -l
}

test_detailled() {
    find "/var/cache/jehon/pictures" -type f 2> /dev/null
}

main
