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
		make dump-runtimes

		echo "************* Share ansible is mounted *******************"
		ls ansible.cfg

		echo "************* Secrets are ok *******************"
		ls inventory/
		cat inventory/50-hosts.yml
		! cat inventory/50-hosts.yml | grep -q '!vault'

		cat built/encryption-key
		cat built/encryption-key | grep "12345-encryption-key-6789"
	EOS
) | test_in_docker
