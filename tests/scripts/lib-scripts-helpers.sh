#!/usr/bin/env bash

set -o errexit

TEST_SELF="$( realpath "${BASH_SOURCE[1]}" )"

JH_TEST_NAME="$( basename "$( dirname "${TEST_SELF}" )" )/$( basename "${TEST_SELF}" )"
export JH_TEST_NAME

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")"/../test-helpers.sh

export JH_TEST_SCRIPTS_TMP="${JH_TEST_TMP}/scripts"
mkdir -p "${JH_TEST_SCRIPTS_TMP}"
