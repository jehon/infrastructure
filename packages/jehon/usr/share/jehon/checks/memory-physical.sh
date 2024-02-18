#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/../../../../../jehon/usr/bin/jh-lib
. jh-lib

# shellcheck source=SCRIPTDIR/../../../bin/jh-checks-lib
. "$JH_SWD/../../../bin/jh-checks-lib"

SELECTOR="Mem"
TOTAL="$(free -m | grep "${SELECTOR}:" | awk '{print $2}' 2>/dev/null)"
FREE="$(free -m | grep "${SELECTOR}:" | awk '{print $4}' 2>/dev/null)"

if  [ -z "$TOTAL" ]; then
    check_faclity_not_present "Physical memory"
    exit 0
fi

if [ "$TOTAL" -gt "0" ]; then
    ((PERCENT = 100 * FREE / TOTAL))
fi

test_test() {
    if [ "$TOTAL" -gt "0" ]; then
        test "$PERCENT" -gt "5"
    else
        true
    fi
}

test_summary() {
    if [ "$TOTAL" -gt "0" ]; then
        echo "${PERCENT}% free (${FREE}M / ${TOTAL}M)"
    else
        echo "No memory found"
    fi
}

test_detailled() {
    if [ "$TOTAL" -gt "0" ]; then
        free -h | grep "${SELECTOR}"
    else
        true
    fi
}

if jh-is-full-machine >/dev/null; then
    main
fi
