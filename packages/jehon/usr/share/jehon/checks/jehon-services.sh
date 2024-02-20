#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/../../../../../jehon/usr/bin/jh-lib
. jh-lib

# shellcheck source=SCRIPTDIR/../../../bin/jh-checks-lib
. "$JH_SWD/../../../bin/jh-checks-lib"

check_with_systemd "ssh"
check_with_systemd "jehon-update-rclone.timer"
