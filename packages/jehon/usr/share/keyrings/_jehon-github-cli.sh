#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${_SD}/_jehon_lib.sh"

getGPGKeyRaw "https://cli.github.com/packages/githubcli-archive-keyring.gpg"
