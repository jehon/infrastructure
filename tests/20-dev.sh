#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/lib-test.sh"

(
	cat <<-'EOS'
		cd infrastructure
		ansible-playbook setup.yml --connection=local --limit dev -e "virtual=true"
	EOS
) | test_in_docker
