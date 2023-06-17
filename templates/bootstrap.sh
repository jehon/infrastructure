#!/usr/bin/bash

# String with templated appear always ok but are not...
# shellcheck disable=SC2157

set -o errexit
set -o pipefail

echo "Bootstrapping the system..."

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=C
export LANG=C

apt_do() {
    apt --yes --quiet -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" --allow-downgrades "$@"
}

install_if() {
    PKG="$1"
    TAG="$2"
    SYSTEM="$3"

    if [ -n "$TAG" ]; then
        if dpkg -L | grep "$PKG" | grep "ii" >& /dev/null; then
            echo "Package $PKG already installed"
        else
            apt_do install "$PKG" | jh-tag-stdin "$SYSTEM/$TAG/install"
            apt_do update | jh-tag-stdin "$SYSTEM/$TAG/update"
        fi
    fi
}

apt_do install --fix-broken

if dpkg -L | grep "jehon" | grep "ii" >& /dev/null; then
    echo "Package jehon already installed"
else
    wget https://jehon.github.io/packages/jehon.deb -O jehon.deb
    apt_do install ./jehon.deb
    #
    # We have the jh-lib etc... installed
    #
    apt_do update | jh-tag-stdin "jehon/update"
fi


install_if "jehon-hardware-{{ jehon_hardware }}" "{{ jehon_hardware }}" "hardware"
install_if "jehon-hardware-{{ jehon_hardware }}" "{{ jehon_hardware }}" "hardware"

apt_do full-upgrade | jh-tag-stdin "full-upgrade"
apt_do auto-remove | jh-tag-stdin "auto-remove"

echo "Ok... rebooting"
reboot
