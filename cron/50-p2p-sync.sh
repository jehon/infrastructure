#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../bin/conf-lib.sh"

##################################
#
# Config
#

target="${jhCloudFolderInUserHome}/Systèmes/vps/p2p.watch"

##################################
#
# Requirements
#

# shellcheck source=/dev/null
jh-wait-folder "${target}"

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-require "home" "work"

##################################
#
# Run
#

user_report_failure

# shellcheck source=/dev/null
. ~/.config/user-dirs.dirs

header_begin "Uploading desktop files to $vps_watch"
if find "$HOME/Téléchargements/" \( -name "*.torrent" -o -name "*.torrent.magnet" \); then
    # Not recursive, we take only first level one
    rsync "${jhRsyncOptions[@]}" \
        --remove-source-files \
        --include='*.torrent' --include='*.torrent.magnet' --exclude '*' \
        "$XDG_DOANLOAD_DIR/" "${target}"
fi
header_end
