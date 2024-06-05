#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

SCRIPT="$JH_PKG_FOLDER/packages/jehon/usr/bin/jh-fo"

assert_success run "$SCRIPT" "-h"
