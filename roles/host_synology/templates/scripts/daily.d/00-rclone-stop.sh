#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../
. "$(dirname "$( realpath "${BASH_SOURCE[0]}")")"/../lib.sh

echo "* Currently running"
# shellcheck disable=SC2009 # pgrep does not exist on synology
ps -e | grep rclone || true

rclone_kill

echo "ok"
