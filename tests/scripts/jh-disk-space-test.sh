#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

SCRIPT="$prjRoot/packages/jehon/usr/bin/jh-disk-space-test.sh"

assert_success run "$SCRIPT" / 1

assert_failure run "$SCRIPT" / 100000
