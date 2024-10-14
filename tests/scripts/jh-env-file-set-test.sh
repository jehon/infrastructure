#!/usr/bin/env bash

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

script="$prjRoot"/packages/jehon/usr/bin/jh-env-file-set

# JH_TEST_TMP

declare test
declare test2

e1="$JH_TEST_TMP/test.env"
rm -f "$e1"

assert_success "init" "$script" "$e1" "test" "cool"
(
    # shellcheck source=/dev/null
    . "$e1"

    assert_equals "test" "cool" "$test"
)

assert_success "update" "$script" "$e1" "test" "cool1"
(
    # shellcheck source=/dev/null
    . "$e1"
    assert_equals "test" "cool1" "$test"
)

assert_success "add" "$script" "$e1" "test2" "cool2"
(
    # shellcheck source=/dev/null
    . "$e1"
    assert_equals "test" "cool1" "$test"
    assert_equals "test2" "cool2" "$test2"
)

assert_success "special chars" "$script" "$e1" "test" "blabla/blibli"
(
    # shellcheck source=/dev/null
    . "$e1"
    assert_equals "test" "blabla/blibli" "$test"
    assert_equals "test2" "cool2" "$test2"
)
