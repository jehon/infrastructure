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

#
# Without jh-tag-stdin...
#
echo "**************************************************************************************************"
echo "**************************************************************************************************"
echo "**************************************************************************************************"
echo "**************************************************************************************************"
echo "*****"
echo "*****"
echo "***** Fixed ip:  {{ fixed_ip }}"
echo "***** Gateway:   {{ jehon.ip.gateway }}"
echo "*****"
echo "***** Harware:   {{ jehon_hardware }}"
echo "***** OS:        {{ jehon_os }}"
echo "*****"
echo "*****"
echo "**************************************************************************************************"
echo "**************************************************************************************************"
echo "**************************************************************************************************"
echo "**************************************************************************************************"

echo "************* System updating.... *************"
apt_do install --fix-broken
apt_do full-upgrade
echo "************* System updated *************"

if dpkg -L | grep "jehon" | grep "ii" >& /dev/null; then
    echo "* Package jehon already installed"
else
    apt_do install ./jehon.deb
    #
    # We have the jh-lib etc... installed
    #
    apt_do update | jh-tag-stdin "jehon/update"
fi

# shellcheck source=/usr/bin/jh-lib
. jh-lib
jh_info "jh-lib loaded"

if [ -n "{{ fixed_ip }}" ]; then
    jh_info "Generating netplan configuration"
    cat > /etc/netplan/eth0-fixed.yaml <<-EOF
#
# bootstrap generated file
#

network:
    version: 2
    ethernets:
        eth0:
            addresses:
              - {{ fixed_ip }}/24
            routes:
              - to: 0.0.0.0
                via: {{ jehon.ip.gateway }}
            nameservers:
                addresses:
                  - {{ jehon.ip.gateway }}
                  - 8.8.8.8
            # dhcp4: false

EOF
fi

header_begin "Try the netplan configuration"
netplan try --timeout=5 |& jh-tag-stdin "netplan/try"
header_end

header_begin "Apply the netplan configuration"
netplan apply |& jh-tag-stdin "netplan/apply"
header_end

header_begin "Restart ssh (enable key authentication)"
systemctl restart sshd
header_end

install_if "jehon-hardware-{{ jehon_hardware }}" "{{ jehon_hardware }}" "hardware"
install_if "jehon-os-{{ jehon_os }}" "{{ jehon_os }}" "os"

apt_do full-upgrade | jh-tag-stdin "full-upgrade"
apt_do auto-remove | jh-tag-stdin "auto-remove"

echo "Ok... rebooting"
reboot
