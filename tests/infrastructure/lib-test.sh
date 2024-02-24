#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../../bin/lib.sh"

# shellcheck source=/dev/null
. jh-lib

# shellcheck source-path=SCRIPTDIR/../
TEST_NAME="$(basename "${BASH_SOURCE[1]}")"
TAG="test-ansible-${TEST_NAME}"
exec &> >( /usr/bin/jh-tag-stdin "$TEST_NAME" )

echo "*******************************************************"
echo "***"
echo "*** Test in docker: ${TEST_NAME}"
echo "*** Tag:            ${TAG}"
echo "***"
echo "*******************************************************"

docker kill "${TAG}" &>/dev/null || true
docker rm -f "${TAG}" &> /dev/null || true
# Caution: will be pasted as-is
export JH_ANSIBLE_TEST="--connection=local --extra-vars '{\"virtual\": true, \"jehon_deb_url\": \"file:///setup/packages/jehon.deb\"}'"

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

			export PATH="$REMOTE_PRJ/tmp/python/bin:\$PATH"
			export PYTHONPATH="$REMOTE_PRJ/tmp/python:\$PYTHONPATH"

			cd "${REMOTE_PRJ}"
			make dependencies
		EOS
		cat -
		cat <<-EOS
			set +x
			echo
		EOS
	) | docker run --rm --name "$TAG" --interactive  \
			-v "$PRJ_ROOT:$REMOTE_PRJ" \
			-v "$PRJ_ROOT/tmp/50-hosts.yml:$REMOTE_PRJ/infrastructure/inventory/50-hosts.yml" \
			-v "test-ansible-python-cache:$REMOTE_PRJ/tmp/python" \
			--tmpfs "$REMOTE_PRJ/infrastructure/built" \
			--tmpfs "$REMOTE_PRJ/tmp" \
			"$IMG" "bash" \
		|& jh-tag-stdin "inside" \
		|| jh_fatal "!! Test failed: $TEST_NAME ($?) !!"

	echo "**************************************"
	echo "***                                ***"
	echo "*** Test in docker: $TEST_NAME - done"
	echo "***                                ***"
	echo "**************************************"
}
