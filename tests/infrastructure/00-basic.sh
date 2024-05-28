#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/lib-infrastructure-test.sh"

(
	cat <<-'EOS'
		echo "************* Setup *******************"
		./setup.sh

		echo "************* Dump *******************"
		make dump

		echo "************* Repositories *******************"
		ls -l /etc/apt/sources.list.d

		echo "************* Ansible is installed *******************"
		make dump-runtimes

		echo "************* Share ansible is mounted *******************"
		cd infrastructure
		ls ansible.cfg

		echo "************* Secrets are ok *******************"
		ls inventory/
		cat inventory/50-hosts.yml
		! cat inventory/50-hosts.yml | grep -q '!vault'

		cat ../tmp/infrastructure/encryption-key
		cat ../tmp/infrastructure/encryption-key | grep "encryption-key-mock"
	EOS
) | run_in_docker "ubuntu:latest"
