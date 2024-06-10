#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

TARGET="$(basename "${BASH_SOURCE[1]}")"
TARGET="${TARGET/_jehon-/}"
TARGET="${TARGET/\.sh/}"
TARGET="${_SD}/jehon-${TARGET}.gpg"

getGPGKeyRaw() {
    URL="$1"
    echo "Getting key from ${URL}"
    curl -fsSL "${URL}" >"${TARGET}"
    echo "Saving to ${TARGET}"
}

getGPGKeyArmored() {
    URL="$1"
    echo "Getting key from ${URL} and encode it"
    curl -fsSL "${URL}" | gpg --dearmor --yes -o "${TARGET}"
    echo "Saving to ${TARGET}"
}
