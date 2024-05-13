#!/usr/bin/bash

set -o errexit

set -o errexit

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/lib.sh"

echo "chmod bin..."
find tmp -type f -path "*/bin/*" -exec "chmod" "+x" "{}" ";"
echo "chmod bin done"

echo "touch built..."
touch tmp/mark
touch --reference=tmp/mark node_modules/.*
find tmp -exec "touch" "--reference=tmp/mark" "{}" ";"
echo "touch built done"
