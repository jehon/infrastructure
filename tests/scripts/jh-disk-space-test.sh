#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

SCRIPT="$JH_ROOT/packages/jehon/usr/bin/jh-disk-space-test.sh"

test_capture run "$SCRIPT" / 1
assert_captured_success "should be successfull"

test_capture run "$SCRIPT" / 100000
assert_captured_failure "should be failing"
