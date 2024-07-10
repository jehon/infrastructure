#!/usr/bin/env bash

set -o errexit

JH_ROOT="$(dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")"

# shellcheck source=SCRIPTDIR/../../packages/jehon/usr/bin/jh-lib
. "$JH_ROOT"/packages/jehon/usr/bin/jh-lib

echo "Here we are at $(date)"

env | grep JH_

jh_info "one information"
jh_error "one error"
jh_debug "one invisible debug"
jh_value "data" "has value"
DEBUG=1 jh_debug "one visible debug"

echo ": $JH_MSG_OK ok"
echo ": $JH_MSG_KO ko"
ok "ok?"
ko "ko?"
