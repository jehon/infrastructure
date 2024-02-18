#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/../../../../../jehon/usr/bin/jh-lib
. jh-lib

# shellcheck source=SCRIPTDIR/../../../../../jehon/usr/bin/jh-checks-lib
. "/usr/bin/jh-checks-lib"

check_mount "/mnt/cloud/photos"
