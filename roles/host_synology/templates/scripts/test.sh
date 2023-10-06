#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR
. "$(dirname "$( realpath "${BASH_SOURCE[0]}")")"/lib.sh

date

time "$SCRIPTS_FOLDER"/daily.d/90-remove-empty-folders.py

echo "Test script ended with success"
date
