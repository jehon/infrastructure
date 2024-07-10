#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

SCRIPT="$prjRoot/packages/jehon/usr/bin/jh-fo"

assert_success run "$SCRIPT" "-h"
