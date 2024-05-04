#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/lib-infrastructure-test.sh"

(
	cat <<-EOS
		echo "************* Setup *******************"
		./setup.sh

		echo "************* Run setup kiosk *******************"
		cd infrastructure
		ansible-playbook setup.yml ${JH_ANSIBLE_TEST} --limit kiosk
	EOS
) | test_in_docker
