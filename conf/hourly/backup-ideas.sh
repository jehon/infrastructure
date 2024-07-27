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

target="${jhCloudFolderInUserHome}/Workspaces/Jean/Professionnel/Backups/"

##################################
#
# Requirements
#

# shellcheck source-path=SCRIPTDIR/../../
. "${prjRoot}"/bin/jh-run-only-daily

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-home-cloud "${target}"

##################################
#
# Run
#

user_report_failure

syncOne() {
    source="$1"
    local syncTarget
    syncTarget="${target}/$(jh-fs "path-to-file" "$source")"

    header_begin "Backup of $source"

    rsync -i \
        --recursive --times --omit-dir-times \
        --delete --delete-excluded \
        --exclude .git --exclude target \
        "$source" "$syncTarget"
    header_end
}
