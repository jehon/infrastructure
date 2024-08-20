#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR/
. "${_SD}/../../bin/lib.sh"

##################################
#
# Config
#

target="${jhCloudFolderInUserHome}/Systèmes/vps"

##################################
#
# Requirements
#

# shellcheck source-path=SCRIPTDIR/../../
. "${prjRoot}"/bin/jh-run-only-daily

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-home-cloud "${target}"

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-exclude "mobile"

##################################
#
# Run
#

user_report_failure

header_begin "Full: Syncing data"
rsync --bwlimit=100KiB \
    --recursive --itemize-changes \
    vps:/var/backups/snapshot/full/ "${target}/snapshot/full/"
header_end
header_begin "Full: Taking snapshots"
jh-backup-take-snapshot.sh "${target}"
header_end

header_begin "Incremental: Syncing data"
latestDir="${target}/data/latest"
backupDir="${target}/data/${jhTS}"
mkdir -p "${backupDir}"
mkdir -p "${target}/data/latest"
rsync --bwlimit=100KiB \
    --recursive --itemize-changes \
    --backup --backup-dir="${backupDir}" \
    --delete \
    vps:/mnt/data/ "${latestDir}"
header_end

header_begin "Remove empty folders"
find "${target}/data/" -type d -empty -delete
header_end
