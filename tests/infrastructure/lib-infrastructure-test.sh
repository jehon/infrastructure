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
export JH_ANSIBLE_TEST="--connection=local --extra-vars '{\"jh_basis_deb_url\": \"/setup/packages/jehon.deb\"}'"

# shellcheck disable=SC2120
# shellcheck disable=SC2119
test_in_docker() {
	IMG="${1:-test-ansible/ansible}:local"

	REMOTE_PRJ="/workspace"

	echo "***    - image: $IMG"

	(
		cat <<-EOS
			echo "+ pre-script begin"
			set -o errexit
			set -o pipefail

			export PATH="$REMOTE_PRJ/tmp/python/common/bin:\$PATH"
			export PYTHONPATH="$REMOTE_PRJ/tmp/python/common:\$PYTHONPATH"

			cd "${REMOTE_PRJ}"
			make dependencies
		EOS
		cat -
		cat <<-EOS
			set +x
			rm -f /etc/apt/sources.list.d/jehon-github.*
			echo
		EOS
	) | docker run --rm --name "$TAG" --interactive \
		-v "$JH_PKG_FOLDER:$REMOTE_PRJ" \
		-v "$JH_PKG_FOLDER/tmp/infrastructure/50-hosts.yml:$REMOTE_PRJ/infrastructure/inventory/50-hosts.yml" \
		--tmpfs "$REMOTE_PRJ/infrastructure/built" \
		"$IMG" "bash" |&
		jh-tag-stdin "inside" ||
		jh_fatal "!! Test failed: $TEST_NAME ($?) !!"

	echo "**************************************"
	echo "***                                ***"
	echo "*** Test in docker: $TEST_NAME - done"
	echo "***                                ***"
	echo "**************************************"
}
