#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

# shellcheck source-path=SCRIPTDIR
. "$(dirname "$( realpath "${BASH_SOURCE[0]}")")"/test-lib.sh

build_run_env ""

fo_run problems

assert_others_untouched