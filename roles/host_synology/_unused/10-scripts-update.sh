#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/../lib.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../lib.sh

ARCHIVE="$TMP/synology.tar"

echo "* Downloading new archive..."
curl -fsSL "https://jehon.github.io/devstack/synology.tar" --output "$ARCHIVE"
echo "* ...downloaded"

echo "* Extracting to $TMP/scripts"
rm -fr "$TMP"/scripts
mkdir "$TMP"/scripts
tar xvf "$ARCHIVE" -C "$TMP"/scripts
echo "* ...extracted"

echo "* Moving new scripts in place..."
rm -fr "$TMP/scripts.old"
mv "$ROOT/scripts" "$TMP/scripts.old"
mv "$TMP/scripts" "$ROOT/scripts"
echo "* ...moved"

echo "* New version: "
cat "$ROOT/scripts/version.txt"
