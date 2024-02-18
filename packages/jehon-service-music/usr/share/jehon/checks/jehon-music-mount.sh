#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../../../../../jehon/usr/bin/
. jh-lib

# shellcheck source-path=SCRIPTDIR/../../../../../jehon/
. /usr/bin/jh-checks-lib

check_mount "/mnt/cloud/musiques"
