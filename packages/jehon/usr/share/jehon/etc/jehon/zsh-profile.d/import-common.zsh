#!/usr/bin/zsh

# shellcheck shell=bash # FIXME: shellcheck for zsh

#
# Load common profiles
#

if [ -d /etc/jehon/profile.d ]; then
    for ic in /etc/jehon/profile.d/*.sh; do
        if [ -r "$ic" ]; then
            # echo "Importing common $ic"
            # shellcheck source=/dev/null
            . "$ic"
        else
            echo "Skipping $ic" >&2
        fi
    done
    unset ic
fi
