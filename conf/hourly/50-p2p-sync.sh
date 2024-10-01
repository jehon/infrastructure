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
vps_watch="${vps_root}/torrents.watched.var/"

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
if find "$HOME/Desktop/" \( -name "*.torrent" -o -name "*.torrent.magnet" \); then
    rsync "${jhRsyncOptions[@]}" \
        "${vps_ops[@]}" \
        --recursive \
        --remove-source-files \
        --include='*.torrent' --include='*.torrent.magnet' --exclude '*' \
        "$HOME/Desktop/" "${vps_ssh}:${vps_watch}"
    header_end
fi
