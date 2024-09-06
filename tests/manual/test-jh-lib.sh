#!/usr/bin/env bash

set -o errexit

prjRoot="$(dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")"

# shellcheck source-path=SCRIPTDIR/../../
. "$prjRoot"/packages/jehon/usr/bin/jh-lib

echo "Here we are at $(date)"

env | grep JH_

jh_info "one information"
jh_error "one error"
jh_debug "one invisible debug"
jh_value "data" "has value"
DEBUG=1 jh_debug "one visible debug"

header_begin "Various messages"
echo ": $jhMsgOk ok"
echo ": $jhMsgKo ko"
header "blablabla and ok/ko"
ok "ok?"
ko "ko?"
header_end
