#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR/../
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../lib.sh

CLOUD_WATCH="cloud:/Workspaces/Jean/p2p/Watch/"
SYNO_WATCH="$MAIN_VOLUME/p2p/watch/"

SYNO_UPLOADED="$MAIN_VOLUME/p2p/downloaded"
CLOUD_UPLOADED="cloud:/Workspaces/Jean/p2p/"

echo "*** Uploading $SYNO_UPLOADED to $CLOUD_UPLOADED..."
rclone_run move --delete-empty-src-dirs "$SYNO_UPLOADED" "$CLOUD_UPLOADED"
echo "* Uploading done"

echo "*** Uploading $CLOUD_WATCH to $SYNO_WATCH..."
rclone_run move --delete-empty-src-dirs "$CLOUD_WATCH" "$SYNO_WATCH"
echo "* Getting watch files done"
