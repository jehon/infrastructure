#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../conf-lib.sh"

##################################
#
# Config
#

localHdd=/media/jehon/49dff6cc-57a5-4690-a5b6-0b4497f8e2f2
localTarget="${localHdd}/pcloud"
localBackup="${localHdd}/backup"

##################################
#
# Requirements
#

# shellcheck source-path=SCRIPTDIR/../../
. "${prjRoot}"/bin/jh-run-only-daily

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-folder "$localTarget"
"${prjRoot}"/bin/jh-wait-folder "$localBackup"

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-require "home"

##################################
#
# Run
#

user_report_failure

syncToLocalHdd() {
    folder="$1"
    {
        backup="${localBackup}/$folder/$jhTS"

        echo "Syncing $folder..."
        echo " With backup to: $backup"
        rsync \
            --itemize-changes \
            --recursive --times --delete \
            --backup "${backup}" \
            --bwlimit "400K" \
            "${jhCloudFolderInUserHome}/$folder" "$localTarget/$folder"

        # TODO: remove old backups

        ok "Syncing $folder is done"
    } |& jh-tag-stdin "$folder"
}

syncToLocalHdd "Archives" || RES=1
syncToLocalHdd "Photos" || RES=1
syncToLocalHdd "Bibliothèque" || RES=1

if [ "$RES" = 1 ]; then
    echo "Some sync did fail"
    exit 1
fi

ok "Backup finished with success"
