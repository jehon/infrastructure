#!/usr/bin/bash

set -o errexit

# shellcheck source-path=SCRIPTDIR/../../bin/
. jh-lib

curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor --yes -o "$JH_SWD/jehon-docker-debian.gpg"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor --yes -o "$JH_SWD/jehon-docker-ubuntu.gpg"
