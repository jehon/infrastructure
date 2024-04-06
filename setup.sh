#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(dirname "$( realpath "${BASH_SOURCE[0]}")")"
PRJ_ROOT="$SWD"

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

root_or_sudo apt update

echo "* Installing strict minimum packages..."
root_or_sudo apt install --quiet --yes \
    ca-certificates \
    curl
echo "* Installing strict minimum packages done"

echo "* Installing packages..."
# git-restore-mtime: https://stackoverflow.com/a/64147402/1954789
root_or_sudo apt install --quiet --yes \
    direnv \
    exiftool \
    debhelper binutils-arm-linux-gnueabihf dirmngr apt-utils desktop-file-utils rsync devscripts \
    git-restore-mtime \
    shellcheck \
    gnupg2 \
	python3-full python3-pip python3-autopep8 python3-netaddr python3-passlib python3-apt \
    git make sshpass \
    default-libmysqlclient-dev \
    # For File-Organizer: \
    libimage-exiftool-perl ffmpeg exiftran rsync
echo "* Installing packages done"

echo "* Installing shellcheck..."
root_or_sudo "$PRJ_ROOT"/packages/jehon/usr/sbin/jh-install-shellcheck
echo "* Installing shellcheck done"

echo "* Enabling direnv..."
direnv allow "$PRJ_ROOT"/
echo "* Enabling direnv done"
