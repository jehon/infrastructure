#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${_SD}/_jehon_lib.sh"

getGPGKeyArmored "https://download.docker.com/linux/ubuntu/gpg"
