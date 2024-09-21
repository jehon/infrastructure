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

case "$(jh-location-detect)" in
"home")
    BANDWIDTH=400KiB # Bytes per seconds
    ;;
*)
    BANDWIDTH=100KiB
    ;;
esac
export BANDWIDTH

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
        "--bwlimit=$BANDWIDTH"
    )
fi
export jhRsyncOptions

stateFilesRadix="${prjRoot}/tmp/history/$(jh-fs "path-to-file" "$0")"
export stateFilesRadix

lockFile="${stateFilesRadix}.lock"

FORCE=""
if [ "$1" = "--force" ] || [ -z "$JH_RUNNER" ]; then
    echo "Forcing run"
    FORCE="force"
    jh_exclusive "${lockFile}" --force
else
    if ! jh_exclusive "${lockFile}"; then
        echo "Already running at ${lockFile}"
        exit 0
    fi
fi
export FORCE
