#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR/
. "${_SD}/../../../bin/lib.sh"

target="${JH_CLOUD_USER}/Systèmes/vps"

mkdir -p "${target}/snapshot/full/"
rsync --recursive --itemize-changes \
    vps:/var/backups/snapshot/full/ "${target}/snapshot/full/"

jh-backup-take-snapshot.sh "${target}"

mkdir -p "${target}/data/${JH_TIMESTAMP}"
mkdir -p "${target}/data/latest"
rsync --recursive --itemize-changes \
    --backup --backup-dir="${target}/data/${JH_TIMESTAMP}" \
    --delete \
    vps:/mnt/data/ "${target}/data/latest"
