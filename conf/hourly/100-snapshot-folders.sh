#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../conf-lib.sh"

##################################
#
# Config
#

systemsFolder="${jhCloudFolderInUserHome}/Systèmes/"
storage="${jhCloudFolderInUserHome}/Systèmes/backups/"

##################################
#
# Requirements
#

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-folder "${storage}"

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-folder "${systemsFolder}"

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-location-require "home" "work"

##################################
#
# Run
#

user_report_failure

snapshotOne() {
    source="${1:?Source of the snapshot}"
    name="${2:?Name of the snapshot}"

    if [ ! -r "$source" ]; then
        jh_fatal "Backup [$name]: $source not found"
    fi

    jh-snapshot-that.sh "$source" "$storage/$name"
}

snapshotOne "$systemsFolder"/vps/stack/volumes/mariadb.backup/ "vps-mariadb"

ok
