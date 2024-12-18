#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/lib-packages-test.sh"

(
	cat <<-'EOS'
		echo "Testing Release is present"
		test -r /setup/packages/Release

		echo "************* defined sources *******************"
		ls -l /etc/apt/sources.list.d/

		echo "************* all jehon packages available *******************"
		apt-cache search jehon

		echo "************* all version of jehon packages *******************"
		apt-cache policy
		apt-cache policy dpkg
		apt-cache policy jehon
	EOS
) | run_in_docker
