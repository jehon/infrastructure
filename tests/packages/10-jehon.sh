#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR
. "$SWD/lib-packages-test.sh"

(
	cat <<-'EOS'
		echo "************* installing packages *******************"
		# github is not yet configured anyway...
		apt install --yes jehon

		echo "************* defined sources *******************"
		ls -l /etc/apt/sources.list.d/

		echo "************* all jehon packages available *******************"
		apt-cache search jehon

		echo "************* all version of jehon packages *******************"
		apt-cache policy
		apt-cache policy dpkg
		apt-cache policy jehon
	EOS
) | run_in_docker "debian:stable" "$0"
