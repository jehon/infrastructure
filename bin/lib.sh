#!/usr/bin/env bash

set -o errexit
set -o pipefail

prjFolder="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
export prjFolder
export prjTmp="$JH_PKG_FOLDER/tmp"

export PATH="${JH_PKG_FOLDER}/tmp/python/common/bin/:${JH_PKG_FOLDER}/packages/jehon/usr/bin/:$PATH"
export PYTHONPATH="$JH_PKG_FOLDER/tmp/python/common"

# FIXME(legacy): Old notation
export PRJ_TMP="${prjTmp}"
export JH_PKG_FOLDER="${prjFolder}"

# shellcheck source-path=SCRIPTDIR/../
. "${prjFolder}/packages/jehon/usr/bin/jh-lib"

mkdir -p "$prjTmp"
