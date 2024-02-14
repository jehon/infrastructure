#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(dirname "$( realpath "${BASH_SOURCE[0]}")")"
PRJ_ROOT="$( "$SWD" )"

export DEBIAN_FRONTEND=noninteractive

root_or_sudo() {
    if [ "$( id -u )" == "0" ]; then
        # In Docker
        "$@"
    else
        # On system
        sudo "$@"
    fi  
}

cd "${SWD}"

apt_install() {
    # /repo is not always available
    root_or_sudo apt install --quiet --yes "$@"
}

root_or_sudo apt update

apt_install \
    curl git sshpass \
    python3 python3-pip \
    python3-netaddr python3-passlib python3-apt default-libmysqlclient-dev

mkdir --mode=0777 -p tmp
curl -fsSL https://jehon.github.io/packages/jehon.deb -o tmp/jehon.deb
apt_install ./tmp/jehon.deb

root_or_sudo apt update

if type direnv &>/dev/null ; then
    direnv allow "$PRJ_ROOT"/
fi

root_or_sudo /usr/sbin/jh-install-shellcheck
