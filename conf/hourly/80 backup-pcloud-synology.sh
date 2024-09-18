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
"${prjRoot}"/bin/jh-wait-folder

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-require "home"

##################################
#
# Run
#

user_report_failure

syncToSynology() {
    folder="$1"
    {

        echo "Syncing $folder..."

        #
        # rclone help flags
        #  --max-backlog (Kb): the backlog size (checking files) - https://rclone.org/docs/#max-backlog-n
        #
        #
        # https://rclone.org/filtering/
        # https://rclone.org/docs/
        #
        # --stats 99d: print stats only every 99 days (https://forum.rclone.org/t/can-we-have-rsync-kind-of-logs-with-rclone/9110/2?u=jehon)
        # --bwlimit "500K": limit the bandwidth (at 500KBy/s, 1GByte = 30min)
        #

        #        --stats 99d \

        rclone \
            --verbose \
            --config "/etc/jehon/rclone.conf" \
            --bwlimit "400K" --transfers=1 \
            --exclude "@eaDir" --exclude "@eaDir/**" \
            --exclude "#recycle*" --exclude "Thumbs.*" \
            sync \
            "${jhCloudFolderInUserHome}/$folder" "synology:/$folder"

        ok "Syncing $folder is done"

    } |& jh-tag-stdin "$folder"
}

# Only to synology
syncToSynology "Videos" || RES=1

# Backup to hdd too
syncToSynology "Archives" || RES=1
syncToSynology "Photos" || RES=1
syncToSynology "Bibliothèque" || RES=1
syncToSynology "Musiques" || RES=1

if [ "$RES" = 1 ]; then
    echo "Some sync did fail"
    exit 1
fi

ok "Backup finished with success"
