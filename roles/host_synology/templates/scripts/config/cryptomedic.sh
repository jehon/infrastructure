#!/usr/bin/env bash

# Installed by ansible

set -o errexit

export CRYPTOMEDIC_DEPLOY_WEB_HOST="{{jehon.credentials.cryptomedic.http_host}}"
export CRYPTOMEDIC_DEPLOY_WEB_PORT="{{jehon.credentials.cryptomedic.http_port}}"
export CRYPTOMEDIC_DEPLOY_WEB_TOKEN="{{jehon.credentials.cryptomedic.http_token}}"

export CRYPTOMEDIC_DEPLOY_FILES_HOST="{{jehon.credentials.cryptomedic.deploy_host}}"
export CRYPTOMEDIC_DEPLOY_FILES_USER="{{jehon.credentials.cryptomedic.deploy_user}}"
export CRYPTOMEDIC_DEPLOY_FILES_PASSWORD="{{jehon.credentials.cryptomedic.deploy_password}}"

if [ -n "$1" ]; then
    "$@"
fi
