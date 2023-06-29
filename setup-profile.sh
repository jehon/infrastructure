#!/usr/bin/bash

SWD="$(dirname "$( realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR
. jh-direnv-bashism

. "$SWD/.envrc"
