#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR/../
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/lib.sh

upload() {
    SOURCE="$1"
    N="$( basename "$1" )"

    TARGET="cloud:/Workspaces/Jean/p2p/$N"

    echo "************************************************"
    echo "*** Syncing $SOURCE to $TARGET..."
    echo "************************************************"

    rclone_run mv "$SOURCE" "$TARGET"
}

if [ -n "$1" ]; then
    upload "$1"
else
    for F in "$MAIN_VOLUME/p2p/downloaded/"*; do
        upload "$F"
    done
fi
