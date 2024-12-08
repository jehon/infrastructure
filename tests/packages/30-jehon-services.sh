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
		apt install --yes jehon
		apt update
		apt install --yes jehon-service-*
	EOS
) | run_in_docker
