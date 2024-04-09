#!/usr/bin/env bash

set -o errexit

TEST_SELF="$( realpath "$0" )"

if [ -z "$JH_TEST_NAME" ]; then
    JH_TEST_NAME="$( basename "$( dirname "${TEST_SELF}" )" )/$( basename "${TEST_SELF}" )"
fi
export JH_TEST_NAME

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")"/../test-helpers.sh

export JH_TEST_SCRIPTS_TMP="${JH_TEST_TMP}"
mkdir -p "${JH_TEST_SCRIPTS_TMP}"
