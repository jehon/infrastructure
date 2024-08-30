#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

SCRIPT="$prjRoot/packages/jehon/usr/bin/jh-disk-space-test.sh"

assert_success "with 1" "$SCRIPT" / 1

assert_failure "with huge" "$SCRIPT" / 999999
