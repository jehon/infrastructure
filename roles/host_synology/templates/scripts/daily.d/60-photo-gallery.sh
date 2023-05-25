#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../lib.sh

# https://manpages.debian.org/bullseye/rsync/rsync.1.en.html#protect,
rsync \
    --recursive --links --times --omit-dir-times \
    --delete --itemize-changes \
    --exclude @eaDir \
    --exclude .dtrash \
    --exclude .digikam \
    --exclude "*.db" \
    --delete-excluded --filter="P @eaDir" \
    "$MAIN_VOLUME/Photos/" \
    "$MAIN_VOLUME/photo/public/"
