#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/lib-infrastructure-test.sh"

(
	cat <<-EOS
		cd infrastructure

		cat inventory/*

		ansible-playbook setup.yml ${JH_ANSIBLE_TEST} --limit kiosk

		set -x
		type jh-lib

		dpkg -l | grep "jehon-hardware-raspberrypi"

		jh-checks | jh-tag-stdin "checks" || true
	EOS
) | test_in_docker
