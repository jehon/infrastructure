#!/usr/bin/env bash

# TODO: Already in main setup.sh,
#       but we need jehon.deb on the CI

export DEBIAN_FRONTEND=noninteractive

SWD="$(realpath --physical "$(dirname "${BASH_SOURCE[0]}")")"
ROOT="$(dirname "$SWD")"

. "${SWD}"/../../setup.sh

if [ -z "$PROD" ]; then
    # In the prod container, no need to have this
    curl -fsSL https://jehon.github.io/infrastructure/packages/jehon.deb --output jehon.deb
    root_or_sudo apt install --yes ./jehon.deb
fi
