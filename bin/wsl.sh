#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../packages/jehon/usr/bin
. jh-lib

if ! jh-fs not-empty pCloudDrive ; then
    if [ -x ~/pcloud ]; then
        echo "Launching pcloud"
        JH_BACKGROUND_LOG=~/pcloud.wsl.log jh_background_process ~/pcloud
    else
        echo "No pcloud found."
    fi
fi

while true ; do
    jh-display-no-clear /usr/bin/jh-checks
    sleep 15s
done
