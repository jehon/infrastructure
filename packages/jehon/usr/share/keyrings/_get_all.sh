#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

getGPGKey() {
    TARGET="$1"
    URL="$2"

    TARGET="${_SD}/jehon-${TARGET}.gpg"
    echo "Getting key from ${URL} to ${TARGET}"
    curl -fsSL "${URL}" >"${TARGET}"
    echo "Saving to ${TARGET}"
}

getGPGKeyAndDearmor() {
    TARGET="$1"
    URL="$2"

    TARGET="${_SD}/jehon-${TARGET}.gpg"
    echo "Getting key from ${URL} and encode it to ${TARGET}"
    curl -fsSL "${URL}" | gpg --dearmor --yes -o "${TARGET}"
    echo "Saving to ${TARGET}"
}

getGPGKeyAndDearmor "docker-ubuntu" "https://download.docker.com/linux/ubuntu/gpg"
getGPGKey "github-cli" "https://cli.github.com/packages/githubcli-archive-keyring.gpg"
getGPGKeyAndDearmor "hashicorp" "https://apt.releases.hashicorp.com/gpg"
getGPGKeyAndDearmor "node" "https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key"
getGPGKeyAndDearmor "virtualbox" "https://www.virtualbox.org/download/oracle_vbox_2016.asc"
