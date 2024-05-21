#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

# shellcheck source-path=SCRIPTDIR/../bin/
. jh-lib

flavor=${1:?Need a flavor as [1]}

root="${2:-"/var/backups"}"
from="${root}/snapshot/daily"
to="${root}/history/${flavor}"

jh_value_file "root" "${root}"
jh_value_file "from" "${from}"
jh_value_file "to" "${to}"

mkdir -p "$to"

if jh-fs "is-empty" "${from}"; then
    echo "No live data, exiting.."
    exit 0
fi

dt=$(date +%Y-%m-%d-%H.%M.%S)
while read -r -d $'\0' file; do
    filename="$(realpath --relative-to "${from}" "$file" | sed "s#/#--#")"
    dest="${to}/${dt}-${filename}"
    echo "File: ${file} -> ${dest}"
    cp "${file}" "${dest}"
done < <(find "${from}" -type f -print0)

# Remove duplicates backups files
#   Since too old files are removed before, we are sure
#   to keep one individual backup at anytime
fdupes "${to}" -f -r | head -n 1 | xargs --no-run-if-empty -I{} rm -v "{}"

case "${flavor}" in
"daily")
    # Remove too old backups: 40 days old
    find "${to}/" -mtime +40 -delete
    ;;

"monthly")
    # Remove too old backups: 2 years old...
    find "${to}/" -mtime +730 -delete
    ;;

*)
    echo "Unknown flavor: ${flavor}" >&2
    ;;
esac
