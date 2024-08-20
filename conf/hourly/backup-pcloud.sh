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

##################################
#
# Requirements
#

# shellcheck source-path=SCRIPTDIR/../../
. "${prjRoot}"/bin/jh-run-only-daily

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-home-cloud

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-exclude "mobile"

##################################
#
# Run
#

user_report_failure

syncOne() {
    folder="$1"
    echo "************************************************"
    echo "*** Syncing $folder..."
    echo "************************************************"

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

    echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
    echo "vvv Syncing $folder done"
    echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
}

syncOne "Archives" || RES=1
syncOne "Photos" || RES=1
syncOne "Bibliothèque" || RES=1
syncOne "Musiques" || RES=1
syncOne "Videos" || RES=1

if [ "$RES" = 1 ]; then
    echo "Some sync did fail"
    exit 1
fi

ok "Backup finished with success"
