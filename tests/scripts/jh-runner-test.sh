#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

rm -fr "${JH_TEST_TMP}"
mkdir -p "${JH_TEST_TMP}"

{
    echo "exit 0" >"${JH_TEST_TMP}"/good-test.sh
    chmod +x "${JH_TEST_TMP}"/good-test.sh
    jh-runner "${JH_TEST_TMP}" || jh_fatal "Should have succeeded"
    ok
} | jh-tag-stdin "First run"

{
    echo "exit 1" >"${JH_TEST_TMP}"/error.sh
    jh-runner "${JH_TEST_TMP}" || jh_fatal "Should have succeeded"
    ok
} | jh-tag-stdin "With error not executable"

{
    chmod +x "${JH_TEST_TMP}"/error.sh
    jh-runner "${JH_TEST_TMP}" && jh_fatal "Should have failed"
    ok
} | jh-tag-stdin "With error executable"

# Exclude the error test
{
    chmod +x "${JH_TEST_TMP}"/error.sh
    jh-runner "${JH_TEST_TMP}" ".*-test" || jh_fatal "Should have succeeded"
} | jh-tag-stdin "With error excluded"
