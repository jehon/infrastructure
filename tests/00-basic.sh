#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/lib-test.sh"

(
	cat <<-'EOS'
		echo "************* Dump *******************"
		make dump

		echo "************* Ansible is installed *******************"
		make ansible-dump-runtimes

		echo "************* Share ansible is mounted *******************"
		ls ansible/ansible.cfg

		echo "************* Secrets are ok *******************"
		ls ansible/inventory/
		cat ansible/inventory/00-parameters.yml
		! cat ansible/inventory/00-parameters.yml | grep -q '!vault'

		cat ansible/built/ansible-encryption-key
		! cat ansible/built/ansible-encryption-key | grep -v "1234"
	EOS
) | test_in_docker
