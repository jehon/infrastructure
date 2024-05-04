#!/usr/bin/env bash

set -o errexit

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR/
. "${_SD}/../packages/jehon/usr/bin/jh-lib"

# shellcheck source-path=SCRIPTDIR/
. "${_SD}/data/docker/run.sh"

JH_TEST_NAME="${JH_TEST_NAME:-$(jh-fs "name" "${BASH_SOURCE[1]}")}"
JH_TEST_TMP="${JH_PKG_FOLDER}/tmp/$(dirname "$(realpath --relative-base "${JH_PKG_FOLDER}/tests" "$0")")/$JH_TEST_NAME"
mkdir -p "$JH_TEST_TMP"

#
# Log the success (with a green ✓)
#
log_success() {
    jh_pipe_message "$(echo -e "\e[1;32m\xE2\x9C\x93\e[1;00m Test '\e[1;33m$1\e[00m' success")"
}

#
# Log the failure and exit with code '1' (with a red ✘)
#
log_failure() {
    (
        if [ -n "$JH_TEST_CAPTURED_OUTPUT" ]; then
            echo "*** Captured output begin ***"
            echo -e "$JH_TEST_CAPTURED_OUTPUT"
            echo "*** Captured output end ***"
        fi
        echo -e "\e[1;31m\xE2\x9C\x98\e[1;00m Test '\e[1;33m$1\e[00m' failure: \e[1;31m$2\e[1;00m"
        echo "To have potentially more details, please run tests.sh with DEBUG=1"
    ) >&3
    exit 1
}

assert_true() {
    local V=$?
    if [ -n "$2" ]; then
        V="$2"
    fi
    if ((V != 0)); then
        log_failure "$1" "result is not-zero ($V)"
    fi
    log_success "$1"
}

assert_equals() {
    local V=$?
    if [ -n "$2" ]; then
        V="$2"
    fi
    if [[ "$2" != "$3" ]]; then
        log_failure "$1" "result ($3) does not equal expected ($2)"
    fi
    log_success "$1: Expected ($2) is equal to result ($3)"
}

assert_file_exists() {
    if [ -e "$1" ]; then
        log_success "File exists: $1"
    else
        log_failure "File exists: $1" "not found ( $(cd "$(dirname "$1")" && find . -maxdepth 1 -type f -exec basename "{}" ";" | tr '\n' ' '))"
    fi
}

assert_success() {
    test_capture "$@"
    if [[ $JH_TEST_CAPTURED_EXITCODE -gt 0 ]]; then
        log_failure "$CAPTURED_HEADER" "command return $JH_TEST_CAPTURED_EXITCODE"
    fi
    log_success "$CAPTURED_HEADER"
}

assert_failure() {
    test_capture "$@"
    if [[ $JH_TEST_CAPTURED_EXITCODE -eq 0 ]]; then
        log_failure "$CAPTURED_HEADER" "command return $JH_TEST_CAPTURED_EXITCODE (success)"
    fi
    log_success "$CAPTURED_HEADER"
}

test_capture() {
    CAPTURED_HEADER="$1"
    JH_TEST_CAPTURED_OUTPUT=""
    JH_TEST_CAPTURED_EXITCODE=0
    shift

    if [ -z "$1" ]; then
        echo "Usage: test_capture <header> <command> <arg>+ "
        exit 255
    fi

    set +e
    JH_TEST_CAPTURED_OUTPUT="$("$@" 2>&1)"
    JH_TEST_CAPTURED_EXITCODE="$?"
    set -o errexit

    return 0
}

test_capture_file() {
    test_capture "$1" cat "$2"
}

test_capture_empty() {
    CAPTURED_HEADER=""
    JH_TEST_CAPTURED_OUTPUT=""
    JH_TEST_CAPTURED_EXITCODE=0
}

assert_captured_output_contains() {
    local MSG="$1"
    local TEST="$2"
    if [ -z "$1" ]; then
        echo "Usage: assert_captured_output_contains [header] <expected-regex>"
        echo "   header default to contains"
        exit 255
    fi
    if [ -z "$TEST" ]; then
        TEST="$MSG"
    fi

    local FOUND=0
    local BACKUP_IFS="$IFS"
    IFS=$'\n'

    while read -r R; do
        if [[ "$R" =~ $TEST ]]; then
            FOUND=1
        fi
    done < <(echo -e "$JH_TEST_CAPTURED_OUTPUT")
    IFS="$BACKUP_IFS"

    if [ $FOUND != 1 ]; then
        log_failure "$CAPTURED_HEADER: $MSG" "$TEST not found in output"
    fi
    log_success "$CAPTURED_HEADER: $MSG"
}
