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

if [ -n "{{ jehon_os_package }}" ]; then
    apt --yes install "{{ jehon_os_package }}" | jh-tag-stdin "{{ jehon_os_package }}/install"
    apt --quiet --yes update | jh-tag-stdin "{{ jehon_os_package }}/update"
fi

if [ -n "{{ jehon_hardware_package }}" ]; then
    apt --yes install "{{ jehon_hardware_package }}" | jh-tag-stdin "{{ jehon_hardware_package }}/install"
    apt --quiet --yes update | jh-tag-stdin "{{ jehon_hardware_package }}/update"
fi

apt --yes full-upgrade | jh-tag-stdin "jehon/full-upgrade"
apt --yes auto-remove | jh-tag-stdin "jehon/auto-remove"

echo "Ok"
