#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/../../../../../jehon/usr/bin/jh-lib
. jh-lib

# shellcheck source=SCRIPTDIR/../../../bin/jh-checks-lib
. "$JH_SWD/../../../bin/jh-checks-lib"

if jh-is-full-machine >/dev/null; then
    test_test() {
        ! ( systemctl list-units --state=failed | grep failed >& /dev/null )
    }

    test_summary() {
        systemctl list-units --state=failed | grep -c "failed"
    }

    test_detailled() {
        systemctl list-units --state=failed | grep "failed"
    }

    main
fi
