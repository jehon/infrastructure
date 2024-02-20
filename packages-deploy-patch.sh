#!/usr/bin/bash

# shellcheck source=/usr/bin/jh-lib
. jh-lib

if [ -z "$2" ]; then
    jh_fatal "Need [host] [source]"
fi

HOST="$1"
shift

while [ -n "$1" ]; do
    SOURCE="$1"
    DEST="${SOURCE#packages/*/}"
    jh_value "SOURCE" "$SOURCE"
    jh_value "DEST"   "$DEST"

    rsync -i --checksum "$SOURCE" "root@$HOST:/$DEST"
    # scp "$SOURCE" "root@$HOST:/$DEST"
    ok "Uploaded to $DEST"
    shift
done