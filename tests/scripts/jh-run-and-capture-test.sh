#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

test_capture_empty

header_begin "with success"
test_capture "run successfull" jh-run-and-capture bash -c "echo coucou"
assert_captured_success "Should success"
assert_captured_output_contains "run failure show command" "echo coucou"
# assert_true "Output only ok" "" "$JH_TEST_CAPTURED_OUTPUT"
header_end

header_begin "with failure"
test_capture "run failure" jh-run-and-capture bash -c "echo coucou; nothing"
assert_captured_failure "Shoud fail"
assert_equals "run failure exit code" "$JH_TEST_CAPTURED_EXITCODE" "127"
assert_captured_output_contains "run failure show command" "echo coucou; nothing"
assert_captured_output_contains "run failure show stdout" "coucou"
assert_captured_output_contains "run failure show stderr" "nothing"
header_end
