#!/usr/bin/env bash

set -o errexit

JH_ROOT="$(dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")"

# shellcheck source=SCRIPTDIR/../../packages/jehon/usr/bin/jh-lib
. "$JH_ROOT"/packages/jehon/usr/bin/jh-lib

jh_log_or_tty "$JH_PKG_FOLDER"/tmp/test-jh-lib.log

echo "Here we are at $(date)"

env | grep JH_

jh_info "one information"
jh_error "one error"
jh_debug "one invisible debug"
jh_value "data" "has value"
JH_LOGLEVEL=10 jh_debug "one visible debug"

echo ": $JH_MSG_OK ok"
echo ": $JH_MSG_KO ko"
ok "ok?"
ko "ko?"

jh_exclusive "$1"

header_begin "working..."
for i in {1..5}; do
    echo "$i"
    sleep 0.1s
done
header_end
