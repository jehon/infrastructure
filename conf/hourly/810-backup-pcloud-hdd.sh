#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../../bin/conf-lib.sh"

##################################
#
# Config
#

localHdd=/media/jehon/49dff6cc-57a5-4690-a5b6-0b4497f8e2f2
localTarget="${localHdd}/pcloud"
localBackup="${localHdd}/backup"
minFreeSpaceGb=10

##################################
#
# Requirements
#

# shellcheck source-path=SCRIPTDIR/../../packages/jehon/usr/bin/
. jh-run-only-daily

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-require "home"

# shellcheck source=/dev/null
jh-wait-folder "${localTarget}"

# shellcheck source=/dev/null
jh-wait-folder "${localBackup}"

##################################
#
# Run
#

user_report_failure

syncToLocalHdd() {
    folder="$1"
    {
        backupFolderRoot="${localBackup}/$folder"

        header_begin "Syncing"
        backup="${backupFolderRoot}/$jhTS"
        mkdir -p "$backup"
        echo " With backup to: $backup"

        rsync "${jhRsyncOptions[@]}" \
            --recursive --times --delete \
            --backup-dir "${backup}" \
            "${OPTS[@]}" "${jhCloudFolderInUserHome}/$folder/" "$localTarget/$folder"

        ok "Syncing $folder is done"
        header_end

        header_begin "Cleaning backups"
        # 30 days
        find "$backupFolderRoot" -type f -mtime +30 -delete
        find "$backupFolderRoot" -type d -empty -delete
        header_end
    } |& jh-tag-stdin "$folder"
}

syncToLocalHdd "Archives" || RES=1
syncToLocalHdd "Photos" || RES=1
syncToLocalHdd "Bibliothèque" || RES=1
syncToLocalHdd "Musiques" || RES=1

if [ "$RES" = 1 ]; then
    echo "Some sync did fail"
    exit 1
fi

if ! jh-disk-space-test.sh "$localHdd" $minFreeSpaceGb; then
    jh_fatal "Less than $minFreeSpaceGb remaining on disk"
fi
ok "Backup finished with success"
