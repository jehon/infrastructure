#!/usr/bin/bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../../bin/
. jh-lib

curl -fsSL https://apt.mopidy.com/mopidy.gpg > "$JH_SWD/jehon-mopidy.gpg"
