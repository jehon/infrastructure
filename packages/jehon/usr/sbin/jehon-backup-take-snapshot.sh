#!/usr/bin/env bash

flavor=${1:?Need a flavor as [1]}

root="/var/backups"
from="${root}/snapshot/daily"
to="${root}/history/${flavor}"

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
