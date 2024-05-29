#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
JH_PKG_FOLDER="$SWD"

export DEBIAN_FRONTEND=noninteractive

root_or_sudo() {
    if [ "$(id -u)" == "0" ]; then
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
PKGS=(
    direnv
    exiftool
    debhelper binutils-arm-linux-gnueabihf dirmngr apt-utils desktop-file-utils rsync devscripts
    # git-restore-mtime: https://stackoverflow.com/a/64147402/1954789
    git-restore-mtime
    shellcheck
    gnupg2
    python3-full python3-pip python3-autopep8 python3-netaddr python3-passlib python3-apt python3-termcolor
    git make sshpass
    default-libmysqlclient-dev
    # File-Organizer
    libimage-exiftool-perl ffmpeg exiftran rsync
)
root_or_sudo apt install --quiet --yes "${PKGS[@]}"
echo "* Installing packages done"

echo "* Installing shellcheck..."
root_or_sudo "$JH_PKG_FOLDER"/packages/jehon/usr/sbin/jh-install-shellcheck
echo "* Installing shellcheck done"

# TODO: remove node install?
if ! type node >&/dev/null; then
    echo "* Installing node (current)..."
    root_or_sudo "$JH_PKG_FOLDER"/packages/jehon/usr/sbin/jh-install-node current
    echo "* Installing node (current) done"
else
    echo "* Installing node (current): already installed"
fi

echo "* Enabling direnv..."
direnv allow "$JH_PKG_FOLDER"/
echo "* Enabling direnv done"
