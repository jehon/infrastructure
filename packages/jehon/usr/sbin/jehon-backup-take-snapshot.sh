#!/usr/bin/env bash

flavor=${1:?Need a flavor as [1]}

root="/var/backups"
from="${root}/daily"
to="${root}/${flavor}"

mkdir -p "$to"

if jh-fs "is-empty" "${from}"; then
    echo "No live data, exiting.."
    exit 0
fi

dt=$(date +%Y-%m-%d-%H.%M.%S)
for file in "$from"/*; do
    # http://stackoverflow.com/a/965072/1954789
    filename="$(basename "${file}")"
    dest="${dt}-${filename}"
    echo "File: ${file} -> ${dest}"
    cp "${file}" "${to}/${dest}"
done

# Remove duplicates backups files
#   Since too old files are removed before, we are sure
#   to keep one individual backup at anytime
fdupes "${to}" -f -r | head -n 1 | xargs --no-run-if-empty -I{} rm -v "{}"
