#!/usr/bin/env bash

set -o errexit

echo "* Loading lib.sh..."

export MAIN_VOLUME="{{ data_volume }}"
# The path to the current script
export SCRIPTS_FOLDER="{{ script_folder }}"
export TMP="$SCRIPTS_FOLDER/../temp"
LOG="$TMP/$(basename "$0").log"
export LOG
export RCLONE="$TMP/rclone/rclone"

test_folder() {
    if [ ! -r "$2" ]; then
        echo "Folder $1 does not exists: $2" >&2
        exit 1
    fi
}
test_folder "SCRIPTS_FOLDER" "$SCRIPTS_FOLDER"

rclone_kill() {
    echo "* Killing running rclone..."
    pkill --echo --exact 'rclone' || true
    echo "* ...killed"
}

mkdir -p "$TMP"

echo "Log name: $LOG"

exec &> >(tee "$LOG")

date

rclone_run() {
    echo "Starting rclone with $*"
	"$TMP"/rclone/rclone \
		--verbose \
		--stats 99d \
		--config "$SCRIPTS_FOLDER"/config/rclone.conf \
		--bwlimit "500K" \
		--exclude "@eaDir" --exclude "@eaDir/**" \
        "$@"
    echo "Ended rclone with $*"
}

echo "* Loading lib done..."
