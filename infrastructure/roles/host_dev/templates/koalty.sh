#!/usr/bin/env bash

# Installed by ansible

set -o errexit

export KOALTY_FTP_HOST="{{jehon.credentials.koalty.ftp.host}}"
export KOALTY_FTP_USER="{{jehon.credentials.koalty.ftp.user}}"
export KOALTY_FTP_PASS="{{jehon.credentials.koalty.ftp.pass}}"

if [ -n "$1" ]; then
    "$@"
fi
