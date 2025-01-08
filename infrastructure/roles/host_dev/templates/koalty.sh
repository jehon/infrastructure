#!/usr/bin/env bash

# Installed by ansible

set -o errexit

export KOALTY_FTP_HOST="{{jehon_remote_koalty_ftp_host}}"
export KOALTY_FTP_USER="{{jehon_remote_koalty_ftp_user}}"
export KOALTY_FTP_PASS="{{jehon_remote_koalty_ftp_pass}}"

if [ -n "$1" ]; then
	"$@"
fi
