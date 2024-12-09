#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../conf-lib.sh"

##################################
#
# Config
#

target="${jhCloudFolderInUserHome}/Systèmes/vps/p2p"

##################################
#
# Requirements
#

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-folder "${target}"

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-require "home" "work"

##################################
#
# Run
#

user_report_failure

rsync "${jhRsyncOptions[@]}" \
    --recursive --times \
    --remove-source-files \
    --partial --append-verify \
    vps:/srv/stack/volumes/transmission.ready/ "$target/"

ok
