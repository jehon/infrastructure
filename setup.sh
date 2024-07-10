#!/usr/bin/env bash

set -o errexit
set -o pipefail

prjRoot="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

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
    nodejs
    gnupg2
    python3-full python3-pip python3-autopep8 python3-netaddr python3-passlib python3-apt python3-termcolor
    git make sshpass
    default-libmysqlclient-dev
    # File-Organizer
    libimage-exiftool-perl ffmpeg exiftran rsync
)
root_or_sudo apt install --quiet --yes "${PKGS[@]}"
echo "* Installing packages done"

if ! type npm; then
    # npm is provided by node official package, but not by ubuntu package
    root_or_sudo apt install --quiet --yes npm
fi

echo "* Enabling direnv..."
direnv allow "$prjRoot"/
echo "* Enabling direnv done"
