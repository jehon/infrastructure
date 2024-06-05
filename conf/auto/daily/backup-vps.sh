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

latestDir="${target}/data/latest"
backupDir="${target}/data/${JH_TIMESTAMP}"
mkdir -p "${backupDir}"
mkdir -p "${target}/data/latest"
rsync --recursive --itemize-changes \
    --backup --backup-dir="${backupDir}" \
    --delete \
    vps:/mnt/data/ "${latestDir}"

find "${target}/data/" -type d -mindepth 1 -empty -delete
