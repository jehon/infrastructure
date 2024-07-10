#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR/
. "${_SD}/../../../bin/lib.sh"

target="${jhCloudFolderInUserHome}/Systèmes/vps"

# shellcheck source-path=SCRIPTDIR/../../../
"${prjRoot}"/bin/jh-wait-home-cloud "${target}"

header_begin "Full: Syncing data"
rsync --recursive --itemize-changes \
    vps:/var/backups/snapshot/full/ "${target}/snapshot/full/"
header_end
header_begin "Full: Taking snapshots"
jh-backup-take-snapshot.sh "${target}"
header_end

header_begin "Incremental: Syncing data"
latestDir="${target}/data/latest"
backupDir="${target}/data/${JH_TIMESTAMP}"
mkdir -p "${backupDir}"
mkdir -p "${target}/data/latest"
rsync --recursive --itemize-changes \
    --backup --backup-dir="${backupDir}" \
    --delete \
    vps:/mnt/data/ "${latestDir}"
header_end

header_begin "Remove empty folders"
find "${target}/data/" -type d -empty -delete
header_end
