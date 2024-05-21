#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR/
. "${_SD}/../../../bin/lib.sh"

target="${JH_CLOUD_USER}/Systèmes/vps"

rsync --recursive --itemize-changes \
    vps:/var/backups/snapshot/ "${target}/snapshot/"

jh-backup-take-snapshot.sh "${target}"

# TODO: backup data too...
