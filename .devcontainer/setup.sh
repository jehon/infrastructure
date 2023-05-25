#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(dirname "${BASH_SOURCE[0]}")"

PRJ_ROOT="$(dirname "$SWD")"
export PRJ_ROOT

export DEBIAN_FRONTEND=noninteractive

apt_install() {
    # /repo is not always available
    apt install --quiet --yes "$@"
}

apt update

apt_install curl git \
    python3 python3-pip python3-netaddr python3-passlib python3-apt \
    libmysqlclient-dev

mkdir -p tmp
chmod 777 tmp
curl -fsSL https://jehon.github.io/packages/jehon.deb -o tmp/jehon.deb
apt_install ./tmp/jehon.deb

if type direnv &>/dev/null ; then
    direnv allow "$PRJ_ROOT"/
fi
