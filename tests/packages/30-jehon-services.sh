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
	EOS
) | test_in_docker
