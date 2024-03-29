#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/lib-scripts-helpers.sh"

test_capture "ls /" ls /
assert_captured_success "should be successfull"
assert_captured_output_contains "contains at least 'etc'" "etc"

assert_success "ls /etc" ls /etc
assert_captured_output_contains "at least 'hosts'" "hosts"

assert_success "echo 'hello' " echo 'hello'
assert_captured_output_contains "hello"
assert_captured_output_md5 "b1946ac92492d2347c6235b4d2611184"

test_capture "exit 0" exit 0
assert_captured_success

test_capture "exit 1" exit 1
assert_captured_failure ""

assert_file_exists "/etc/hosts"
# assert_file_exists "/etc/cron.daily/xxx"

echo "Test done"
