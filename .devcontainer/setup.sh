#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR/
. "$(dirname "${BASH_SOURCE[0]}")"/setup-dev.sh

apt_install vagrant virtualbox

vagrant plugin install virtualbox_WSL2

if type direnv &>/dev/null ; then
    direnv allow "$PRJ_ROOT"/
fi
