#!/usr/bin/env bash

JH_ROOT="$(dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")"

# shellcheck source=SCRIPTDIR/../../packages/jehon/usr/bin/jh-lib
. "$JH_ROOT"/packages/jehon/usr/bin/jh-lib

ee1() {
    echo "cool, on exit 1"
}
jh_on_exit_success ee1

jh_on_exit_success "echo \"test\""
jh_on_exit_success "echo \"test test\""

ee2() {
    echo "cool, on exit 2"
}
jh_on_exit_success ee2

jh_on_exit_failure "echo \"it is a failure\""
echo "at the end"
