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

syno_uploaded="synology:p2p/downloaded"
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
"${prjRoot}"/bin/jh-location-require "home"

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

header_begin "Uploading $syno_uploaded to $cloud_uploaded..."
rclone_run move --delete-empty-src-dirs "$syno_uploaded" "$cloud_uploaded"
header_end