#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../test-helpers.sh"

# Redefine after override
_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
