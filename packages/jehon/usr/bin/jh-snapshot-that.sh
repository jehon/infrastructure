#!/usr/bin/env bash

#
# https://mariadb.com/kb/en/mariadb-backups-overview-for-sql-server-users/
# https://mariadb.com/kb/en/full-backup-and-restore-with-mariabackup/
# https://mariadb.com/kb/en/mariabackup-options/
#

set -o errexit

# shellcheck source=/dev/null
. jh-lib

##################################
#
# Config
#

source="${1:?Source as [1]}" # Unused???
snapshotsRoot="${2:?SnapshotsRoot root as [2]}"

##################################
#
# Run
#

ts="$(date "+%Y-%m-%d--%H-%M-%S")"

jh_value "Timestamp" "$ts"
jh_value "From" "$source"
jh_value "Snapshot's root" "$snapshotsRoot"

mkdir -p "$snapshotsRoot"/daily
mkdir -p "$snapshotsRoot"/monthly
mkdir -p "$snapshotsRoot"/yearly

findExistNewerThanDays() {
    flavor="$1"
    daysAway="$2"

    find "$snapshotsRoot/$flavor" -mindepth 1 -maxdepth 1 -mtime -"$daysAway" | grep "" >/dev/null
}

removeOlderThanDays() {
    flavor="$1"
    daysAway="$2"
    header_begin "Remove backups older than $1"
    find "$snapshotsRoot/$flavor" -mindepth 1 -maxdepth 1 -mtime +"$daysAway" -exec rm -fr "{}" ";"
    header_end
}

header_begin "Import daily snapshot"
(
    rsync -ri "$source" "$snapshotsRoot/daily/$ts"
    removeOlderThanDays "daily" 90
) | jh-tag-stdin "daily"

last_daily="$(find "$snapshotsRoot"/daily -mindepth 1 -maxdepth 1 | sort | tail -n 1)"
last_daily="$(basename "$last_daily")"
jh_value "Last Daily" "$last_daily"

if ! findExistNewerThanDays "monthly" 30; then
    (
        header_begin "Create monthly backup"
        rsync -a "$snapshotsRoot/daily/$last_daily" "$snapshotsRoot/monthly/"
        header_end

        removeOlderThanDays "monthly" 750
    ) | jh-tag-stdin "monthly"
fi

if ! findExistNewerThanDays "yearly" 365; then
    (
        header_begin "Create yearly backup"
        rsync -a "$snapshotsRoot/daily/$last_daily" "$snapshotsRoot/yearly/"
        header_end
    ) | jh-tag-stdin "yearly"
fi

ok
