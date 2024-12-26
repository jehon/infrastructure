#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

LSD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR/
. "${LSD}/../bin/lib.sh"

user_report() {
    echo "${jhTS} $(basename "$0"): $*" | tee -a ~/Desktop/log.txt
}

user_report_failure() {
    # Logs are in the journalctl
    jh_on_exit_failure "user_report failure"
}

#
# Default values
#

case "$(jh-location-detect)" in
"home")
    BANDWIDTH=400KiB # Bytes per seconds
    ;;
*)
    BANDWIDTH=100KiB
    ;;
esac
export BANDWIDTH

#
# Are we forced ?
#

FORCE=""
if [ "$1" == "-f" ]; then
    echo "Forcing run"
    FORCE="force"
    BANDWIDTH=2MiB # Nearly unlimited
    jh_exclusive_kill
else
    if ! jh_exclusive; then
        echo "Already running"
        exit 0
    fi
fi
export FORCE

#
# Calculated values
#

jhRsyncOptions=(
    "--itemize-changes"
)
if [ -n "$FORCE" ]; then
    echo "RSync in interactive mode"
    jhRsyncOptions+=(
        "--progress"
    )
else
    jhRsyncOptions+=(
        "--bwlimit=$BANDWIDTH"
    )
fi
export jhRsyncOptions
