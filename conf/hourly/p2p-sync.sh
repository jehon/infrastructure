#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../conf-lib.sh"

##################################
#
# Config
#

vps_watch="vps:/srv/p2p/watch/"
vps_uploaded="vps:/srv/p2p/downloaded"

cloud_watch="${jhCloudFolderInUserHome}/Workspaces/Jean/Videos/_p2p/Watch/"
cloud_uploaded="${jhCloudFolderInUserHome}/Workspaces/Jean/Videos/_p2p/"

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

rclone_run() {
    rclone \
        --verbose \
        --config "/etc/jehon/rclone.conf" \
        --exclude "@eaDir" --exclude "@eaDir/**" \
        --exclude "#recycle*" --exclude "Thumbs.*" \
        "$@"
}

header_begin "Uploading $cloud_watch to $vps_watch..."
rsync \
    --bwlimit=200KiB \
    --recursive --itemize-changes \
    --delete \
    "$cloud_watch" "$vps_watch"
rclone_run move --delete-empty-src-dirs "$cloud_watch" "$vps_watch"
header_end

header_begin "Uploading $vps_uploaded to $cloud_uploaded..."
rsync \
    --bwlimit=200KiB \
    --recursive --itemize-changes \
    --delete \
    "$vps_uploaded" "$cloud_uploaded"
header_end
