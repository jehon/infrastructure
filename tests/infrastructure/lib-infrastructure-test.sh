#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../test-helpers.sh"

# shellcheck source-path=SCRIPTDIR
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../../bin/lib.sh"

# Redefine after override
_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# Caution: will be pasted as-is
export JH_ANSIBLE_TEST="--connection=local --extra-vars '{\"jh_01_basis_deb_url\": \"/setup/packages/jehon.deb\"}'"
export baseImageWithSetup

test_in_docker() {
	run_in_docker "${baseImageWithSetup}"
}
