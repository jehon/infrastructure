#!/usr/bin/bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../../bin/
. jh-lib

curl -fsSL https://apt.grafana.com/gpg.key | gpg --dearmor --yes -o "$JH_SWD/jehon-grafana.gpg"
