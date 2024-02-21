#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source=SCRIPTDIR/../test-helpers.sh
. "$SWD/../test-helpers.sh"

TEST_NAME="$(jh-fs "name" "${BASH_SOURCE[1]}")"
exec &> >( jh-tag-stdin "$TEST_NAME" )

TAG="test-packages/$TEST_NAME"

echo "*******************************************************"
echo "***"
echo "*** Test in docker: $TEST_NAME"
echo "***"
echo "*******************************************************"

docker build \
	-f "$SWD/$TEST_NAME.docker" \
	--build-context "publish=${JH_ROOT}/tmp/publish" \
	--tag "$TAG" \
	"$SWD" | jh-tag-stdin "building"

# shellcheck disable=SC2120
# shellcheck disable=SC2119
test_in_docker() {
	(
		cat <<-'EOS'
			echo "+ pre-script begin"
			set -o errexit
			set -o pipefail

			echo "Loading jh-lib"
			. /usr/bin/jh-lib
			echo "Loaded"

			cd /setup

			header_begin "Custom script"
		EOS
		cat -
		cat <<-'EOS'
			echo
			header_end

			header_begin "Run jh-checks (but without failing)"
			/usr/bin/jh-checks || true
			header_end

			header_begin "Validating systemd unit files"
			find /lib/systemd \
			    -type f -name "jh*.service" \
			    -exec systemd-analyze verify "{}" "+"
			header_end
		EOS
	) | docker run --label temp --rm -i --privileged "$TAG" "bash" \
		|& jh-tag-stdin "inside" \
		|| jh_fatal "!! Test failed: $TEST_NAME ($?) !!"

	echo "**************************************"
	echo "***                                ***"
	echo "*** Test in docker: $TEST_NAME - done"
	ok "docker test $TEST_NAME"
	echo "***                                ***"
	echo "**************************************"
}

export TEST_NAME
export TAG