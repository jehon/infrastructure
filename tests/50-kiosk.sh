#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/lib-test.sh"

(
	cat <<-'EOS'
		cd ansible
		
		cat inventory/*

		ansible-playbook setup.yml --connection=local --limit kiosk -e "virtual=true"

		set -x
		type jh-lib
		type node
		type npm

		dpkg -l | grep "jehon-hardware-raspberrypi"

		test -r /opt/jehon/kiosk/package.json
		/etc/cron.daily/jh-kiosk-daily /opt/jehon/kiosk/tests/kiosk.yml

		jh-checks | jh-tag-stdin "checks" || true
	EOS
) | test_in_docker
