#!/usr/bin/env bash

set -o errexit
set -o pipefail

prjRoot="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
export prjRoot
export prjTmp="$prjRoot/tmp"

export PATH="${prjRoot}/tmp/python/common/bin/:${prjRoot}/packages/jehon/usr/bin/:$PATH"
export PYTHONPATH="$prjRoot/tmp/python/common"

# shellcheck source-path=SCRIPTDIR/../
. "${prjRoot}/packages/jehon/usr/bin/jh-lib"

mkdir -p "$prjTmp"

user_report() {
    echo "${jhTS} $(basename "$0"): $*" >>~/Desktop/log.txt
}

user_report_failure() {
    jh_on_exit_failure "user_report failure"
}
