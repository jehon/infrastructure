#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../../../../../jehon/usr/bin/
. jh-lib

# shellcheck source-path=SCRIPTDIR/../../../../../jehon/usr/bin/
. jh-checks-lib

if [ ! -r /usr/share/jehon/is_wsl ]; then
    check_with_systemd "jehon-dmesg.service"
fi
