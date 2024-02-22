#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

for S in bin/*-backup.sh ; do
    echo "*** backup $( basename "$S") "
    # "$S"
done

echo "*** All done"
