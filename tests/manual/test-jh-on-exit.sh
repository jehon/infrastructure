#!/usr/bin/env bash

clear

prjRoot="$(dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")"

# shellcheck source=SCRIPTDIR/../../packages/jehon/usr/bin/jh-lib
. "$prjRoot"/packages/jehon/usr/bin/jh-lib

ee() {
    echo "* cool, on exit" "$@"
    echo "1: $1"
    echo "2: $2"
    echo
}
jh_on_exit_success ee
jh_on_exit_success "ee 1 2"
jh_on_exit_success "ee '1 2'"
jh_on_exit_success "ee \"1 2\""

jh_on_exit_failure "echo 'it is a failure'"

if [ -n "$1" ]; then
    jh_fatal "force failing"
fi

ok
