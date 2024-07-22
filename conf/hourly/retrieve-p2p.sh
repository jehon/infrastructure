#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR/
. "${_SD}/../../bin/lib.sh"

# shellcheck source-path=SCRIPTDIR/../../
. "${prjRoot}"/bin/jh-run-only-daily

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-home-cloud

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-require "home"

syno_watch="synology:p2p/watch/"
syno_uploaded="synology:p2p/downloaded"

cloud_watch="${jhCloudFolderInUserHome}/Workspaces/Jean/p2p/Watch/"
cloud_uploaded="${jhCloudFolderInUserHome}/Workspaces/Jean/p2p/"

rclone_run() {
    rclone \
        --verbose \
        --config "/etc/jehon/rclone.conf" \
        --exclude "@eaDir" --exclude "@eaDir/**" \
        --exclude "#recycle*" --exclude "Thumbs.*" \
        "$@"
}

user_report_failure

header_begin "Uploading $cloud_watch to $syno_watch..."
rclone_run move --delete-empty-src-dirs "$cloud_watch" "$syno_watch"
header_end

header_begin "Uploading $syno_uploaded to $cloud_uploaded..."
rclone_run move --delete-empty-src-dirs "$syno_uploaded" "$cloud_uploaded"
header_end
