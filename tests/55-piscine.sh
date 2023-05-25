#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/lib-test.sh"

(
	cat <<-'EOS'
		ansible-playbook setup.yml --connection=local --limit piscine -e "virtual=true"

		dpkg -l | grep "jehon-hardware-raspberrypi"
	EOS
) | test_in_docker
