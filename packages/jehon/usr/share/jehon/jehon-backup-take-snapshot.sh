#!/usr/bin/env bash

FLAVOR=${1:?Need a flavor as [1]}

ROOT="/var/backups"

mkdir -p "$ROOT/$1"

dt=$(date +%Y-%m-%d-%H.%M.%S)
for file in "$ROOT"/live/*; do
    # http://stackoverflow.com/a/965072/1954789
    filename="$(basename "$file")"
    DEST="$FLAVOR/${dt}-${filename}"
    echo "File: $file -> $DEST"
    cp "$file" "$ROOT/$DEST"
done

# Remove duplicates backups files
#   Since too old files are removed before, we are sure
#   to keep one individual backup at anytime
fdupes "/var/backups/$FLAVOR" -f -r | head -n 1 | xargs --no-run-if-empty -I{} rm -v "{}"
