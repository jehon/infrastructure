#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/lib-test.sh"

(
	cat <<-EOS
		cd infrastructure
		ansible-playbook dump.yml ${JH_ANSIBLE_TEST} --limit dev
	EOS
) | test_in_docker
