#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(dirname "$( realpath "${BASH_SOURCE[0]}")")"
PRJ_ROOT="$(dirname "$SWD")"

cd "${SWD}"

apt_install() {
    # /repo is not always available
    sudo DEBIAN_FRONTEND=noninteractive apt install --quiet --yes "$@"
}

sudo apt update

apt_install \
    curl git sshpass \
    python3 python3-pip \
    python3-netaddr python3-passlib python3-apt default-libmysqlclient-dev

mkdir --mode=0777 -p tmp
curl -fsSL https://jehon.github.io/packages/jehon.deb -o tmp/jehon.deb
apt_install ./tmp/jehon.deb

sudo apt update

if type direnv &>/dev/null ; then
    direnv allow "$PRJ_ROOT"/
fi

sudo /usr/sbin/jh-install-shellcheck
