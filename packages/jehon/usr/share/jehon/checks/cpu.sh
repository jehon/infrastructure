#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/../../../../../jehon/usr/bin/jh-lib
. jh-lib

# shellcheck source=SCRIPTDIR/../../../bin/jh-checks-lib
. "$JH_SWD/../../../bin/jh-checks-lib"

PERCENT="$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' | cut -d '.' -f 1 2>/dev/null)"

test_test() {
    test "$PERCENT" -lt "90"
}

test_summary() {
    echo "cpu ${PERCENT} %"
}

test_detailled() {
    top -b -n 1 </dev/null | head -n 10
}

if jh-is-full-machine >/dev/null; then
    main
fi
