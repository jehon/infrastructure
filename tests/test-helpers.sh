#!/usr/bin/env bash

set -o errexit

# The root of the repository
JH_ROOT="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"
export JH_ROOT

# for jh-lib-test
export JH_TEST_ROOT="${JH_PKG_FOLDER}"

# shellcheck source-path=SCRIPTDIR/../
. "$JH_ROOT/packages/jehon/usr/bin/jh-lib-test"

JH_TEST_DATA="$JH_ROOT/tests/data"
export JH_TEST_DATA

# JH_ORIGINAL_ARGS=( "$@" )
# export JH_ORIGINAL_ARGS
