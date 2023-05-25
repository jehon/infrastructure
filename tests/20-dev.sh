#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR
. "$SWD/lib-test.sh"

(
	cat <<-'EOS'
		cd ansible && ansible-playbook setup.yml --connection=local --limit dev -e "virtual=true"
	EOS
) | test_in_docker
