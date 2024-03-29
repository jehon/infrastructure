#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../
. "$(dirname "$( realpath "${BASH_SOURCE[0]}")")"/../lib.sh


echo "Syncing..."
# https://manpages.debian.org/bullseye/rsync/rsync.1.en.html#protect,
rsync \
    --recursive --links --times --omit-dir-times \
    --itemize-changes \
    --exclude @eaDir \
    --exclude .dtrash \
    --exclude .digikam \
    --exclude "*.db" \
    --delete --filter="P @eaDir/*" \
    "$MAIN_VOLUME/Photos/" \
    "$MAIN_VOLUME/photo/public/"
echo "Syncing done"
