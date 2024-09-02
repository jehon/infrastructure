#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../conf-lib.sh"

##################################
#
# Config
#

vps_watch="vps:/srv/p2p/watch/"
vps_downloaded="vps:/srv/p2p/ready/"

cloud_downloaded="${jhCloudFolderInUserHome}/Workspaces/Jean/Work/p2p/"
cloud_watch="${cloud_downloaded}/Watch/"

##################################
#
# Requirements
#

# shellcheck source-path=SCRIPTDIR/../../
. "${prjRoot}"/bin/jh-run-only-daily

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-folder

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-exclude "mobile"

##################################
#
# Run
#

user_report_failure

header_begin "Uploading $cloud_watch to $vps_watch"
rsync "${jhRsyncOptions[@]}" \
    --recursive \
    --remove-source-files \
    "$cloud_watch" "$vps_watch"
header_end

header_begin "Downloading $vps_downloaded to $cloud_downloaded"
rsync "${jhRsyncOptions[@]}" \
    --recursive \
    --remove-source-files \
    "$vps_downloaded" "$cloud_downloaded"
header_end
