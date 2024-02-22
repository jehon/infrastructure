#!/usr/bin/env bash

set -o errexit
set -o pipefail

PRJ_ROOT="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
export PRJ_ROOT
export PATH="$PRJ_ROOT/.python/bin/:$PATH"
export PYTHONPATH="$PRJ_ROOT/.python"
export PRJ_TMP="$PRJ_ROOT/tmp"

mkdir -p "$PRJ_ROOT/tmp"

mkdir -p "$PRJ_TMP"

runDockerCompose() {
    docker compose --project-directory "$PRJ_ROOT" --env-file=/etc/jehon/restricted/jenkins.env "$@"
}
