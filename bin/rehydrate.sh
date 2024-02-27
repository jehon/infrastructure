#!/usr/bin/bash

set -o errexit

SWD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR/
. "$SWD/lib.sh"

echo "chmod bin..."
find tmp -type f -path "*/bin/*" -exec "chmod" "-v" "+x" "{}" ";"
echo "chmod bin done"

echo "touch built..."
touch tmp/mark
find tmp -type f -name "*built" -print -and -exec "touch" "-m" "--reference=tmp/mark" "{}" ";"
echo "touch built done"
