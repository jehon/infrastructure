#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/lib-infrastructure-test.sh"

(
	cat <<-EOS
		echo "************* Run dump dev *******************"
		cd infrastructure
		ansible-playbook dump.yml ${JH_ANSIBLE_TEST} --limit dev
	EOS
) | test_in_docker
