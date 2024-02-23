#!/usr/bin/env bash

set -o errexit

# The root of the repository
JH_ROOT="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"
export JH_ROOT

TEST_SELF="$( realpath "${BASH_SOURCE[2]}" )"

# for jh-lib-test
export JH_TEST_ROOT="$JH_ROOT"

export JH_TEST_NAME="$( basename "$( dirname "${TEST_SELF}" )" )/$( basename "${TEST_SELF}" )"

# shellcheck source-path=SCRIPTDIR/../
. "$JH_ROOT/packages/jehon/usr/bin/jh-lib-test"

JH_TEST_DATA="$JH_ROOT/tests/data"
export JH_TEST_DATA

# JH_ORIGINAL_ARGS=( "$@" )
# export JH_ORIGINAL_ARGS
