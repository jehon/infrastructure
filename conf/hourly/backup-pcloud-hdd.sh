#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../conf-lib.sh"

##################################
#
# Config
#

##################################
#
# Requirements
#

# shellcheck source-path=SCRIPTDIR/../../
. "${prjRoot}"/bin/jh-run-only-daily

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-folder

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-require "home"

localHdd=/media/jehon/49dff6cc-57a5-4690-a5b6-0b4497f8e2f2/pcloud

##################################
#
# Run
#

user_report_failure

syncToLocalHdd() {
    folder="$1"
    {
        echo "Syncing $folder..."
        rsync \
            --itemize-changes \
            --recursive --delete \
            --bwlimit "400K" \
            "${jhCloudFolderInUserHome}/$folder" "$localHdd/$folder"

        # TODO: backup
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
