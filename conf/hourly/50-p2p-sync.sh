#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../conf-lib.sh"

##################################
#
# Config
#

vps_ssh="vps"
vps_ssh_user="jehon-daemon"
vps_root="/home/jehon-daemon/stack/volumes"
vps_watch="${vps_root}/torrents.var.watched/"
vps_downloaded="${vps_root}/torrents.var.ready/"

cloud_downloaded="${jhCloudFolderInUserHome}/Workspaces/Jean/Work/p2p/"

vps_ops=(
    -e "ssh -l $vps_ssh_user"
)

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
    "${vps_ops[@]}" \
    --recursive \
    --remove-source-files \
    --include='*.torrent' --include='*.torrent.magnet' --exclude '*' \
    "$HOME/Desktop/" "${vps_ssh}:${vps_watch}"
header_end

header_begin "Downloading $vps_downloaded to $cloud_downloaded"
rsync "${jhRsyncOptions[@]}" \
    "${vps_ops[@]}" \
    --recursive \
    --remove-source-files \
    "${vps_ssh}:${vps_downloaded}" "$cloud_downloaded"
header_end

header_begin "Cleaning remote"
ssh "$vps_ssh_user@$vps_ssh" find "$vps_downloaded" -type d -mindepth 1 -empty -delete
header_end
