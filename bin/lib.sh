#!/usr/bin/env bash

set -o errexit
set -o pipefail

JH_PKG_FOLDER="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
export JH_PKG_FOLDER
export PATH="$JH_PKG_FOLDER/tmp/python/common/bin/:$PATH"
export PYTHONPATH="$JH_PKG_FOLDER/tmp/python/common"
export PRJ_TMP="$JH_PKG_FOLDER/tmp"

# shellcheck source-path=SCRIPTDIR/../
. "${JH_PKG_FOLDER}/packages/jehon/usr/bin/jh-lib"

mkdir -p "$JH_PKG_FOLDER/tmp"

mkdir -p "$PRJ_TMP"

runDockerCompose() {
    docker compose --project-directory "$JH_PKG_FOLDER" --env-file=/etc/jehon/restricted/jenkins.env "$@"
}
