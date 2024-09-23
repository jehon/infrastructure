#!/usr/bin/env bash
set -o errexit

prjRoot="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
export prjRoot
export prjTmp="$prjRoot/tmp"

export PATH="${prjRoot}/tmp/python/common/bin/:${prjRoot}/packages/jehon/usr/bin/:$PATH"
export PYTHONPATH="$prjRoot/tmp/python/common"

# shellcheck source-path=SCRIPTDIR/../
. "${prjRoot}/packages/jehon/usr/bin/jh-lib"

mkdir -p "$prjTmp"

stateFilesRadix="${prjTmp}/history/$(jh-fs "path-to-file" "$0")"
export stateFilesRadix
