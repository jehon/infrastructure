#!/usr/bin/bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../../bin/
. jh-lib

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg > "$JH_SWD/jehon-github-cli.gpg"
