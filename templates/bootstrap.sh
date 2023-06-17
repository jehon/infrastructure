#!/usr/bin/bash

# String with templated appear always ok but are not...
# shellcheck disable=SC2157

set -o errexit
set -o pipefail

echo "Bootstrapping the system..."

export DEBIAN_FRONTEND=noninteractive

wget https://jehon.github.io/packages/jehon.deb -O jehon.deb
apt install --yes  --fix-broken ./jehon.deb

#
# We have the jh-lib etc... installed
#

# shellcheck source=/dev/null
. jh-lib

apt --quiet --yes update | jh-tag-stdin "jehon/update"

if [ -n "{{ jehon_os }}" ]; then
    apt --yes install "jehon-os-{{ jehon_os }}" | jh-tag-stdin "os/{{ jehon_os }}/install"
    apt --quiet --yes update | jh-tag-stdin "os/{{ jehon_os }}/update"
fi

if [ -n "{{ jehon_hardware }}" ]; then
    apt --yes install "{{ jehon_hardware }}" | jh-tag-stdin "hardware/{{ jehon_hardware }}/install"
    apt --quiet --yes update | jh-tag-stdin "hardware/{{ jehon_hardware }}/update"
fi

apt --yes full-upgrade | jh-tag-stdin "full-upgrade"
apt --yes auto-remove | jh-tag-stdin "auto-remove"

echo "Ok"
