#!/usr/bin/env bash

set -o errexit
set -o pipefail

PRJ_ROOT="$( dirname "$(realpath "$( dirname "${BASH_SOURCE[0]}")")" )"
export PRJ_ROOT
export PATH="$PRJ_ROOT/.python/bin/:$PATH"
export PYTHONPATH="$PRJ_ROOT/.python"

mkdir -p "$PRJ_ROOT/tmp"
