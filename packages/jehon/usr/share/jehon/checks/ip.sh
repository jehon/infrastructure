#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/../../../../../jehon/usr/bin/jh-lib
. jh-lib

# shellcheck source=SCRIPTDIR/../../../bin/jh-checks-lib
. "$JH_SWD/../../../bin/jh-checks-lib"

IP="$( /usr/bin/jh-network-list-ip | awk '{print $2}' | grep -v "127.0.0" | uniq | xargs echo)"

test_test() {
    true
}

test_summary() {
    echo "$IP"
}

test_detailled() {
    /usr/bin/jh-network-list-ip
}

if jh-is-full-machine >/dev/null; then
    main
fi
