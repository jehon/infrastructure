#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

# shellcheck source-path=SCRIPTDIR/../bin/
. jh-lib

root="${1:-"/var/backups"}"
from="${root}/snapshot/full"
to="${root}/history"

jh_value_file "root" "${root}"
jh_value_file "from" "${from}"
jh_value_file "to" "${to}"

mkdir -p "${to}/daily"
mkdir -p "${to}/monthly"

if jh-fs "is-empty" "${from}"; then
    echo "No live data, exiting.."
    exit 0
fi

dayly_dt=$(date +%Y-%m-%d-%H.%M.%S)
monthly_dt=$(date +%Y-%m)
while read -r -d $'\0' file; do
    filename="$(realpath --relative-to "${from}" "$file" | sed "s#/#--#")"
    daily_dest="${to}/daily/${dayly_dt}-${filename}"
    echo "Daily: ${file} -> ${daily_dest}"
    cp -f "${file}" "${daily_dest}"

    monthly_dest="${to}/monthly/${monthly_dt}-${filename}"
    if [ ! -r "${monthly_dest}" ]; then
        echo "Monthly: ${file} -> ${monthly_dest}"
        cp -f "${file}" "${monthly_dest}"
    fi
done < <(find "${from}" -type f -print0)

# Remove daily old backups - covered by monthly backup
find "${to}/daily/" -type f -mtime +31 -delete
find "${to}/daily/" -mindepth 1 -type d -empty -delete

# Remove monthly old backups: 2 years old...
find "${to}/monthly/" -type f -mtime +730 -delete
find "${to}/monthly/" -mindepth 1 -type d -empty -delete

# # Remove duplicates backups files
# #   Since too old files are removed before, we are sure
# #   to keep one individual backup at anytime
# # Problem: if the same data is in multiple files, this will cause a problem
# fdupes "${to}" -f -r | head -n 1 | xargs --no-run-if-empty -I{} rm -v "{}"
