#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(dirname "${BASH_SOURCE[0]}")"
PRJ_ROOT="$(dirname "$SWD")"

apt_install() {
    # /repo is not always available
    DEBIAN_FRONTEND=noninteractive apt install --quiet --yes "$@"
}

apt update

apt_install \
    curl git \
    python3 python3-pip \
    python3-netaddr python3-passlib python3-apt default-libmysqlclient-dev

mkdir --mode=0777 -p tmp
curl -fsSL https://jehon.github.io/packages/jehon.deb -o tmp/jehon.deb
apt_install ./tmp/jehon.deb

apt update

if type direnv &>/dev/null ; then
    direnv allow "$PRJ_ROOT"/
fi
