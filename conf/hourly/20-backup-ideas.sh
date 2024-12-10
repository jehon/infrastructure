#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../conf-lib.sh"

##################################
#
# Config
#

target="${jhCloudFolderInUserHome}/Workspaces/Jean/Backups/Ideas"

##################################
#
# Requirements
#

# shellcheck source=/dev/null
jh-wait-folder "${target}"

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-require "home" "work"

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

    rsync "${jhRsyncOptions[@]}" \
        --recursive --times --omit-dir-times \
        --delete --delete-excluded \
        --exclude .git --exclude target --filter=':- .gitignore' \
        "$source" "$syncTarget"
    header_end
}

syncOne ~/restricted/ideas/1/
