#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR/../
TEST_NAME="$(basename "${BASH_SOURCE[1]}")"
exec &> >( /usr/bin/jh-tag-stdin "$TEST_NAME" )

echo "*******************************************************"
echo "***"
echo "*** Test in docker: $TEST_NAME"
echo "***"
echo "*******************************************************"

docker kill "test-ansible-$TEST_NAME" &>/dev/null || true
docker rm -f "test-ansible-$TEST_NAME" &> /dev/null || true

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

			export PATH="$REMOTE_PRJ/.python/bin:\$PATH"
			export PYTHONPATH="$REMOTE_PRJ/.python:\$PYTHONPATH"

			cd $REMOTE_PRJ
			make ansible-dependencies
		EOS
		cat -
		cat <<-EOS
			set +x
			echo
		EOS
	) | docker run --rm --name "test-ansible-$TEST_NAME" --interactive  \
			-v "$PRJ_ROOT:$REMOTE_PRJ" \
			-v "$PRJ_ROOT/tmp/00-parameters.yml:$REMOTE_PRJ/inventory/00-parameters.yml" \
			-v "test-ansible-python-cache:$REMOTE_PRJ/.python" \
			--tmpfs "$REMOTE_PRJ/ansible/.galaxy" \
			--tmpfs "$REMOTE_PRJ/ansible/built" \
			--tmpfs "$REMOTE_PRJ/tmp" \
			"$IMG" "bash" \
		|& jh-tag-stdin "inside" \
		|| fatal "!! Test failed: $TEST_NAME ($?) !!"

	echo "**************************************"
	echo "***                                ***"
	echo "*** Test in docker: $TEST_NAME - done"
	echo "***                                ***"
	echo "**************************************"
}
