#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../
. "$(dirname "$( realpath "${BASH_SOURCE[0]}")")"/../lib.sh

RES=0

syncOne() {
	SOURCE="$1"
	TARGET="$2"
	echo "************************************************"
	echo "*** Syncing $SOURCE to $TARGET..."
	echo "************************************************"
	if [ ! -r "$TARGET" ]; then
		echo "TARGET $TARGET not found"
		return 1
	fi

	#
	# rclone help flags
	#  --max-backlog (Kb): the backlog size (checking files) - https://rclone.org/docs/#max-backlog-n
	#
	#
	# https://rclone.org/filtering/
	# https://rclone.org/docs/
	#
	# --stats 99d: print stats only every 99 days (https://forum.rclone.org/t/can-we-have-rsync-kind-of-logs-with-rclone/9110/2?u=jehon)
	# --bwlimit "500K": limit the bandwidth (at 500KBy/s, 1GByte = 30min)
	#

	rclone_run \
		sync \
		"cloud:/$SOURCE" "$TARGET"

	echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
	echo "vvv Syncing $SOURCE to $TARGET done"
	echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
}

rclone_kill

syncOne "Documents" "$MAIN_VOLUME/Documents" || RES=1
syncOne "Photos" "$MAIN_VOLUME/Photos" || RES=1
syncOne "Bibliothèque" "$MAIN_VOLUME/Bibliothèque" || RES=1
syncOne "Musiques" "$MAIN_VOLUME/Musiques" || RES=1
syncOne "Videos" "$MAIN_VOLUME/Videos" || RES=1

if [ "$RES" = 1 ]; then
	echo "Some sync did fail"
	exit 1
fi

echo "ok"
