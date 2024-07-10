#!/usr/bin/env bash

set -o errexit
# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

# Script Working Directory
TWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

assert_equals "JH_SWD" "$TWD" "$JH_SWD"

assert_file_exists "/etc/hosts"
