#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR/
. "${_SD}/../../bin/lib.sh"

user_report_failure

# shellcheck source-path=SCRIPTDIR/../../
. "${prjRoot}"/bin/jh-run-only-daily

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-home-cloud

rclone_run() {
    rclone \
        --verbose \
        --config "/etc/jehon/rclone.conf" \
        --exclude "@eaDir" --exclude "@eaDir/**" \
        --exclude "#recycle*" --exclude "Thumbs.*" \
        "$@"
}

SYNO_WATCH="synology:p2p/watch/"
SYNO_UPLOADED="synology:p2p/downloaded"

CLOUD_WATCH="${jhCloudFolderInUserHome}/Workspaces/Jean/p2p/Watch/"
CLOUD_UPLOADED="${jhCloudFolderInUserHome}/Workspaces/Jean/p2p/"

header_begin "Uploading $CLOUD_WATCH to $SYNO_WATCH..."
rclone_run move --delete-empty-src-dirs "$CLOUD_WATCH" "$SYNO_WATCH"
header_end

header_begin "Uploading $SYNO_UPLOADED to $CLOUD_UPLOADED..."
rclone_run move --delete-empty-src-dirs "$SYNO_UPLOADED" "$CLOUD_UPLOADED"
header_end
