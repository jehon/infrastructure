#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../conf-lib.sh"

##################################
#
# Config
#

vps_ssh="vps"
vps_watch="/srv/p2p/watch/"
vps_downloaded="/srv/p2p/ready/"

cloud_downloaded="${jhCloudFolderInUserHome}/Workspaces/Jean/Work/p2p/"

##################################
#
# Requirements
#

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-folder

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-require "home" "work"

##################################
#
# Run
#

user_report_failure

header_begin "Uploading desktop files to $vps_watch"
rsync "${jhRsyncOptions[@]}" \
    --recursive \
    --remove-source-files \
    --include='*.torrent' --include='*.torrent.magnet' --exclude '*' \
    "$HOME/Desktop/" "$vps_ssh:$vps_watch"
header_end

header_begin "Downloading $vps_downloaded to $cloud_downloaded"
rsync "${jhRsyncOptions[@]}" \
    --recursive \
    --remove-source-files \
    "$vps_ssh:$vps_downloaded" "$cloud_downloaded"
header_end

header_begin "Cleaning remote"
ssh vps find "$vps_downloaded" -type d -mindepth 1 -empty -delete
header_end