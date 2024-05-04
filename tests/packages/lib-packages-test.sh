#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR/
. "${_SD}/../test-helpers.sh"
