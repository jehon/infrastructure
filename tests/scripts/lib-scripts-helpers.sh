#!/usr/bin/env bash

set -o errexit

# For test-helpers.sh
SUB_TEST="scripts"

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")"/../test-helpers.sh

export JH_TEST_SCRIPTS_TMP="${JH_TEST_TMP}/scripts"
mkdir -p "${JH_TEST_SCRIPTS_TMP}"
