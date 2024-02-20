#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR
. "$SWD/lib-packages-test.sh"

(
	cat <<-'EOS'
		ok_ko "lib can test something positive" "[ 1 == 1 ]"
		ok_ko "Testing Release is present" "[ -r /setup/repo/Release ]"

		echo "************* all jehon packages available *******************"
		apt-cache search jehon

		echo "************* all version of jehon packages *******************"
		apt-cache policy
		apt-cache policy dpkg
		apt-cache policy jehon

		echo "************* python setup *******************"
		test -e /var/lib/python/jehon/requirements.txt
		source /etc/profile.d/jehon-commons.sh

		find /usr/lib/python3/dist-packages/jehon -type f
		/usr/bin/jh-python-test
	EOS
) | test_in_docker
