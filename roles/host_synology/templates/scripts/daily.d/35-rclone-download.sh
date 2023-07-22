#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../lib.sh

cd "$TMP"
ZIP="$TMP"/rclone.zip
EXT="$TMP"/rclone-zip
TARGET="$TMP"/rclone

date

echo "* Downloading rclone... "
rm -f "$ZIP"
/bin/curl -fsSL https://downloads.rclone.org/rclone-current-linux-arm.zip --output "$ZIP"
echo "* ...downloaded"

echo "* Extracting..."
rm -fr "$EXT"
mkdir "$EXT"
cd "$EXT"
7z x "$ZIP"
cd ..
echo "* ...extracted"

rclone_kill

echo "* Installing..."
rm -fr "$TARGET"
mv "$EXT"/rclone-v* "$TARGET"
rm -fr "$EXT"
echo "* ...installed"

echo "* Checking install..."
"$TARGET"/rclone version
echo "* ...checked"

echo "* Done"
