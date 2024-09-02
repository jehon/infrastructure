#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

LSD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR/
. "${LSD}/../bin/lib.sh"

scriptName="$(basename "$0")"

user_report() {
    echo "${jhTS} $(basename "$0"): $*" | tee -a ~/Desktop/log.txt
}

user_report_failure() {
    exec >& >(jh-tag-stdin "$scriptName" | tee -a ~/Desktop/err.txt)
    jh_on_exit_failure "user_report failure"
}

jhRsyncOptions=(
    "--itemize-changes"
)
if [ -z "$JH_DAEMON" ]; then
    echo "RSync in interactive mode"
    jhRsyncOptions+=(
        "--progress"
    )
else
    jhRsyncOptions+=(
        "--bwlimit=400KiB"
    )
fi
export jhRsyncOptions
