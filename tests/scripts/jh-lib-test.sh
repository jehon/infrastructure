#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

# Script Working Directory
TWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

#
# We need to re-import it for JH_SWD to be set correctly
#
# shellcheck source=SCRIPTDIR/../../packages/jehon/usr/bin/jh-lib
. "$JH_PKG_FOLDER/packages/jehon/usr/bin/jh-lib"

assert_equals "JH_SWD" "$TWD" "$JH_SWD"

assert_file_exists "/etc/hosts"
